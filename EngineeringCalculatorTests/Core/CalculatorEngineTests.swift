import Testing
import Foundation
@testable import EngineeringCalculator

/// 계산 엔진의 기본 기능을 테스트하는 구조체
/// TDD 원칙에 따라 구현 전에 테스트를 먼저 작성
@Suite("Calculator Engine Tests")
struct CalculatorEngineTests {
    
    private let engine = ScientificCalculatorEngine()
    
    // MARK: - Basic Calculation Tests
    
    @Test("기본 사칙연산 테스트")
    func testBasicArithmetic() throws {
        #expect(try engine.calculate("2 + 3") == 5.0)
        #expect(try engine.calculate("10 - 4") == 6.0)
        #expect(try engine.calculate("3 * 7") == 21.0)
        #expect(try engine.calculate("15 / 3") == 5.0)
    }
    
    @Test("복잡한 수식 테스트")
    func testComplexExpressions() throws {
        #expect(abs(try engine.calculate("2 + 3 * 4") - 14.0) < 0.0001)
        #expect(abs(try engine.calculate("(2 + 3) * 4") - 20.0) < 0.0001)
        #expect(abs(try engine.calculate("2^3 + 1") - 9.0) < 0.0001)
    }
    
    // MARK: - Error Handling Tests
    
    @Test("0으로 나누기 에러 테스트")
    func testDivisionByZeroError() {
        #expect(throws: CalculatorError.divisionByZero) {
            try engine.calculate("5 / 0")
        }
        
        #expect(throws: CalculatorError.divisionByZero) {
            try engine.calculate("1 / (2 - 2)")
        }
    }
    
    @Test("정의역 벗어남 에러 테스트")
    func testDomainError() {
        // 로그 함수의 음수 입력
        #expect(throws: CalculatorError.domainError) {
            try engine.calculate("ln(-1)")
        }
        
        #expect(throws: CalculatorError.domainError) {
            try engine.calculate("log(-5)")
        }
        
        // 제곱근의 음수 입력
        #expect(throws: CalculatorError.domainError) {
            try engine.calculate("sqrt(-4)")
        }
        
        // 아크사인의 범위 초과
        #expect(throws: CalculatorError.domainError) {
            try engine.calculate("asin(2)")
        }
        
        #expect(throws: CalculatorError.domainError) {
            try engine.calculate("acos(-2)")
        }
    }
    
    @Test("오버플로우 에러 테스트")
    func testOverflowError() {
        #expect(throws: CalculatorError.overflow) {
            try engine.calculate("exp(1000)")
        }
        
        #expect(throws: CalculatorError.overflow) {
            try engine.calculate("pow10(500)")
        }
    }
    
    @Test("잘못된 수식 에러 테스트")
    func testInvalidExpressionError() {
        // 빈 문자열
        #expect(throws: CalculatorError.invalidExpression) {
            try engine.calculate("")
        }
        
        // 공백만 있는 문자열
        #expect(throws: CalculatorError.invalidExpression) {
            try engine.calculate("   ")
        }
        
        // 연속된 연산자
        #expect(throws: CalculatorError.invalidExpression) {
            try engine.calculate("2 ++ 3")
        }
        
        // 잘못된 괄호
        #expect(throws: CalculatorError.invalidParentheses) {
            try engine.calculate("2 + (3")
        }
        
        #expect(throws: CalculatorError.invalidParentheses) {
            try engine.calculate("2 + 3)")
        }
        
        // 알 수 없는 함수
        #expect(throws: CalculatorError.unknownFunction) {
            try engine.calculate("unknown(5)")
        }
    }
    
    @Test("피연산자 누락 에러 테스트")
    func testMissingOperandError() {
        #expect(throws: CalculatorError.missingOperand) {
            try engine.calculate("2 +")
        }
        
        #expect(throws: CalculatorError.invalidExpression) {
            try engine.calculate("* 3")
        }
    }
    
    // MARK: - Validation Tests
    
    @Test("수식 유효성 검증 테스트")
    func testExpressionValidation() {
        // 유효한 수식들
        #expect(engine.validateExpression("2 + 3"))
        #expect(engine.validateExpression("sin(π/2)"))
        #expect(engine.validateExpression("log(10)"))
        #expect(engine.validateExpression("(2 + 3) * 4"))
        
        // 유효하지 않은 수식들
        #expect(!engine.validateExpression(""))
        #expect(!engine.validateExpression("   "))
        #expect(!engine.validateExpression("2 ++"))
        #expect(!engine.validateExpression("2 + (3"))
        #expect(!engine.validateExpression("unknown(5)"))
    }
    
    // MARK: - Result Formatting Tests
    
    @Test("결과 포맷팅 테스트")
    func testResultFormatting() {
        // 정수 결과
        #expect(engine.formatResult(5.0) == "5")
        #expect(engine.formatResult(-3.0) == "-3")
        
        // 소수점 결과
        #expect(engine.formatResult(3.1416).contains("3.14"))
        
        // 특수 값 처리
        #expect(engine.formatResult(Double.nan) == "오류")
        #expect(engine.formatResult(Double.infinity) == "∞")
        #expect(engine.formatResult(-Double.infinity) == "-∞")
        
        // 매우 작은 값
        #expect(engine.formatResult(1e-15) == "0")
    }
    
    // MARK: - Trigonometric Function Tests
    
    @Test("삼각함수 특수값 테스트")
    func testTrigonometricSpecialValues() throws {
        engine.angleUnit = .degree
        
        // sin(0) = 0
        #expect(abs(try engine.calculate("sin(0)")) < 1e-10)
        
        // sin(90) = 1
        #expect(abs(try engine.calculate("sin(90)") - 1.0) < 1e-10)
        
        // cos(0) = 1
        #expect(abs(try engine.calculate("cos(0)") - 1.0) < 1e-10)
        
        // cos(90) ≈ 0
        #expect(abs(try engine.calculate("cos(90)")) < 1e-10)
        
        // tan(45) = 1
        #expect(abs(try engine.calculate("tan(45)") - 1.0) < 1e-10)
    }
    
    @Test("탄젠트 함수 정의역 에러 테스트")
    func testTangentDomainError() {
        engine.angleUnit = .degree
        
        // tan(90°)는 정의되지 않음
        #expect(throws: CalculatorError.domainError) {
            try engine.calculate("tan(90)")
        }
        
        // tan(270°)는 정의되지 않음
        #expect(throws: CalculatorError.domainError) {
            try engine.calculate("tan(270)")
        }
    }
    
    // MARK: - Mathematical Constants Tests
    
    @Test("수학 상수 테스트")
    func testMathematicalConstants() throws {
        // π 값 테스트
        #expect(abs(try engine.calculate("π") - Double.pi) < 1e-10)
        
        // e 값 테스트
        #expect(abs(try engine.calculate("e") - exp(1.0)) < 1e-10)
    }
    
    // MARK: - Edge Cases Tests
    
    @Test("경계값 테스트")
    func testEdgeCases() throws {
        // 매우 큰 수
        let largeResult = try engine.calculate("999999999")
        #expect(largeResult == 999999999.0)
        
        // 매우 작은 양수
        let smallResult = try engine.calculate("0.0001")
        #expect(abs(smallResult - 0.0001) < 1e-10)
        
        // 0에 가까운 계산 (sin(π) ≈ 0) - radian 모드에서 테스트
        engine.angleUnit = .radian
        let nearZero = try engine.calculate("sin(π)")
        #expect(abs(nearZero) < 1e-10)  // sin(π)는 0에 매우 가까워야 함
    }
} 