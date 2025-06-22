# 공학용 계산기 iOS 앱 기술 아키텍처

## 1. 아키텍처 개요

### 1.1 아키텍처 패턴

-   **MVVM (Model-View-ViewModel)** 패턴 사용
-   **Protocol Oriented Programming** 적용
-   **Micro Feature Architecture** 적용하여 모듈화

### 1.2 기술 스택

-   **언어**: Swift 6.0
-   **UI Framework**: SwiftUI
-   **최소 지원 버전**: iOS 18.4
-   **데이터 저장**: UserDefaults (설정), Core Data (히스토리)
-   **의존성 관리**: Swift Package Manager (SPM)

### 1.3 프로젝트 구조

```
EngineeringCalculator/
├── App/
│   ├── EngineeringCalculatorApp.swift
│   └── ContentView.swift
├── Features/
│   ├── Calculator/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Models/
│   ├── History/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Models/
│   └── Help/
│       ├── Views/
│       ├── ViewModels/
│       └── Models/
├── Core/
│   ├── Calculator/
│   │   ├── CalculatorEngine.swift
│   │   ├── MathFunctions.swift
│   │   └── ExpressionParser.swift
│   ├── Storage/
│   │   ├── HistoryStorage.swift
│   │   └── SettingsStorage.swift
│   └── Extensions/
│       ├── Double+Extensions.swift
│       └── String+Extensions.swift
├── Shared/
│   ├── Models/
│   │   ├── CalculationHistory.swift
│   │   ├── CalculatorSettings.swift
│   │   └── CalculatorButton.swift
│   ├── ViewComponents/
│   │   ├── CalculatorButtonView.swift
│   │   ├── DisplayView.swift
│   │   └── HistoryRowView.swift
│   └── Constants/
│       ├── AppConstants.swift
│       ├── Colors.swift
│       └── Fonts.swift
└── Resources/
    ├── Assets.xcassets
    └── Localizable.strings
```

### 1.4 모듈별 상세 구조

#### 1.4.1 Core 모듈

핵심 비즈니스 로직과 인프라 코드를 포함합니다.

**Engine/** - 계산 엔진 및 수학 함수

-   `CalculatorEngine.swift` - 계산 엔진 프로토콜
-   `ScientificCalculatorEngine.swift` - 공학용 계산기 구현
-   `ExpressionParser.swift` - 수식 파싱 로직
-   `MathFunctions.swift` - 수학 함수 구현

**Storage/** - 데이터 저장 및 관리

-   `SettingsStorage.swift` - 설정 저장소 프로토콜
-   `HistoryStorage.swift` - 히스토리 저장소 프로토콜
-   `UserDefaultsSettingsStorage.swift` - UserDefaults 구현
-   `CoreDataHistoryStorage.swift` - Core Data 구현

#### 1.4.2 Features 모듈

앱의 주요 기능별 모듈을 포함합니다.

**Calculator/** - 메인 계산기 화면 및 기능
**History/** - 계산 히스토리 관리 기능
**Help/** - 도움말 및 사용법 안내 기능

각 Feature는 다음과 같은 구조를 가집니다:

-   `Views/` - SwiftUI 뷰 컴포넌트
-   `ViewModels/` - MVVM 패턴의 ViewModel
-   `Models/` - Feature별 데이터 모델

#### 1.4.3 Shared 모듈

앱 전체에서 공유되는 코드를 포함합니다.

**Models/** - 공통 데이터 모델

-   `CalculatorButton.swift` - 계산기 버튼 타입
-   `CalculatorSettings.swift` - 앱 설정 모델
-   `CalculationHistory.swift` - 계산 히스토리 모델
-   `AngleUnit.swift` - 각도 단위 enum

**Extensions/** - Swift 타입 확장

-   `Double+Extensions.swift` - Double 타입 확장
-   `String+Extensions.swift` - String 타입 확장

**Constants/** - 앱 상수

-   `AppConstants.swift` - 앱 전역 상수
-   `MathConstants.swift` - 수학 상수 (π, e 등)

#### 1.4.4 Resources 모듈

앱의 리소스 파일들을 포함합니다.

**Colors/** - 색상 시스템

-   `Colors.swift` - 앱 전체 색상 정의
-   버튼별 색상 구분 (숫자, 연산자, 함수, 상수)
-   다크/라이트 모드 대응

**Fonts/** - 폰트 시스템

-   `Fonts.swift` - 앱 전체 폰트 정의
-   SF Pro Display, SF Mono 폰트 설정

**디자인 시스템 원칙:**

-   iOS Human Interface Guidelines 준수
-   44×44pt 최소 터치 타겟 크기
-   Rounded Rectangle 버튼 스타일
-   접근성 고려

## 2. 핵심 컴포넌트 설계

### 2.1 Calculator Engine

#### 2.1.1 CalculatorEngine Protocol

```swift
protocol CalculatorEngine {
    func evaluate(_ expression: String) throws -> Double
    func formatResult(_ value: Double) -> String
    func validateExpression(_ expression: String) -> Bool
}

class ScientificCalculatorEngine: CalculatorEngine {
    private let parser: ExpressionParser
    private let mathFunctions: MathFunctions
    private let settings: CalculatorSettings

    func evaluate(_ expression: String) throws -> Double {
        // 수식 파싱 및 계산 로직
    }

    func formatResult(_ value: Double) -> String {
        // 결과 포맷팅 (소수점 4자리)
    }

    func validateExpression(_ expression: String) -> Bool {
        // 수식 유효성 검증
    }
}
```

#### 2.1.2 Expression Parser

```swift
class ExpressionParser {
    enum Token {
        case number(Double)
        case operator(String)
        case function(String)
        case constant(String)
        case parenthesis(String)
    }

    func tokenize(_ expression: String) -> [Token] {
        // 수식을 토큰으로 분리
    }

    func parseToPostfix(_ tokens: [Token]) -> [Token] {
        // 중위 표기법을 후위 표기법으로 변환 (Shunting Yard Algorithm)
    }

    func evaluatePostfix(_ tokens: [Token]) throws -> Double {
        // 후위 표기법 수식 계산
    }
}
```

#### 2.1.3 Math Functions

```swift
class MathFunctions {
    private let angleUnit: AngleUnit

    // 삼각함수
    func sin(_ value: Double) -> Double {
        return Foundation.sin(angleUnit == .degree ? value * .pi / 180 : value)
    }

    func cos(_ value: Double) -> Double {
        return Foundation.cos(angleUnit == .degree ? value * .pi / 180 : value)
    }

    func tan(_ value: Double) -> Double {
        return Foundation.tan(angleUnit == .degree ? value * .pi / 180 : value)
    }

    // 역삼각함수
    func asin(_ value: Double) -> Double {
        let result = Foundation.asin(value)
        return angleUnit == .degree ? result * 180 / .pi : result
    }

    // 로그함수
    func log10(_ value: Double) -> Double {
        return Foundation.log10(value)
    }

    func ln(_ value: Double) -> Double {
        return Foundation.log(value)
    }

    func log2(_ value: Double) -> Double {
        return Foundation.log2(value)
    }

    // 지수함수
    func exp(_ value: Double) -> Double {
        return Foundation.exp(value)
    }

    func pow10(_ value: Double) -> Double {
        return Foundation.pow(10, value)
    }

    func pow(_ base: Double, _ exponent: Double) -> Double {
        return Foundation.pow(base, exponent)
    }
}
```

### 2.2 Data Models

#### 2.2.1 Calculator Settings

```swift
struct CalculatorSettings {
    var angleUnit: AngleUnit = .degree
    var decimalPlaces: Int = 4
    var isFirstLaunch: Bool = true
    var showTips: Bool = true
}

enum AngleUnit: String, CaseIterable {
    case radian = "rad"
    case degree = "deg"

    var displayName: String {
        switch self {
        case .radian: return "RAD"
        case .degree: return "DEG"
        }
    }
}
```

#### 2.2.2 Calculation History

```swift
struct CalculationHistory: Identifiable, Codable {
    let id: UUID
    let expression: String
    let result: Double
    let timestamp: Date

    init(expression: String, result: Double) {
        self.id = UUID()
        self.expression = expression
        self.result = result
        self.timestamp = Date()
    }
}
```

#### 2.2.3 Calculator Button

```swift
enum CalculatorButton: String, CaseIterable {
    // 숫자
    case zero = "0", one = "1", two = "2", three = "3", four = "4"
    case five = "5", six = "6", seven = "7", eight = "8", nine = "9"

    // 기본 연산자
    case add = "+", subtract = "-", multiply = "×", divide = "÷"
    case equals = "=", decimal = "."

    // 기능 버튼
    case clear = "C", plusMinus = "±", percent = "%"
    case openParenthesis = "(", closeParenthesis = ")"

    // 공학 함수
    case sin = "sin", cos = "cos", tan = "tan"
    case asin = "asin", acos = "acos", atan = "atan"
    case ln = "ln", log = "log", log2 = "log₂"
    case exp = "eˣ", pow10 = "10ˣ", power = "xʸ"
    case pi = "π", e = "e"

    // 특수 기능
    case angleUnit = "rad/deg", history = "hist", help = "help"
    case unitConverter = "unit"

    var displayText: String {
        return self.rawValue
    }

    var buttonType: ButtonType {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            return .number
        case .add, .subtract, .multiply, .divide, .equals:
            return .operator
        case .sin, .cos, .tan, .asin, .acos, .atan, .ln, .log, .log2, .exp, .pow10, .power:
            return .function
        case .pi, .e:
            return .constant
        default:
            return .special
        }
    }
}

enum ButtonType {
    case number
    case operator
    case function
    case constant
    case special
}
```

### 2.3 ViewModels

#### 2.3.1 Calculator ViewModel

```swift
@MainActor
class CalculatorViewModel: ObservableObject {
    @Published var displayText: String = "0"
    @Published var currentExpression: String = ""
    @Published var isNewNumber: Bool = true
    @Published var settings: CalculatorSettings

    private let calculatorEngine: CalculatorEngine
    private let historyStorage: HistoryStorage
    private let settingsStorage: SettingsStorage

    init(
        calculatorEngine: CalculatorEngine = ScientificCalculatorEngine(),
        historyStorage: HistoryStorage = CoreDataHistoryStorage(),
        settingsStorage: SettingsStorage = UserDefaultsSettingsStorage()
    ) {
        self.calculatorEngine = calculatorEngine
        self.historyStorage = historyStorage
        self.settingsStorage = settingsStorage
        self.settings = settingsStorage.loadSettings()
    }

    func buttonPressed(_ button: CalculatorButton) {
        switch button.buttonType {
        case .number:
            handleNumberInput(button.rawValue)
        case .operator:
            handleOperatorInput(button.rawValue)
        case .function:
            handleFunctionInput(button.rawValue)
        case .constant:
            handleConstantInput(button.rawValue)
        case .special:
            handleSpecialInput(button)
        }
    }

    private func handleNumberInput(_ number: String) {
        if isNewNumber {
            displayText = number
            isNewNumber = false
        } else {
            displayText += number
        }
        updateCurrentExpression()
    }

    private func handleOperatorInput(_ operator: String) {
        if operator == "=" {
            calculateResult()
        } else {
            currentExpression += " \(operator) "
            isNewNumber = true
        }
    }

    private func calculateResult() {
        do {
            let result = try calculatorEngine.evaluate(currentExpression)
            let formattedResult = calculatorEngine.formatResult(result)

            // 히스토리에 저장
            let history = CalculationHistory(
                expression: currentExpression,
                result: result
            )
            historyStorage.saveCalculation(history)

            displayText = formattedResult
            currentExpression = formattedResult
            isNewNumber = true

        } catch {
            displayText = "Error"
            isNewNumber = true
        }
    }

    func toggleAngleUnit() {
        settings.angleUnit = settings.angleUnit == .degree ? .radian : .degree
        settingsStorage.saveSettings(settings)
    }
}
```

#### 2.3.2 History ViewModel

```swift
@MainActor
class HistoryViewModel: ObservableObject {
    @Published var calculations: [CalculationHistory] = []

    private let historyStorage: HistoryStorage

    init(historyStorage: HistoryStorage = CoreDataHistoryStorage()) {
        self.historyStorage = historyStorage
        loadHistory()
    }

    func loadHistory() {
        calculations = historyStorage.loadHistory()
    }

    func clearHistory() {
        historyStorage.clearHistory()
        calculations.removeAll()
    }

    func selectCalculation(_ calculation: CalculationHistory) -> String {
        return String(calculation.result)
    }
}
```

### 2.4 Storage Layer

#### 2.4.1 History Storage Protocol

```swift
protocol HistoryStorage {
    func saveCalculation(_ calculation: CalculationHistory)
    func loadHistory() -> [CalculationHistory]
    func clearHistory()
}

class CoreDataHistoryStorage: HistoryStorage {
    private let maxHistoryCount = 10

    func saveCalculation(_ calculation: CalculationHistory) {
        // Core Data를 사용한 히스토리 저장
        // 10개 초과 시 가장 오래된 항목 삭제
    }

    func loadHistory() -> [CalculationHistory] {
        // Core Data에서 히스토리 로드
        // 최신 순으로 정렬하여 반환
    }

    func clearHistory() {
        // 모든 히스토리 삭제
    }
}
```

#### 2.4.2 Settings Storage Protocol

```swift
protocol SettingsStorage {
    func saveSettings(_ settings: CalculatorSettings)
    func loadSettings() -> CalculatorSettings
}

class UserDefaultsSettingsStorage: SettingsStorage {
    private enum Keys {
        static let angleUnit = "angleUnit"
        static let decimalPlaces = "decimalPlaces"
        static let isFirstLaunch = "isFirstLaunch"
        static let showTips = "showTips"
    }

    func saveSettings(_ settings: CalculatorSettings) {
        UserDefaults.standard.set(settings.angleUnit.rawValue, forKey: Keys.angleUnit)
        UserDefaults.standard.set(settings.decimalPlaces, forKey: Keys.decimalPlaces)
        UserDefaults.standard.set(settings.isFirstLaunch, forKey: Keys.isFirstLaunch)
        UserDefaults.standard.set(settings.showTips, forKey: Keys.showTips)
    }

    func loadSettings() -> CalculatorSettings {
        let angleUnitString = UserDefaults.standard.string(forKey: Keys.angleUnit) ?? AngleUnit.degree.rawValue
        let angleUnit = AngleUnit(rawValue: angleUnitString) ?? .degree
        let decimalPlaces = UserDefaults.standard.integer(forKey: Keys.decimalPlaces)
        let isFirstLaunch = UserDefaults.standard.bool(forKey: Keys.isFirstLaunch)
        let showTips = UserDefaults.standard.bool(forKey: Keys.showTips)

        return CalculatorSettings(
            angleUnit: angleUnit,
            decimalPlaces: decimalPlaces == 0 ? 4 : decimalPlaces,
            isFirstLaunch: isFirstLaunch,
            showTips: showTips
        )
    }
}
```

## 3. UI 컴포넌트 설계

### 3.1 Calculator Button View

```swift
struct CalculatorButtonView: View {
    let button: CalculatorButton
    let action: () -> Void

    private var buttonColor: Color {
        switch button.buttonType {
        case .number:
            return Color(.systemGray5)
        case .operator:
            return Color(.systemOrange)
        case .function:
            return Color(.systemBlue)
        case .constant:
            return Color(.systemPurple)
        case .special:
            return Color(.systemGray2)
        }
    }

    private var textColor: Color {
        switch button.buttonType {
        case .operator, .function, .constant:
            return .white
        default:
            return .primary
        }
    }

    var body: some View {
        Button(action: action) {
            Text(button.displayText)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(buttonColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
```

### 3.2 Display View

```swift
struct DisplayView: View {
    let displayText: String
    let expression: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            // 현재 수식 표시
            Text(expression)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.trailing)

            // 결과 표시
            Text(displayText)
                .font(.largeTitle)
                .fontWeight(.light)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(Color(.systemBackground))
    }
}
```

### 3.3 Main Calculator View

```swift
struct CalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    @State private var showingHistory = false
    @State private var showingHelp = false

    private let buttonLayout: [[CalculatorButton]] = [
        [.clear, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equals]
    ]

    private let functionLayout: [[CalculatorButton]] = [
        [.sin, .cos, .tan, .pi],
        [.ln, .log, .e, .angleUnit]
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 1) {
                // Display Area
                DisplayView(
                    displayText: viewModel.displayText,
                    expression: viewModel.currentExpression
                )
                .frame(height: geometry.size.height * 0.25)

                // Button Area
                VStack(spacing: 8) {
                    // Function Buttons
                    ForEach(functionLayout, id: \.self) { row in
                        HStack(spacing: 8) {
                            ForEach(row, id: \.self) { button in
                                CalculatorButtonView(button: button) {
                                    viewModel.buttonPressed(button)
                                }
                            }
                        }
                    }

                    // Number and Operator Buttons
                    ForEach(buttonLayout, id: \.self) { row in
                        HStack(spacing: 8) {
                            ForEach(row, id: \.self) { button in
                                CalculatorButtonView(button: button) {
                                    viewModel.buttonPressed(button)
                                }
                                .frame(width: button == .zero ?
                                      (geometry.size.width - 32) / 2 - 4 :
                                      (geometry.size.width - 40) / 4)
                            }
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.75)
            }
        }
        .padding()
        .sheet(isPresented: $showingHistory) {
            HistoryView()
        }
        .sheet(isPresented: $showingHelp) {
            HelpView()
        }
    }
}
```

## 4. 테스트 전략

### 4.1 Unit Tests

```swift
class CalculatorEngineTests: XCTestCase {
    var sut: ScientificCalculatorEngine!

    override func setUp() {
        super.setUp()
        sut = ScientificCalculatorEngine()
    }

    func testBasicArithmetic() {
        XCTAssertEqual(try sut.evaluate("2 + 3"), 5.0)
        XCTAssertEqual(try sut.evaluate("10 - 4"), 6.0)
        XCTAssertEqual(try sut.evaluate("3 × 4"), 12.0)
        XCTAssertEqual(try sut.evaluate("15 ÷ 3"), 5.0)
    }

    func testTrigonometricFunctions() {
        XCTAssertEqual(try sut.evaluate("sin(30)"), 0.5, accuracy: 0.0001)
        XCTAssertEqual(try sut.evaluate("cos(60)"), 0.5, accuracy: 0.0001)
        XCTAssertEqual(try sut.evaluate("tan(45)"), 1.0, accuracy: 0.0001)
    }

    func testLogarithmicFunctions() {
        XCTAssertEqual(try sut.evaluate("ln(e)"), 1.0, accuracy: 0.0001)
        XCTAssertEqual(try sut.evaluate("log(100)"), 2.0, accuracy: 0.0001)
    }

    func testErrorHandling() {
        XCTAssertThrowsError(try sut.evaluate("1 ÷ 0"))
        XCTAssertThrowsError(try sut.evaluate("log(-1)"))
        XCTAssertThrowsError(try sut.evaluate("asin(2)"))
    }
}
```

### 4.2 UI Tests

```swift
class CalculatorUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }

    func testBasicCalculation() {
        app.buttons["2"].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()

        XCTAssertEqual(app.staticTexts["display"].label, "5")
    }

    func testHistoryFunctionality() {
        // 계산 수행
        app.buttons["2"].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()

        // 히스토리 열기
        app.buttons["hist"].tap()

        // 히스토리 항목 확인
        XCTAssertTrue(app.staticTexts["2 + 3 = 5"].exists)
    }
}
```

## 5. 성능 최적화

### 5.1 계산 성능 최적화

-   **지연 계산**: 복잡한 함수는 필요할 때만 계산
-   **결과 캐싱**: 동일한 계산 결과 캐싱
-   **백그라운드 계산**: 복잡한 계산은 백그라운드 큐에서 실행

### 5.2 UI 성능 최적화

-   **LazyVGrid 사용**: 버튼 레이아웃에서 성능 최적화
-   **@Published 최소화**: 불필요한 UI 업데이트 방지
-   **이미지 최적화**: 벡터 이미지 사용으로 메모리 절약

### 5.3 메모리 관리

-   **약한 참조**: 순환 참조 방지
-   **리소스 해제**: 뷰가 사라질 때 리소스 적절히 해제
-   **히스토리 제한**: 최대 10개로 메모리 사용량 제한

## 6. 보안 고려사항

### 6.1 데이터 보안

-   **로컬 저장**: 모든 데이터는 로컬에만 저장
-   **암호화**: 민감한 설정 데이터는 Keychain 사용 고려
-   **데이터 유효성 검증**: 입력 데이터 검증으로 크래시 방지

### 6.2 앱 보안

-   **코드 난독화**: 릴리스 빌드에서 코드 난독화
-   **디버그 정보 제거**: 프로덕션에서 디버그 정보 제거
-   **앱 서명**: 적절한 코드 서명으로 무결성 보장
