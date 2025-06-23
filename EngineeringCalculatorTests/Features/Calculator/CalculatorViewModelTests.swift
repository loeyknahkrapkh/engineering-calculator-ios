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
} 