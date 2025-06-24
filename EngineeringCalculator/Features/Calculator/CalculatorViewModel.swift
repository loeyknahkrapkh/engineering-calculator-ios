import Foundation
import Combine

/// Calculator 화면의 ViewModel
/// MVVM 패턴과 Protocol Oriented Programming을 적용하여 설계
@MainActor
public class CalculatorViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 화면에 표시될 텍스트
    @Published var displayText: String = "0"
    
    /// 현재 입력 중인 수식
    @Published var currentExpression: String = ""
    
    /// 새로운 숫자 입력 시작 여부
    @Published var isNewNumber: Bool = true
    
    /// 계산기 설정
    @Published var settings: CalculatorSettings
    
    /// 현재 에러 상태 여부
    @Published var hasError: Bool = false
    
    /// 에러 메시지
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    
    private let calculatorEngine: CalculatorEngine
    private let settingsStorage: SettingsStorage
    private let historyStorage: HistoryStorage
    private let helpContentProvider: HelpContentProvider
    
    // MARK: - Private Properties
    
    /// 현재 입력 중인 숫자
    private var currentNumber: String = "0"
    
    /// 마지막 연산자 위치 추적
    private var lastOperatorIndex: String.Index?
    
    /// 괄호 카운터
    private var openParenthesesCount: Int = 0
    
    /// 함수 설명 캐시
    private var functionDescriptions: [String: FunctionDescription] = [:]
    
    /// 팁 캐시
    private var allTips: [CalculatorTip] = []
    
    // MARK: - Initialization
    
    public init(
        calculatorEngine: CalculatorEngine,
        settingsStorage: SettingsStorage,
        historyStorage: HistoryStorage,
        helpContentProvider: HelpContentProvider = DefaultHelpContentProvider()
    ) {
        self.calculatorEngine = calculatorEngine
        self.settingsStorage = settingsStorage
        self.historyStorage = historyStorage
        self.helpContentProvider = helpContentProvider
        self.settings = settingsStorage.loadSettings()
        
        // 엔진에 설정 적용
        var mutableEngine = calculatorEngine
        mutableEngine.angleUnit = settings.angleUnit
        
        // 도움말 컨텐츠 로드
        loadHelpContent()
    }
    
    // MARK: - Public Methods
    
    /// 버튼 입력 처리 메인 함수
    /// - Parameter button: 입력된 버튼
    public func handleButtonPress(_ button: CalculatorButton) {
        clearError()
        
        switch button.buttonType {
        case .number:
            handleNumberInput(button)
        case .operator:
            if button == .equals {
                performCalculation()
            } else {
                handleOperatorInput(button)
            }
        case .function:
            handleFunctionInput(button)
        case .constant:
            handleConstantInput(button)
        case .utility:
            handleUtilityInput(button)
        case .special:
            handleSpecialInput(button)
        }
    }
    
    // MARK: - Private Number Input Methods
    
    /// 숫자 입력 처리
    private func handleNumberInput(_ button: CalculatorButton) {
        let digit = button.rawValue
        
        if isNewNumber {
            currentNumber = digit
            displayText = digit
            isNewNumber = false
        } else {
            // 0으로 시작하는 경우 처리
            if currentNumber == "0" && digit != "." {
                currentNumber = digit
                displayText = digit
            } else {
                currentNumber += digit
                displayText = currentNumber
            }
        }
    }
    
    /// 소수점 입력 처리
    private func handleDecimalInput() {
        if isNewNumber {
            currentNumber = "0."
            displayText = "0."
            isNewNumber = false
        } else {
            // 이미 소수점이 있는지 확인
            if !currentNumber.contains(".") {
                currentNumber += "."
                displayText = currentNumber
            }
        }
    }
    
    // MARK: - Private Operator Input Methods
    
    /// 연산자 입력 처리
    private func handleOperatorInput(_ button: CalculatorButton) {
        let operatorSymbol = button.calculationString
        
        // 현재 입력된 숫자를 수식에 추가
        if !isNewNumber {
            currentExpression += currentNumber
        }
        
        // 연속된 연산자 처리 (마지막 문자가 연산자인 경우 교체)
        if let lastChar = currentExpression.last,
           isOperatorCharacter(String(lastChar)) {
            currentExpression = String(currentExpression.dropLast())
        }
        
        currentExpression += operatorSymbol
        lastOperatorIndex = currentExpression.index(before: currentExpression.endIndex)
        isNewNumber = true
        currentNumber = "0"
    }
    
    /// 문자가 연산자인지 확인
    private func isOperatorCharacter(_ char: String) -> Bool {
        return ["+", "-", "*", "/", "^"].contains(char)
    }
    
    // MARK: - Private Function Input Methods
    
    /// 함수 입력 처리
    private func handleFunctionInput(_ button: CalculatorButton) {
        let functionName = button.calculationString
        
        // 새로운 숫자가 아니고 현재 숫자가 입력되어 있다면 수식에 추가
        if !isNewNumber && currentNumber != "0" {
            currentExpression += currentNumber
        }
        
        // 함수는 괄호를 포함하여 추가
        currentExpression += functionName + "("
        openParenthesesCount += 1
        
        displayText = functionName + "("
        isNewNumber = true
        currentNumber = "0"
    }
    
    /// 상수 입력 처리
    private func handleConstantInput(_ button: CalculatorButton) {
        let constantSymbol = button.calculationString
        
        if isNewNumber {
            currentExpression += constantSymbol
            displayText = button.displayText
            isNewNumber = false
            currentNumber = constantSymbol
        } else {
            // 이미 숫자가 입력된 상태에서는 곱셈으로 처리
            currentExpression += currentNumber + "*" + constantSymbol
            displayText = button.displayText
            isNewNumber = false
            currentNumber = constantSymbol
        }
    }
    
    // MARK: - Private Utility Input Methods
    
    /// 유틸리티 버튼 입력 처리
    private func handleUtilityInput(_ button: CalculatorButton) {
        switch button {
        case .clear:
            clear()
        case .decimal:
            handleDecimalInput()
        case .plusMinus:
            handlePlusMinusInput()
        case .percent:
            handlePercentInput()
        case .openParenthesis:
            handleOpenParenthesis()
        case .closeParenthesis:
            handleCloseParenthesis()
        case .backspace:
            handleBackspace()
        default:
            break
        }
    }
    
    /// Clear 버튼 처리
    private func clear() {
        displayText = "0"
        currentExpression = ""
        currentNumber = "0"
        isNewNumber = true
        openParenthesesCount = 0
        clearError()
    }
    
    /// Plus/Minus 버튼 처리
    private func handlePlusMinusInput() {
        if currentNumber == "0" || isNewNumber {
            return
        }
        
        if currentNumber.hasPrefix("-") {
            currentNumber = String(currentNumber.dropFirst())
        } else {
            currentNumber = "-" + currentNumber
        }
        
        displayText = currentNumber
    }
    
    /// Percent 버튼 처리
    private func handlePercentInput() {
        if let number = Double(currentNumber) {
            let percentValue = number / 100.0
            currentNumber = calculatorEngine.formatResult(percentValue)
            displayText = currentNumber
        }
    }
    
    /// 여는 괄호 처리
    private func handleOpenParenthesis() {
        if !isNewNumber && currentNumber != "0" {
            currentExpression += currentNumber + "*("
        } else {
            currentExpression += "("
        }
        
        openParenthesesCount += 1
        displayText = "("
        isNewNumber = true
        currentNumber = "0"
    }
    
    /// 닫는 괄호 처리
    private func handleCloseParenthesis() {
        guard openParenthesesCount > 0 else { return }
        
        if !isNewNumber {
            currentExpression += currentNumber
        }
        
        currentExpression += ")"
        openParenthesesCount -= 1
        displayText = ")"
        isNewNumber = true
        currentNumber = "0"
    }
    
    /// Backspace 버튼 처리
    private func handleBackspace() {
        if isNewNumber || currentNumber.count <= 1 {
            currentNumber = "0"
            displayText = "0"
            isNewNumber = true
        } else {
            currentNumber = String(currentNumber.dropLast())
            displayText = currentNumber
        }
    }
    
    // MARK: - Private Special Input Methods
    
    /// 특수 기능 버튼 입력 처리
    private func handleSpecialInput(_ button: CalculatorButton) {
        switch button {
        case .angleUnit:
            toggleAngleUnit()
        case .history:
            // 히스토리 화면 표시는 View에서 처리
            break
        case .help:
            // 도움말 화면 표시는 View에서 처리
            break
        case .unitConverter:
            // 단위 변환 화면 표시는 View에서 처리
            break
        default:
            break
        }
    }
    
    // MARK: - Private Calculation Methods
    
    /// 계산 실행
    private func performCalculation() {
        var expression = currentExpression
        
        // 현재 입력된 숫자가 있다면 추가
        if !isNewNumber && currentNumber != "0" {
            expression += currentNumber
        }
        
        // 열린 괄호가 있다면 자동으로 닫기
        while openParenthesesCount > 0 {
            expression += ")"
            openParenthesesCount -= 1
        }
        
        // 빈 수식 처리
        if expression.isEmpty {
            return
        }
        
        do {
            let result = try calculatorEngine.calculate(expression)
            let formattedResult = calculatorEngine.formatResult(result)
            
            // 결과 표시
            displayText = formattedResult
            
            // 히스토리 저장
            if settings.autoSaveHistory {
                saveToHistory(expression: expression, result: result)
            }
            
            // 새로운 계산 준비
            currentExpression = ""
            currentNumber = formattedResult
            isNewNumber = true
            
        } catch let error as CalculatorError {
            handleCalculationError(error)
            
            // 에러 히스토리 저장
            if settings.autoSaveHistory {
                saveErrorToHistory(expression: expression, error: error.localizedDescription)
            }
        } catch {
            handleCalculationError(.invalidExpression)
        }
    }
    
    /// 계산 에러 처리
    private func handleCalculationError(_ error: CalculatorError) {
        hasError = true
        errorMessage = error.localizedDescription
        displayText = "Error"
        isNewNumber = true
        currentNumber = "0"
        currentExpression = ""
        openParenthesesCount = 0
    }
    
    /// 에러 상태 클리어
    private func clearError() {
        hasError = false
        errorMessage = nil
    }
    
    // MARK: - Private History Methods
    
    /// 성공한 계산을 히스토리에 저장
    private func saveToHistory(expression: String, result: Double) {
        let history = CalculationHistory(
            expression: expression,
            result: result,
            angleUnit: settings.angleUnit
        )
        
        do {
            try historyStorage.saveHistory(history)
        } catch {
            // 히스토리 저장 실패는 조용히 처리
            print("Failed to save history: \(error)")
        }
    }
    
    /// 에러 계산을 히스토리에 저장
    private func saveErrorToHistory(expression: String, error: String) {
        let history = CalculationHistory(
            expression: expression,
            error: error,
            angleUnit: settings.angleUnit
        )
        
        do {
            try historyStorage.saveHistory(history)
        } catch {
            // 히스토리 저장 실패는 조용히 처리
            print("Failed to save error history: \(error)")
        }
    }
}

// MARK: - Public Helper Methods

extension CalculatorViewModel {
    
    /// 특정 히스토리 항목을 재사용
    /// - Parameter history: 재사용할 히스토리 항목
    func reuseHistory(_ history: CalculationHistory) {
        guard !history.hasError else { return }
        
        currentExpression = history.expression
        displayText = history.formattedResult
        currentNumber = history.formattedResult
        isNewNumber = true
        clearError()
    }
    
    /// 히스토리에서 수식을 불러와서 현재 계산기에 설정
    /// - Parameter expression: 불러올 수식
    public func loadExpressionFromHistory(_ expression: String) {
        clearError()
        
        if expression.isEmpty {
            currentExpression = ""
            displayText = "0"
            currentNumber = "0"
            isNewNumber = true
        } else {
            currentExpression = expression
            displayText = expression
            currentNumber = "0"
            isNewNumber = false
        }
        
        // 괄호 카운터 초기화
        openParenthesesCount = 0
    }
    
    /// 현재 상태가 계산 가능한지 확인
    var canCalculate: Bool {
        return !currentExpression.isEmpty || (!isNewNumber && currentNumber != "0")
    }
    
    /// 현재 각도 단위 표시 텍스트
    var angleUnitDisplayText: String {
        return settings.angleUnit == .radian ? "rad" : "deg"
    }
    
    /// 제곱 함수 처리 (x²)
    func handleSquare() {
        if !isNewNumber && currentNumber != "0" {
            let squareExpression = "(\(currentNumber))^2"
            currentExpression += squareExpression
            isNewNumber = true
            currentNumber = "0"
            displayText = "(\(currentNumber))²"
        }
    }
    
    /// 각도 단위 토글 (public method)
    func toggleAngleUnit() {
        settings.toggleAngleUnit()
        
        // 엔진에 설정 적용
        var mutableEngine = calculatorEngine
        mutableEngine.angleUnit = settings.angleUnit
        
        // 설정 저장
        settingsStorage.saveSettings(settings)
        
        // 상태 변경 알림
        notifyStateChange()
    }
    
    /// 히스토리 저장소에 대한 읽기 전용 접근자
    func getHistoryStorage() -> HistoryStorage {
        return historyStorage
    }
}

// MARK: - Interactive Help Methods

extension CalculatorViewModel {
    
    /// 도움말 컨텐츠 로드
    private func loadHelpContent() {
        do {
            // 함수 설명 로드
            let functions = try helpContentProvider.loadFunctionDescriptions()
            functionDescriptions = Dictionary(uniqueKeysWithValues: functions.map { ($0.symbol, $0) })
            
            // 팁 로드
            allTips = try helpContentProvider.loadCalculatorTips()
        } catch {
            print("Failed to load help content: \(error)")
        }
    }
    
    /// 특정 버튼에 대한 함수 설명 가져오기
    /// - Parameter button: 설명을 가져올 버튼
    /// - Returns: 함수 설명 (없으면 nil)
    public func getFunctionDescription(for button: CalculatorButton) -> FunctionDescription? {
        // 함수나 상수 버튼만 설명 제공
        guard button.buttonType == .function || button.buttonType == .constant else {
            return nil
        }
        
        // 버튼 심볼을 함수 설명 심볼로 매핑
        let symbol = mapButtonToSymbol(button)
        return functionDescriptions[symbol]
    }
    
    /// 버튼을 함수 설명 심볼로 매핑
    private func mapButtonToSymbol(_ button: CalculatorButton) -> String {
        switch button {
        case .sin: return "sin"
        case .cos: return "cos"
        case .tan: return "tan"
        case .asin: return "asin"
        case .acos: return "acos"
        case .atan: return "atan"
        case .ln: return "ln"
        case .log: return "log"
        case .log2: return "log₂"
        case .exp: return "eˣ"
        case .pow10: return "10ˣ"
        case .sqrt: return "√"
        case .cbrt: return "∛"
        case .power: return "xʸ"
        case .pi: return "π"
        case .e: return "e"
        default: return button.displayText
        }
    }
    
    /// 일일 팁을 표시해야 하는지 확인
    /// - Returns: 일일 팁 표시 여부
    public func shouldShowDailyTip() -> Bool {
        let lastShownDate = UserDefaults.standard.object(forKey: "LastDailyTipDate") as? Date
        let today = Calendar.current.startOfDay(for: Date())
        
        // 마지막으로 표시한 날짜가 오늘이 아니면 표시
        if let lastDate = lastShownDate {
            let lastShownDay = Calendar.current.startOfDay(for: lastDate)
            return lastShownDay < today
        }
        
        return true // 한번도 표시하지 않았으면 표시
    }
    
    /// 오늘의 일일 팁 가져오기
    /// - Returns: 일일 팁 (없으면 nil)
    public func getDailyTip() -> CalculatorTip? {
        return helpContentProvider.getDailyTip()
    }
    
    /// 일일 팁을 표시했음을 기록
    public func markDailyTipAsShown() {
        UserDefaults.standard.set(Date(), forKey: "LastDailyTipDate")
    }
    
    /// 카테고리별 팁 가져오기
    /// - Parameter category: 팁 카테고리
    /// - Returns: 해당 카테고리의 팁들
    public func getTipsForCategory(_ category: TipCategory) -> [CalculatorTip] {
        return allTips.filter { $0.category == category }
    }
    
    /// 난이도별로 정렬된 모든 팁 가져오기
    /// - Returns: 난이도별로 정렬된 팁들
    public func getAllTipsSortedByDifficulty() -> [CalculatorTip] {
        return allTips.sorted { $0.difficulty.sortOrder < $1.difficulty.sortOrder }
    }
}

// MARK: - App State Management

extension CalculatorViewModel {
    
    /// 설정을 다시 로드
    func loadSettings() {
        let newSettings = settingsStorage.loadSettings()
        if newSettings != settings {
            settings = newSettings
            
            // 엔진에 새 설정 적용
            var mutableEngine = calculatorEngine
            mutableEngine.angleUnit = settings.angleUnit
        }
    }
    
    /// 임시 데이터 정리 (메모리 관리)
    func clearTemporaryData() {
        // 불필요한 캐시 정리
        functionDescriptions.removeAll()
        allTips.removeAll()
        
        // 도움말 컨텐츠 다시 로드 (필요시)
        loadHelpContent()
    }
    
    /// 현재 상태를 AppContainer에 알림
    private func notifyStateChange() {
        // AppContainer의 markAsChanged() 호출은 AppContainer에서 직접 처리
        NotificationCenter.default.post(name: .calculatorStateChanged, object: nil)
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let calculatorStateChanged = Notification.Name("CalculatorStateChanged")
} 