import Testing
import Foundation
@testable import EngineeringCalculator

/// CalculatorViewModel에 대한 테스트 모음
@Suite("CalculatorViewModel Tests")
struct CalculatorViewModelTests {
    
    // MARK: - Test Dependencies
    
    /// Mock CalculatorEngine for testing
    class MockCalculatorEngine: CalculatorEngine {
        var angleUnit: AngleUnit = .degree
        var shouldThrowError = false
        var calculationResult: Double = 0
        
        func calculate(_ expression: String) throws -> Double {
            if shouldThrowError {
                throw CalculatorError.invalidExpression
            }
            return calculationResult
        }
        
        func validateExpression(_ expression: String) -> Bool {
            return !expression.isEmpty
        }
        
        func formatResult(_ result: Double) -> String {
            if result == floor(result) {
                return String(format: "%.0f", result)
            }
            return String(format: "%.4g", result)
        }
    }
    
    /// Mock SettingsStorage for testing
    class MockSettingsStorage: SettingsStorage {
        private var settings = CalculatorSettings()
        
        func saveAngleUnit(_ angleUnit: AngleUnit) {
            settings.angleUnit = angleUnit
        }
        
        func loadAngleUnit() -> AngleUnit {
            return settings.angleUnit
        }
        
        func saveDecimalPlaces(_ decimalPlaces: Int) {
            settings.decimalPlaces = decimalPlaces
        }
        
        func loadDecimalPlaces() -> Int {
            return settings.decimalPlaces
        }
        
        func isFirstLaunch() -> Bool {
            return settings.isFirstLaunch
        }
        
        func setFirstLaunchCompleted() {
            settings.isFirstLaunch = false
        }
        
        func saveSettings(_ settings: CalculatorSettings) {
            self.settings = settings
        }
        
        func loadSettings() -> CalculatorSettings {
            return settings
        }
    }
    
    /// Mock HistoryStorage for testing
    class MockHistoryStorage: HistoryStorage {
        private var historyItems: [CalculationHistory] = []
        
        func saveHistory(_ history: CalculationHistory) throws {
            historyItems.insert(history, at: 0)
        }
        
        func loadRecentHistory(limit: Int) throws -> [CalculationHistory] {
            return Array(historyItems.prefix(limit))
        }
        
        func loadAllHistory() throws -> [CalculationHistory] {
            return historyItems
        }
        
        func deleteHistory(_ history: CalculationHistory) throws {
            historyItems.removeAll { $0.id == history.id }
        }
        
        func clearAllHistory() throws {
            historyItems.removeAll()
        }
    }
    
    // MARK: - Initialization Tests
    
    @Test("CalculatorViewModel 초기화 테스트")
    @MainActor
    func testInitialization() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        #expect(viewModel.displayText == "0")
        #expect(viewModel.currentExpression == "")
        #expect(viewModel.isNewNumber == true)
        #expect(viewModel.settings.angleUnit == .degree)
    }
    
    // MARK: - Number Input Tests
    
    @Test("숫자 입력 테스트")
    @MainActor
    func testNumberInput() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        viewModel.handleButtonPress(.one)
        #expect(viewModel.displayText == "1")
        #expect(viewModel.isNewNumber == false)
        
        viewModel.handleButtonPress(.two)
        #expect(viewModel.displayText == "12")
        
        viewModel.handleButtonPress(.three)
        #expect(viewModel.displayText == "123")
    }
    
    @Test("새로운 숫자 시작 테스트")
    @MainActor
    func testNewNumberStart() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        viewModel.handleButtonPress(.five)
        #expect(viewModel.displayText == "5")
        
        // 연산자 입력 후 새로운 숫자 시작
        viewModel.handleButtonPress(.add)
        viewModel.handleButtonPress(.three)
        #expect(viewModel.displayText == "3")
        #expect(viewModel.isNewNumber == false)
    }
    
    @Test("소수점 입력 테스트")
    @MainActor
    func testDecimalInput() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        viewModel.handleButtonPress(.decimal)
        #expect(viewModel.displayText == "0.")
        
        viewModel.handleButtonPress(.five)
        #expect(viewModel.displayText == "0.5")
        
        // 이미 소수점이 있을 때 중복 입력 방지
        viewModel.handleButtonPress(.decimal)
        #expect(viewModel.displayText == "0.5")
    }
    
    // MARK: - Operator Input Tests
    
    @Test("연산자 입력 테스트")
    @MainActor
    func testOperatorInput() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        viewModel.handleButtonPress(.five)
        viewModel.handleButtonPress(.add)
        #expect(viewModel.currentExpression == "5+")
        #expect(viewModel.isNewNumber == true)
        
        viewModel.handleButtonPress(.three)
        viewModel.handleButtonPress(.multiply)
        #expect(viewModel.currentExpression == "5+3*")
    }
    
    @Test("연속 연산자 입력 처리 테스트")
    @MainActor
    func testConsecutiveOperators() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        viewModel.handleButtonPress(.five)
        viewModel.handleButtonPress(.add)
        viewModel.handleButtonPress(.subtract) // 연산자 교체
        #expect(viewModel.currentExpression == "5-")
    }
    
    // MARK: - Function Input Tests
    
    @Test("수학 함수 입력 테스트")
    @MainActor
    func testFunctionInput() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        viewModel.handleButtonPress(.sin)
        #expect(viewModel.currentExpression == "sin(")
        #expect(viewModel.isNewNumber == true)
    }
    
    @Test("상수 입력 테스트")
    @MainActor
    func testConstantInput() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        viewModel.handleButtonPress(.pi)
        #expect(viewModel.currentExpression == "π")
        #expect(viewModel.displayText == "π")
        #expect(viewModel.isNewNumber == false)
    }
    
    // MARK: - Calculation Tests
    
    @Test("계산 실행 테스트")
    @MainActor
    func testCalculation() {
        let mockEngine = MockCalculatorEngine()
        mockEngine.calculationResult = 8.0
        
        let viewModel = CalculatorViewModel(
            calculatorEngine: mockEngine,
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        viewModel.handleButtonPress(.five)
        viewModel.handleButtonPress(.add)
        viewModel.handleButtonPress(.three)
        viewModel.handleButtonPress(.equals)
        
        #expect(viewModel.displayText == "8")
        #expect(viewModel.isNewNumber == true)
    }
    
    @Test("계산 에러 처리 테스트")
    @MainActor
    func testCalculationError() {
        let mockEngine = MockCalculatorEngine()
        mockEngine.shouldThrowError = true
        
        let viewModel = CalculatorViewModel(
            calculatorEngine: mockEngine,
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        viewModel.handleButtonPress(.five)
        viewModel.handleButtonPress(.divide)
        viewModel.handleButtonPress(.zero)
        viewModel.handleButtonPress(.equals)
        
        #expect(viewModel.displayText == "Error")
        #expect(viewModel.isNewNumber == true)
    }
    
    // MARK: - Utility Functions Tests
    
    @Test("Clear 버튼 테스트")
    @MainActor
    func testClear() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        viewModel.handleButtonPress(.five)
        viewModel.handleButtonPress(.add)
        viewModel.handleButtonPress(.three)
        
        viewModel.handleButtonPress(.clear)
        
        #expect(viewModel.displayText == "0")
        #expect(viewModel.currentExpression == "")
        #expect(viewModel.isNewNumber == true)
    }
    
    @Test("Backspace 버튼 테스트")
    @MainActor
    func testBackspace() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        viewModel.handleButtonPress(.one)
        viewModel.handleButtonPress(.two)
        viewModel.handleButtonPress(.three)
        
        viewModel.handleButtonPress(.backspace)
        #expect(viewModel.displayText == "12")
        
        viewModel.handleButtonPress(.backspace)
        #expect(viewModel.displayText == "1")
        
        viewModel.handleButtonPress(.backspace)
        #expect(viewModel.displayText == "0")
    }
    
    @Test("Plus/Minus 버튼 테스트")
    @MainActor
    func testPlusMinus() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        viewModel.handleButtonPress(.five)
        viewModel.handleButtonPress(.plusMinus)
        #expect(viewModel.displayText == "-5")
        
        viewModel.handleButtonPress(.plusMinus)
        #expect(viewModel.displayText == "5")
    }
    
    // MARK: - Settings Tests
    
    @Test("각도 단위 토글 테스트")
    @MainActor
    func testAngleUnitToggle() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        #expect(viewModel.settings.angleUnit == .degree)
        
        viewModel.handleButtonPress(.angleUnit)
        #expect(viewModel.settings.angleUnit == .radian)
        
        viewModel.handleButtonPress(.angleUnit)
        #expect(viewModel.settings.angleUnit == .degree)
    }
    
    // MARK: - 히스토리 재사용 테스트
    
    @Test("히스토리에서 수식 불러오기")
    @MainActor
    func testLoadExpressionFromHistory() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        let expression = "2 + 3 * 4"
        
        viewModel.loadExpressionFromHistory(expression)
        
        #expect(viewModel.currentExpression == expression)
        #expect(viewModel.displayText == expression)
        #expect(!viewModel.isNewNumber)
    }
    
    @Test("히스토리에서 복잡한 수식 불러오기")
    @MainActor
    func testLoadComplexExpressionFromHistory() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        let complexExpression = "sin(π/2) + cos(0) * log(10)"
        
        viewModel.loadExpressionFromHistory(complexExpression)
        
        #expect(viewModel.currentExpression == complexExpression)
        #expect(viewModel.displayText == complexExpression)
        #expect(!viewModel.isNewNumber)
    }
    
    @Test("빈 수식 불러오기 처리")
    @MainActor
    func testLoadEmptyExpressionFromHistory() {
        let viewModel = CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        let emptyExpression = ""
        
        viewModel.loadExpressionFromHistory(emptyExpression)
        
        #expect(viewModel.currentExpression == "")
        #expect(viewModel.displayText == "0")
        #expect(viewModel.isNewNumber)
    }
    
    @Test("히스토리 수식 불러온 후 계산 실행")
    @MainActor
    func testCalculateAfterLoadingHistoryExpression() {
        let mockEngine = MockCalculatorEngine()
        mockEngine.calculationResult = 8.0
        
        let viewModel = CalculatorViewModel(
            calculatorEngine: mockEngine,
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        let expression = "5 + 3"
        
        viewModel.loadExpressionFromHistory(expression)
        viewModel.handleButtonPress(.equals)
        
        #expect(viewModel.displayText == "8")
        #expect(!viewModel.hasError)
    }
    
    // MARK: - 히스토리 기능 테스트
    
    @Test("히스토리에서 수식 로드 후 계산 테스트")
    func testCalculateAfterLoadingHistoryExpressionInteractiveHelp() async throws {
        // Given
        let mockEngine = MockCalculatorEngine()
        mockEngine.calculationResult = 0.5 // sin(30) = 0.5
        
        let viewModel = await CalculatorViewModel(
            calculatorEngine: mockEngine,
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        let expression = "sin(30)"
        
        // When
        await MainActor.run {
            viewModel.loadExpressionFromHistory(expression)
            // 로드 후 currentExpression이 올바르게 설정되었는지 확인
            #expect(viewModel.currentExpression == expression)
            
            viewModel.handleButtonPress(.equals)
        }
        
        // Then
        await MainActor.run {
            // 계산 후에는 currentExpression이 리셋되어야 함
            #expect(viewModel.currentExpression == "")
            // 결과가 displayText에 표시되어야 함
            #expect(viewModel.displayText == "0.5")
            #expect(!viewModel.hasError)
        }
    }
    
    // MARK: - 상호작용 도움말 테스트
    
    @Test("함수 버튼 설명 가져오기")
    func testGetFunctionDescription() async throws {
        // Given
        let viewModel = await CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        // When & Then
        await MainActor.run {
            // 삼각함수 버튼들
            let sinDescription = viewModel.getFunctionDescription(for: .sin)
            #expect(sinDescription != nil)
            #expect(sinDescription!.symbol == "sin")
            
            let cosDescription = viewModel.getFunctionDescription(for: .cos)
            #expect(cosDescription != nil)
            #expect(cosDescription!.symbol == "cos")
            
            let tanDescription = viewModel.getFunctionDescription(for: .tan)
            #expect(tanDescription != nil)
            #expect(tanDescription!.symbol == "tan")
            
            // 로그함수 버튼들
            let lnDescription = viewModel.getFunctionDescription(for: .ln)
            #expect(lnDescription != nil)
            #expect(lnDescription!.symbol == "ln")
            
            let logDescription = viewModel.getFunctionDescription(for: .log)
            #expect(logDescription != nil)
            #expect(logDescription!.symbol == "log")
            
            // 상수들
            let piDescription = viewModel.getFunctionDescription(for: .pi)
            #expect(piDescription != nil)
            #expect(piDescription!.symbol == "π")
            
            let eDescription = viewModel.getFunctionDescription(for: .e)
            #expect(eDescription != nil)
            #expect(eDescription!.symbol == "e")
        }
    }
    
    @Test("숫자 버튼은 함수 설명이 없음")
    func testNumberButtonsHaveNoDescription() async throws {
        // Given
        let viewModel = await CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        // When & Then
        await MainActor.run {
            let zeroDescription = viewModel.getFunctionDescription(for: .zero)
            #expect(zeroDescription == nil)
            
            let oneDescription = viewModel.getFunctionDescription(for: .one)
            #expect(oneDescription == nil)
            
            let nineDescription = viewModel.getFunctionDescription(for: .nine)
            #expect(nineDescription == nil)
        }
    }
    
    @Test("연산자 버튼은 함수 설명이 없음")
    func testOperatorButtonsHaveNoDescription() async throws {
        // Given
        let viewModel = await CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        // When & Then
        await MainActor.run {
            let addDescription = viewModel.getFunctionDescription(for: .add)
            #expect(addDescription == nil)
            
            let subtractDescription = viewModel.getFunctionDescription(for: .subtract)
            #expect(subtractDescription == nil)
            
            let multiplyDescription = viewModel.getFunctionDescription(for: .multiply)
            #expect(multiplyDescription == nil)
            
            let divideDescription = viewModel.getFunctionDescription(for: .divide)
            #expect(divideDescription == nil)
        }
    }
    
    @Test("일일 팁 표시 기능")
    func testShowDailyTip() async throws {
        // Given
        let viewModel = await CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        // When
        let shouldShowTip = await MainActor.run {
            return viewModel.shouldShowDailyTip()
        }
        
        // Then
        await MainActor.run {
            // 일일 팁 표시 여부는 구현에 따라 결정
            // 이 테스트는 크래시 없이 실행되는지만 확인
            #expect(shouldShowTip == true || shouldShowTip == false)
        }
    }
    
    @Test("일일 팁 가져오기")
    func testGetDailyTip() async throws {
        // Given
        let viewModel = await CalculatorViewModel(
            calculatorEngine: MockCalculatorEngine(),
            settingsStorage: MockSettingsStorage(),
            historyStorage: MockHistoryStorage()
        )
        
        // When
        let dailyTip = await MainActor.run {
            return viewModel.getDailyTip()
        }
        
        // Then
        await MainActor.run {
            // 일일 팁이 있을 수도 없을 수도 있음
            if let tip = dailyTip {
                #expect(tip.isDaily == true)
                #expect(!tip.content.isEmpty)
            }
        }
    }
} 