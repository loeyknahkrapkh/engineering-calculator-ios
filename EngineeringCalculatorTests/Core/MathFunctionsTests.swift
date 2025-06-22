import Testing
import Foundation
@testable import EngineeringCalculator

/// 수학 함수들의 기능을 테스트하는 구조체
struct MathFunctionsTests {
    
    // MARK: - Basic Operations Tests
    
    @Test("덧셈 연산")
    func addition() {
        // Given
        let lhs = 5.0
        let rhs = 3.0
        
        // When
        let result = MathFunctions.add(lhs, rhs)
        
        // Then
        #expect(abs(result - 8.0) < 0.0001, "덧셈 결과가 올바르지 않습니다")
    }
    
    @Test("뺄셈 연산")
    func subtraction() {
        // Given
        let lhs = 5.0
        let rhs = 3.0
        
        // When
        let result = MathFunctions.subtract(lhs, rhs)
        
        // Then
        #expect(abs(result - 2.0) < 0.0001, "뺄셈 결과가 올바르지 않습니다")
    }
    
    @Test("곱셈 연산")
    func multiplication() {
        // Given
        let lhs = 5.0
        let rhs = 3.0
        
        // When
        let result = MathFunctions.multiply(lhs, rhs)
        
        // Then
        #expect(abs(result - 15.0) < 0.0001, "곱셈 결과가 올바르지 않습니다")
    }
    
    @Test("나눗셈 연산")
    func division() throws {
        // Given
        let lhs = 6.0
        let rhs = 3.0
        
        // When
        let result = try MathFunctions.divide(lhs, rhs)
        
        // Then
        #expect(abs(result - 2.0) < 0.0001, "나눗셈 결과가 올바르지 않습니다")
    }
    
    @Test("0으로 나누기 에러")
    func divisionByZeroThrowsError() {
        // Given
        let lhs = 5.0
        let rhs = 0.0
        
        // When & Then
        #expect(throws: CalculatorError.divisionByZero) {
            try MathFunctions.divide(lhs, rhs)
        }
    }
    
    @Test("거듭제곱 연산")
    func power() throws {
        // Given
        let base = 2.0
        let exponent = 3.0
        
        // When
        let result = try MathFunctions.power(base, exponent)
        
        // Then
        #expect(abs(result - 8.0) < 0.0001, "거듭제곱 결과가 올바르지 않습니다")
    }
    
    @Test("0제곱 연산")
    func powerWithZeroExponent() throws {
        // Given
        let base = 5.0
        let exponent = 0.0
        
        // When
        let result = try MathFunctions.power(base, exponent)
        
        // Then
        #expect(abs(result - 1.0) < 0.0001, "0제곱은 1이어야 합니다")
    }
    
    // MARK: - Trigonometric Functions Tests
    
    @Test("사인 함수 (도 단위)")
    func sineWithDegrees() {
        // Given
        let angle = 30.0
        let angleUnit = AngleUnit.degree
        
        // When
        let result = MathFunctions.sine(angle, angleUnit: angleUnit)
        
        // Then
        #expect(abs(result - 0.5) < 0.0001, "sin(30°) = 0.5이어야 합니다")
    }
    
    @Test("사인 함수 (라디안 단위)")
    func sineWithRadians() {
        // Given
        let angle = Double.pi / 6  // 30도를 라디안으로
        let angleUnit = AngleUnit.radian
        
        // When
        let result = MathFunctions.sine(angle, angleUnit: angleUnit)
        
        // Then
        #expect(abs(result - 0.5) < 0.0001, "sin(π/6) = 0.5이어야 합니다")
    }
    
    @Test("코사인 함수 (도 단위)")
    func cosineWithDegrees() {
        // Given
        let angle = 60.0
        let angleUnit = AngleUnit.degree
        
        // When
        let result = MathFunctions.cosine(angle, angleUnit: angleUnit)
        
        // Then
        #expect(abs(result - 0.5) < 0.0001, "cos(60°) = 0.5이어야 합니다")
    }
    
    @Test("탄젠트 함수 (도 단위)")
    func tangentWithDegrees() {
        // Given
        let angle = 45.0
        let angleUnit = AngleUnit.degree
        
        // When
        let result = MathFunctions.tangent(angle, angleUnit: angleUnit)
        
        // Then
        #expect(abs(result - 1.0) < 0.0001, "tan(45°) = 1.0이어야 합니다")
    }
    
    // MARK: - Inverse Trigonometric Functions Tests
    
    @Test("아크사인 함수")
    func arcsine() throws {
        // Given
        let value = 0.5
        let angleUnit = AngleUnit.degree
        
        // When
        let result = try MathFunctions.arcsine(value, angleUnit: angleUnit)
        
        // Then
        #expect(abs(result - 30.0) < 0.0001, "asin(0.5) = 30°이어야 합니다")
    }
    
    @Test("아크사인 함수 정의역 에러")
    func arcsineWithInvalidValue() {
        // Given
        let value = 1.5  // 범위를 벗어난 값
        let angleUnit = AngleUnit.degree
        
        // When & Then
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.arcsine(value, angleUnit: angleUnit)
        }
    }
    
    @Test("아크코사인 함수")
    func arccosine() throws {
        // Given
        let value = 0.5
        let angleUnit = AngleUnit.degree
        
        // When
        let result = try MathFunctions.arccosine(value, angleUnit: angleUnit)
        
        // Then
        #expect(abs(result - 60.0) < 0.0001, "acos(0.5) = 60°이어야 합니다")
    }
    
    @Test("아크탄젠트 함수")
    func arctangent() {
        // Given
        let value = 1.0
        let angleUnit = AngleUnit.degree
        
        // When
        let result = MathFunctions.arctangent(value, angleUnit: angleUnit)
        
        // Then
        #expect(abs(result - 45.0) < 0.0001, "atan(1.0) = 45°이어야 합니다")
    }
    
    // MARK: - Logarithmic Functions Tests
    
    @Test("자연로그 함수")
    func naturalLog() throws {
        // Given
        let value = exp(1.0)  // 자연상수 e
        
        // When
        let result = try MathFunctions.naturalLog(value)
        
        // Then
        #expect(abs(result - 1.0) < 0.0001, "ln(e) = 1이어야 합니다")
    }
    
    @Test("자연로그 함수 정의역 에러")
    func naturalLogWithNegativeValue() {
        // Given
        let value = -1.0
        
        // When & Then
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.naturalLog(value)
        }
    }
    
    @Test("상용로그 함수")
    func commonLog() throws {
        // Given
        let value = 100.0
        
        // When
        let result = try MathFunctions.commonLog(value)
        
        // Then
        #expect(abs(result - 2.0) < 0.0001, "log(100) = 2이어야 합니다")
    }
    
    @Test("이진로그 함수")
    func binaryLog() throws {
        // Given
        let value = 8.0
        
        // When
        let result = try MathFunctions.binaryLog(value)
        
        // Then
        #expect(abs(result - 3.0) < 0.0001, "log₂(8) = 3이어야 합니다")
    }
    
    // MARK: - Exponential Functions Tests
    
    @Test("자연지수 함수")
    func naturalExp() throws {
        // Given
        let value = 1.0
        
        // When
        let result = try MathFunctions.naturalExp(value)
        
        // Then
        #expect(abs(result - exp(1.0)) < 0.0001, "e¹ = e이어야 합니다")
    }
    
    @Test("10의 거듭제곱 함수")
    func powerOfTen() throws {
        // Given
        let value = 2.0
        
        // When
        let result = try MathFunctions.powerOfTen(value)
        
        // Then
        #expect(abs(result - 100.0) < 0.0001, "10² = 100이어야 합니다")
    }
    
    // MARK: - Other Functions Tests
    
    @Test("제곱근 함수")
    func squareRoot() throws {
        // Given
        let value = 9.0
        
        // When
        let result = try MathFunctions.squareRoot(value)
        
        // Then
        #expect(abs(result - 3.0) < 0.0001, "√9 = 3이어야 합니다")
    }
    
    @Test("제곱근 함수 정의역 에러")
    func squareRootWithNegativeValue() {
        // Given
        let value = -1.0
        
        // When & Then
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.squareRoot(value)
        }
    }
    
    @Test("절댓값 함수")
    func absoluteValue() {
        // Given
        let positiveValue = 5.0
        let negativeValue = -5.0
        let zeroValue = 0.0
        
        // When
        let positiveResult = MathFunctions.absoluteValue(positiveValue)
        let negativeResult = MathFunctions.absoluteValue(negativeValue)
        let zeroResult = MathFunctions.absoluteValue(zeroValue)
        
        // Then
        #expect(abs(positiveResult - 5.0) < 0.0001, "|5| = 5이어야 합니다")
        #expect(abs(negativeResult - 5.0) < 0.0001, "|-5| = 5이어야 합니다")
        #expect(abs(zeroResult - 0.0) < 0.0001, "|0| = 0이어야 합니다")
    }
    
    @Test("세제곱근 함수")
    func cubeRoot() throws {
        // Given
        let positiveValue = 27.0
        let negativeValue = -8.0
        let zeroValue = 0.0
        
        // When
        let positiveResult = try MathFunctions.cubeRoot(positiveValue)
        let negativeResult = try MathFunctions.cubeRoot(negativeValue)
        let zeroResult = try MathFunctions.cubeRoot(zeroValue)
        
        // Then
        #expect(abs(positiveResult - 3.0) < 0.0001, "∛27 = 3이어야 합니다")
        #expect(abs(negativeResult - (-2.0)) < 0.0001, "∛(-8) = -2이어야 합니다")
        #expect(abs(zeroResult - 0.0) < 0.0001, "∛0 = 0이어야 합니다")
    }
    
    // MARK: - Mathematical Constants Tests
    
    @Test("파이 상수")
    func piConstant() {
        // When
        let piValue = MathFunctions.pi
        
        // Then
        #expect(abs(piValue - Double.pi) < 0.0001, "π 값이 올바르지 않습니다")
    }
    
    @Test("자연상수 e")
    func eulerConstant() {
        // When
        let eValue = MathFunctions.e
        
        // Then
        #expect(abs(eValue - exp(1.0)) < 0.0001, "e 값이 올바르지 않습니다")
    }
    
    // MARK: - Edge Cases and Complex Tests
    
    @Test("삼각함수 특수각 테스트")
    func trigonometricSpecialAngles() {
        // sin(0°) = 0, cos(0°) = 1, tan(0°) = 0
        #expect(abs(MathFunctions.sine(0, angleUnit: .degree) - 0.0) < 0.0001, "sin(0°) = 0이어야 합니다")
        #expect(abs(MathFunctions.cosine(0, angleUnit: .degree) - 1.0) < 0.0001, "cos(0°) = 1이어야 합니다")
        #expect(abs(MathFunctions.tangent(0, angleUnit: .degree) - 0.0) < 0.0001, "tan(0°) = 0이어야 합니다")
        
        // sin(90°) = 1, cos(90°) = 0
        #expect(abs(MathFunctions.sine(90, angleUnit: .degree) - 1.0) < 0.0001, "sin(90°) = 1이어야 합니다")
        #expect(abs(MathFunctions.cosine(90, angleUnit: .degree) - 0.0) < 0.0001, "cos(90°) = 0이어야 합니다")
    }
    
    @Test("로그함수 특수값 테스트")
    func logarithmSpecialValues() throws {
        // ln(1) = 0
        let lnOne = try MathFunctions.naturalLog(1.0)
        #expect(abs(lnOne - 0.0) < 0.0001, "ln(1) = 0이어야 합니다")
        
        // log(1) = 0
        let logOne = try MathFunctions.commonLog(1.0)
        #expect(abs(logOne - 0.0) < 0.0001, "log(1) = 0이어야 합니다")
        
        // log₂(1) = 0
        let log2One = try MathFunctions.binaryLog(1.0)
        #expect(abs(log2One - 0.0) < 0.0001, "log₂(1) = 0이어야 합니다")
    }
    
    @Test("지수함수 특수값 테스트")
    func exponentialSpecialValues() throws {
        // e⁰ = 1
        let expZero = try MathFunctions.naturalExp(0.0)
        #expect(abs(expZero - 1.0) < 0.0001, "e⁰ = 1이어야 합니다")
        
        // 10⁰ = 1
        let powTenZero = try MathFunctions.powerOfTen(0.0)
        #expect(abs(powTenZero - 1.0) < 0.0001, "10⁰ = 1이어야 합니다")
    }
    
    @Test("역삼각함수 경계값 테스트")
    func inverseTrigonometricBoundaryValues() throws {
        // asin(-1) = -90°, asin(1) = 90°
        let asinNegOne = try MathFunctions.arcsine(-1.0, angleUnit: .degree)
        let asinOne = try MathFunctions.arcsine(1.0, angleUnit: .degree)
        #expect(abs(asinNegOne - (-90.0)) < 0.0001, "asin(-1) = -90°이어야 합니다")
        #expect(abs(asinOne - 90.0) < 0.0001, "asin(1) = 90°이어야 합니다")
        
        // acos(-1) = 180°, acos(1) = 0°
        let acosNegOne = try MathFunctions.arccosine(-1.0, angleUnit: .degree)
        let acosOne = try MathFunctions.arccosine(1.0, angleUnit: .degree)
        #expect(abs(acosNegOne - 180.0) < 0.0001, "acos(-1) = 180°이어야 합니다")
        #expect(abs(acosOne - 0.0) < 0.0001, "acos(1) = 0°이어야 합니다")
    }
    
    @Test("큰 수 계산 테스트")
    func largeNumberCalculations() throws {
        // 큰 수의 거듭제곱
        let largePower = try MathFunctions.power(10, 6)
        #expect(abs(largePower - 1000000.0) < 0.0001, "10⁶ = 1,000,000이어야 합니다")
        
        // 작은 수의 제곱근
        let smallSqrt = try MathFunctions.squareRoot(0.0001)
        #expect(abs(smallSqrt - 0.01) < 0.0001, "√0.0001 = 0.01이어야 합니다")
    }
} 