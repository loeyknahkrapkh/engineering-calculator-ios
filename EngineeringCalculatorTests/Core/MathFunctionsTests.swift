import Testing
import Foundation
@testable import EngineeringCalculator

@Suite("Math Functions Tests")
struct MathFunctionsTests {
    
    // MARK: - Basic Operations Tests
    
    @Test("기본 사칙연산 테스트")
    func testBasicOperations() {
        #expect(MathFunctions.add(2.0, 3.0) == 5.0)
        #expect(MathFunctions.subtract(5.0, 3.0) == 2.0)
        #expect(MathFunctions.multiply(4.0, 3.0) == 12.0)
    }
    
    @Test("나눗셈 테스트")
    func testDivision() throws {
        #expect(try MathFunctions.divide(10.0, 2.0) == 5.0)
        #expect(try MathFunctions.divide(7.0, 2.0) == 3.5)
    }
    
    @Test("0으로 나누기 에러 테스트")
    func testDivisionByZeroError() {
        #expect(throws: CalculatorError.divisionByZero) {
            try MathFunctions.divide(5.0, 0.0)
        }
        
        #expect(throws: CalculatorError.divisionByZero) {
            try MathFunctions.divide(-3.0, 0.0)
        }
    }
    
    // MARK: - Power Function Tests
    
    @Test("거듭제곱 테스트")
    func testPowerFunction() throws {
        #expect(try MathFunctions.power(2.0, 3.0) == 8.0)
        #expect(try MathFunctions.power(5.0, 2.0) == 25.0)
        #expect(abs(try MathFunctions.power(2.0, 0.5) - sqrt(2.0)) < 1e-10)
    }
    
    @Test("거듭제곱 에러 처리 테스트")
    func testPowerErrorHandling() {
        // 0^(-1) = 1/0 (division by zero)
        #expect(throws: CalculatorError.divisionByZero) {
            try MathFunctions.power(0.0, -1.0)
        }
        
        // (-2)^(0.5) (음수의 비정수 거듭제곱)
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.power(-2.0, 0.5)
        }
    }
    
    // MARK: - Trigonometric Functions Tests
    
    @Test("삼각함수 degree 모드 테스트")
    func testTrigonometricFunctionsDegree() {
        // sin(0°) = 0
        let sin0 = MathFunctions.sine(0.0, angleUnit: .degree)
        #expect(abs(sin0) < 1e-15)
        
        // sin(90°) = 1
        let sin90 = MathFunctions.sine(90.0, angleUnit: .degree)
        #expect(abs(sin90 - 1.0) < 1e-10)
        
        // cos(0°) = 1
        let cos0 = MathFunctions.cosine(0.0, angleUnit: .degree)
        #expect(abs(cos0 - 1.0) < 1e-10)
        
        // cos(90°) = 0
        let cos90 = MathFunctions.cosine(90.0, angleUnit: .degree)
        #expect(abs(cos90) < 1e-15)
        
        // tan(45°) = 1
        let tan45 = try! MathFunctions.tangent(45.0, angleUnit: .degree)
        #expect(abs(tan45 - 1.0) < 1e-10)
    }
    
    @Test("삼각함수 radian 모드 테스트")
    func testTrigonometricFunctionsRadian() {
        // sin(π/2) = 1
        let sinPiHalf = MathFunctions.sine(Double.pi / 2, angleUnit: .radian)
        #expect(abs(sinPiHalf - 1.0) < 1e-10)
        
        // cos(π) = -1
        let cosPi = MathFunctions.cosine(Double.pi, angleUnit: .radian)
        #expect(abs(cosPi + 1.0) < 1e-10)
        
        // tan(π/4) = 1
        let tanPiFourth = try! MathFunctions.tangent(Double.pi / 4, angleUnit: .radian)
        #expect(abs(tanPiFourth - 1.0) < 1e-10)
    }
    
    @Test("탄젠트 함수 정의역 에러 테스트")
    func testTangentDomainError() {
        // tan(90°)는 정의되지 않음
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.tangent(90.0, angleUnit: .degree)
        }
        
        // tan(270°)는 정의되지 않음
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.tangent(270.0, angleUnit: .degree)
        }
        
        // tan(π/2)는 정의되지 않음
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.tangent(Double.pi / 2, angleUnit: .radian)
        }
    }
    
    @Test("삼각함수 무한대 입력 처리")
    func testTrigonometricInfiniteInput() {
        let sinInf = MathFunctions.sine(Double.infinity, angleUnit: .degree)
        #expect(sinInf.isNaN)
        
        let cosInf = MathFunctions.cosine(Double.infinity, angleUnit: .degree)
        #expect(cosInf.isNaN)
        
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.tangent(Double.infinity, angleUnit: .degree)
        }
    }
    
    // MARK: - Inverse Trigonometric Functions Tests
    
    @Test("역삼각함수 테스트")
    func testInverseTrigonometricFunctions() throws {
        // asin(1) = 90° (degree mode)
        let asin1 = try MathFunctions.arcsine(1.0, angleUnit: .degree)
        #expect(abs(asin1 - 90.0) < 1e-10)
        
        // acos(0) = 90° (degree mode)
        let acos0 = try MathFunctions.arccosine(0.0, angleUnit: .degree)
        #expect(abs(acos0 - 90.0) < 1e-10)
        
        // atan(1) = 45° (degree mode)
        let atan1 = MathFunctions.arctangent(1.0, angleUnit: .degree)
        #expect(abs(atan1 - 45.0) < 1e-10)
    }
    
    @Test("역삼각함수 정의역 에러 테스트")
    func testInverseTrigonometricDomainError() {
        // asin(2) - 범위 초과
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.arcsine(2.0, angleUnit: .degree)
        }
        
        // asin(-2) - 범위 초과
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.arcsine(-2.0, angleUnit: .degree)
        }
        
        // acos(1.5) - 범위 초과
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.arccosine(1.5, angleUnit: .degree)
        }
        
        // acos(-1.5) - 범위 초과
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.arccosine(-1.5, angleUnit: .degree)
        }
    }
    
    // MARK: - Logarithmic Functions Tests
    
    @Test("로그함수 테스트")
    func testLogarithmicFunctions() throws {
        // ln(e) = 1
        let lnE = try MathFunctions.naturalLog(exp(1.0))
        #expect(abs(lnE - 1.0) < 1e-10)
        
        // log(10) = 1
        let log10 = try MathFunctions.commonLog(10.0)
        #expect(abs(log10 - 1.0) < 1e-10)
        
        // log2(8) = 3
        let log2_8 = try MathFunctions.binaryLog(8.0)
        #expect(abs(log2_8 - 3.0) < 1e-10)
    }
    
    @Test("로그함수 정의역 에러 테스트")
    func testLogarithmicDomainError() {
        // ln(-1) - 음수 입력
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.naturalLog(-1.0)
        }
        
        // ln(0) - 0 입력
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.naturalLog(0.0)
        }
        
        // log(-5) - 음수 입력
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.commonLog(-5.0)
        }
        
        // log2(0) - 0 입력
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.binaryLog(0.0)
        }
        
        // 무한대 입력
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.naturalLog(Double.infinity)
        }
    }
    
    // MARK: - Exponential Functions Tests
    
    @Test("지수함수 테스트")
    func testExponentialFunctions() throws {
        // exp(0) = 1
        let exp0 = try MathFunctions.naturalExp(0.0)
        #expect(abs(exp0 - 1.0) < 1e-10)
        
        // exp(1) ≈ e
        let exp1 = try MathFunctions.naturalExp(1.0)
        #expect(abs(exp1 - exp(1.0)) < 1e-10)
        
        // 10^2 = 100
        let pow10_2 = try MathFunctions.powerOfTen(2.0)
        #expect(abs(pow10_2 - 100.0) < 1e-10)
    }
    
    @Test("지수함수 오버플로우 에러 테스트")
    func testExponentialOverflowError() {
        // exp(1000) - 오버플로우
        #expect(throws: CalculatorError.overflow) {
            try MathFunctions.naturalExp(1000.0)
        }
        
        // 10^500 - 오버플로우
        #expect(throws: CalculatorError.overflow) {
            try MathFunctions.powerOfTen(500.0)
        }
    }
    
    @Test("지수함수 언더플로우 처리 테스트")
    func testExponentialUnderflowHandling() throws {
        // exp(-1000) ≈ 0 (언더플로우는 0으로 처리)
        let expNeg1000 = try MathFunctions.naturalExp(-1000.0)
        #expect(expNeg1000 == 0.0)
        
        // 10^(-500) ≈ 0 (언더플로우는 0으로 처리)
        let pow10Neg500 = try MathFunctions.powerOfTen(-500.0)
        #expect(pow10Neg500 == 0.0)
    }
    
    // MARK: - Other Functions Tests
    
    @Test("제곱근 함수 테스트")
    func testSquareRootFunction() throws {
        // sqrt(4) = 2
        let sqrt4 = try MathFunctions.squareRoot(4.0)
        #expect(abs(sqrt4 - 2.0) < 1e-10)
        
        // sqrt(0) = 0
        let sqrt0 = try MathFunctions.squareRoot(0.0)
        #expect(sqrt0 == 0.0)
        
        // sqrt(2) ≈ 1.414...
        let sqrt2 = try MathFunctions.squareRoot(2.0)
        #expect(abs(sqrt2 - sqrt(2.0)) < 1e-10)
    }
    
    @Test("제곱근 정의역 에러 테스트")
    func testSquareRootDomainError() {
        // sqrt(-1) - 음수 입력
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.squareRoot(-1.0)
        }
        
        // sqrt(-4) - 음수 입력
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.squareRoot(-4.0)
        }
        
        // 무한대 입력
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.squareRoot(Double.infinity)
        }
    }
    
    @Test("절댓값 함수 테스트")
    func testAbsoluteValueFunction() {
        #expect(MathFunctions.absoluteValue(5.0) == 5.0)
        #expect(MathFunctions.absoluteValue(-3.0) == 3.0)
        #expect(MathFunctions.absoluteValue(0.0) == 0.0)
        
        // 무한대 입력 처리
        let absInf = MathFunctions.absoluteValue(Double.infinity)
        #expect(absInf.isNaN)
    }
    
    @Test("세제곱근 함수 테스트")
    func testCubeRootFunction() throws {
        // cbrt(8) = 2
        let cbrt8 = try MathFunctions.cubeRoot(8.0)
        #expect(abs(cbrt8 - 2.0) < 1e-10)
        
        // cbrt(-8) = -2
        let cbrtNeg8 = try MathFunctions.cubeRoot(-8.0)
        #expect(abs(cbrtNeg8 + 2.0) < 1e-10)
        
        // cbrt(0) = 0
        let cbrt0 = try MathFunctions.cubeRoot(0.0)
        #expect(cbrt0 == 0.0)
    }
    
    @Test("세제곱근 정의역 에러 테스트")
    func testCubeRootDomainError() {
        // 무한대 입력
        #expect(throws: CalculatorError.domainError) {
            try MathFunctions.cubeRoot(Double.infinity)
        }
    }
    
    // MARK: - Mathematical Constants Tests
    
    @Test("수학 상수 테스트")
    func testMathematicalConstants() {
        #expect(abs(MathFunctions.pi - Double.pi) < 1e-15)
        #expect(abs(MathFunctions.e - exp(1.0)) < 1e-15)
    }
    
    // MARK: - Edge Cases and Boundary Tests
    
    @Test("경계값 테스트")
    func testBoundaryValues() throws {
        // 매우 작은 양수
        let verySmall = 1e-100
        let lnVerySmall = try MathFunctions.naturalLog(verySmall)
        #expect(lnVerySmall.isFinite)
        
        // 1에 가까운 값들
        let nearOne = 1.0 + 1e-15
        let lnNearOne = try MathFunctions.naturalLog(nearOne)
        #expect(abs(lnNearOne) < 1e-14)
    }
    
    @Test("부동소수점 정밀도 테스트")
    func testFloatingPointPrecision() {
        // sin(π) should be very close to 0
        let sinPi = MathFunctions.sine(Double.pi, angleUnit: .radian)
        #expect(abs(sinPi) < 1e-15)
        
        // cos(π/2) should be very close to 0
        let cosPiHalf = MathFunctions.cosine(Double.pi / 2, angleUnit: .radian)
        #expect(abs(cosPiHalf) < 1e-15)
    }
} 