import Testing
@testable import EngineeringCalculator

/// 계산 엔진의 기본 기능을 테스트하는 구조체
/// TDD 원칙에 따라 구현 전에 테스트를 먼저 작성
struct CalculatorEngineTests {
    
    // MARK: - Basic Initialization Tests
    
    @Test("엔진 기본 초기화")
    func engineInitialization() {
        // Given & When
        let engine = ScientificCalculatorEngine()
        
        // Then
        #expect(engine.angleUnit == .degree, "기본 각도 단위는 degree여야 합니다")
    }
    
    @Test("엔진 커스텀 각도 단위 초기화")
    func engineInitializationWithCustomAngleUnit() {
        // Given & When
        let engine = ScientificCalculatorEngine(angleUnit: .radian)
        
        // Then
        #expect(engine.angleUnit == .radian, "지정된 각도 단위로 초기화되어야 합니다")
    }
    
    // MARK: - Expression Validation Tests
    
    @Test("빈 수식 검증")
    func validateEmptyExpression() {
        // Given
        let engine = ScientificCalculatorEngine()
        let expression = ""
        
        // When
        let isValid = engine.validateExpression(expression)
        
        // Then
        #expect(!isValid, "빈 수식은 유효하지 않아야 합니다")
    }
    
    @Test("공백만 있는 수식 검증")
    func validateWhitespaceOnlyExpression() {
        // Given
        let engine = ScientificCalculatorEngine()
        let expression = "   "
        
        // When
        let isValid = engine.validateExpression(expression)
        
        // Then
        #expect(!isValid, "공백만 있는 수식은 유효하지 않아야 합니다")
    }
    
    // MARK: - Result Formatting Tests
    
    @Test("일반 숫자 포맷팅")
    func formatResultWithRegularNumber() {
        // Given
        let engine = ScientificCalculatorEngine()
        let result = 123.456
        
        // When
        let formatted = engine.formatResult(result)
        
        // Then
        #expect(formatted == "123.456", "일반 숫자는 소수점 4자리까지 표시되어야 합니다")
    }
    
    @Test("정수 포맷팅")
    func formatResultWithInteger() {
        // Given
        let engine = ScientificCalculatorEngine()
        let result = 42.0
        
        // When
        let formatted = engine.formatResult(result)
        
        // Then
        #expect(formatted == "42", "정수는 소수점 없이 표시되어야 합니다")
    }
    
    @Test("NaN 포맷팅")
    func formatResultWithNaN() {
        // Given
        let engine = ScientificCalculatorEngine()
        let result = Double.nan
        
        // When
        let formatted = engine.formatResult(result)
        
        // Then
        #expect(formatted == "오류", "NaN은 '오류'로 표시되어야 합니다")
    }
    
    @Test("양의 무한대 포맷팅")
    func formatResultWithPositiveInfinity() {
        // Given
        let engine = ScientificCalculatorEngine()
        let result = Double.infinity
        
        // When
        let formatted = engine.formatResult(result)
        
        // Then
        #expect(formatted == "∞", "양의 무한대는 '∞'로 표시되어야 합니다")
    }
    
    @Test("음의 무한대 포맷팅")
    func formatResultWithNegativeInfinity() {
        // Given
        let engine = ScientificCalculatorEngine()
        let result = -Double.infinity
        
        // When
        let formatted = engine.formatResult(result)
        
        // Then
        #expect(formatted == "-∞", "음의 무한대는 '-∞'로 표시되어야 합니다")
    }
    
    @Test("매우 큰 수 포맷팅")
    func formatResultWithVeryLargeNumber() {
        // Given
        let engine = ScientificCalculatorEngine()
        let result = 1.23e15
        
        // When
        let formatted = engine.formatResult(result)
        
        // Then
        #expect(formatted.contains("e"), "매우 큰 수는 과학적 표기법으로 표시되어야 합니다")
    }
    
    @Test("매우 작은 수 포맷팅")
    func formatResultWithVerySmallNumber() {
        // Given
        let engine = ScientificCalculatorEngine()
        let result = 1.23e-6
        
        // When
        let formatted = engine.formatResult(result)
        
        // Then
        #expect(formatted.contains("e"), "매우 작은 수는 과학적 표기법으로 표시되어야 합니다")
    }
    
    // MARK: - Angle Unit Tests
    
    @Test("각도 단위 설정")
    func angleUnitSetting() {
        // Given
        let engine = ScientificCalculatorEngine()
        
        // When
        engine.angleUnit = .radian
        
        // Then
        #expect(engine.angleUnit == .radian, "각도 단위 설정이 올바르게 적용되어야 합니다")
        
        // When
        engine.angleUnit = .degree
        
        // Then
        #expect(engine.angleUnit == .degree, "각도 단위 변경이 올바르게 적용되어야 합니다")
    }
    
    // MARK: - Error Handling Tests
    
    @Test("빈 수식 계산 시 에러 발생")
    func calculateEmptyExpressionThrowsError() throws {
        // Given
        let engine = ScientificCalculatorEngine()
        let expression = ""
        
        // When & Then
        #expect(throws: CalculatorError.invalidExpression) {
            try engine.calculate(expression)
        }
    }
    
    @Test("공백만 있는 수식 계산 시 에러 발생")
    func calculateWhitespaceExpressionThrowsError() throws {
        // Given
        let engine = ScientificCalculatorEngine()
        let expression = "   "
        
        // When & Then
        #expect(throws: CalculatorError.invalidExpression) {
            try engine.calculate(expression)
        }
    }
    
    // MARK: - CalculatorError Tests
    
    @Test("CalculatorError 에러 메시지 확인")
    func calculatorErrorDescriptions() {
        // Given & When & Then
        #expect(CalculatorError.invalidExpression.errorDescription == "잘못된 수식입니다")
        #expect(CalculatorError.divisionByZero.errorDescription == "0으로 나눌 수 없습니다")
        #expect(CalculatorError.domainError.errorDescription == "정의역을 벗어났습니다")
        #expect(CalculatorError.overflow.errorDescription == "결과가 너무 큽니다")
        #expect(CalculatorError.underflow.errorDescription == "결과가 너무 작습니다")
        #expect(CalculatorError.unknownFunction.errorDescription == "알 수 없는 함수입니다")
        #expect(CalculatorError.missingOperand.errorDescription == "피연산자가 누락되었습니다")
        #expect(CalculatorError.invalidParentheses.errorDescription == "괄호가 올바르지 않습니다")
    }
} 