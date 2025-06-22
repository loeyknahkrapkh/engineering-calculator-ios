import Foundation

/// 수학 함수들을 제공하는 클래스
/// 공학용 계산기에서 사용하는 모든 수학 함수를 구현
class MathFunctions {
    
    // MARK: - Mathematical Constants
    
    /// 원주율 π
    static let pi: Double = Double.pi
    
    /// 자연상수 e
    static let e: Double = exp(1.0)
    
    // MARK: - Basic Operations
    
    /// 덧셈
    /// - Parameters:
    ///   - lhs: 좌측 피연산자
    ///   - rhs: 우측 피연산자
    /// - Returns: 덧셈 결과
    static func add(_ lhs: Double, _ rhs: Double) -> Double {
        return lhs + rhs
    }
    
    /// 뺄셈
    /// - Parameters:
    ///   - lhs: 좌측 피연산자
    ///   - rhs: 우측 피연산자
    /// - Returns: 뺄셈 결과
    static func subtract(_ lhs: Double, _ rhs: Double) -> Double {
        return lhs - rhs
    }
    
    /// 곱셈
    /// - Parameters:
    ///   - lhs: 좌측 피연산자
    ///   - rhs: 우측 피연산자
    /// - Returns: 곱셈 결과
    static func multiply(_ lhs: Double, _ rhs: Double) -> Double {
        return lhs * rhs
    }
    
    /// 나눗셈
    /// - Parameters:
    ///   - lhs: 좌측 피연산자
    ///   - rhs: 우측 피연산자
    /// - Returns: 나눗셈 결과
    /// - Throws: CalculatorError.divisionByZero
    static func divide(_ lhs: Double, _ rhs: Double) throws -> Double {
        guard rhs != 0 else {
            throw CalculatorError.divisionByZero
        }
        return lhs / rhs
    }
    
    /// 거듭제곱
    /// - Parameters:
    ///   - base: 밑
    ///   - exponent: 지수
    /// - Returns: 거듭제곱 결과
    /// - Throws: CalculatorError.domainError, CalculatorError.overflow
    static func power(_ base: Double, _ exponent: Double) throws -> Double {
        // 특수 케이스 처리
        if base == 0 && exponent < 0 {
            throw CalculatorError.divisionByZero
        }
        
        if base < 0 && !exponent.isInteger {
            throw CalculatorError.domainError
        }
        
        let result = pow(base, exponent)
        
        // 결과 유효성 검증
        try validateResult(result)
        
        return result
    }
    
    // MARK: - Trigonometric Functions
    
    /// 사인 함수
    /// - Parameters:
    ///   - value: 각도 값
    ///   - angleUnit: 각도 단위
    /// - Returns: 사인 값
    static func sine(_ value: Double, angleUnit: AngleUnit) -> Double {
        guard value.isFinite else { return Double.nan }
        
        let radians = convertToRadians(value, from: angleUnit)
        
        // 특수한 각도 값들에 대한 정확한 처리
        let normalizedRadians = radians.truncatingRemainder(dividingBy: 2 * Double.pi)
        let absNormalized = abs(normalizedRadians)
        
        // π의 배수 (0, π, 2π 등)에서는 정확히 0
        if absNormalized < 1e-12 || 
           abs(absNormalized - Double.pi) < 1e-12 || 
           abs(absNormalized - 2 * Double.pi) < 1e-12 {
            return 0
        }
        
        // π/2의 홀수배에서는 ±1
        if abs(absNormalized - Double.pi / 2) < 1e-12 {
            return normalizedRadians > 0 ? 1 : -1
        }
        if abs(absNormalized - 3 * Double.pi / 2) < 1e-12 {
            return normalizedRadians > 0 ? -1 : 1
        }
        
        let result = sin(radians)
        
        // 매우 작은 값은 0으로 처리 (부동소수점 오차 방지)
        return abs(result) < 1e-15 ? 0 : result
    }
    
    /// 코사인 함수
    /// - Parameters:
    ///   - value: 각도 값
    ///   - angleUnit: 각도 단위
    /// - Returns: 코사인 값
    static func cosine(_ value: Double, angleUnit: AngleUnit) -> Double {
        guard value.isFinite else { return Double.nan }
        
        let radians = convertToRadians(value, from: angleUnit)
        
        // 특수한 각도 값들에 대한 정확한 처리
        let normalizedRadians = radians.truncatingRemainder(dividingBy: 2 * Double.pi)
        let absNormalized = abs(normalizedRadians)
        
        // 0, 2π에서는 정확히 1
        if absNormalized < 1e-12 || abs(absNormalized - 2 * Double.pi) < 1e-12 {
            return 1
        }
        
        // π에서는 정확히 -1
        if abs(absNormalized - Double.pi) < 1e-12 {
            return -1
        }
        
        // π/2, 3π/2에서는 정확히 0
        if abs(absNormalized - Double.pi / 2) < 1e-12 || 
           abs(absNormalized - 3 * Double.pi / 2) < 1e-12 {
            return 0
        }
        
        let result = cos(radians)
        
        // 매우 작은 값은 0으로 처리 (부동소수점 오차 방지)
        return abs(result) < 1e-15 ? 0 : result
    }
    
    /// 탄젠트 함수
    /// - Parameters:
    ///   - value: 각도 값
    ///   - angleUnit: 각도 단위
    /// - Returns: 탄젠트 값
    /// - Throws: CalculatorError.domainError (90도, 270도 등에서)
    static func tangent(_ value: Double, angleUnit: AngleUnit) throws -> Double {
        guard value.isFinite else { throw CalculatorError.domainError }
        
        let radians = convertToRadians(value, from: angleUnit)
        
        // tan이 정의되지 않는 값들 체크 (π/2 + nπ)
        let normalizedRadians = radians.truncatingRemainder(dividingBy: Double.pi)
        let halfPi = Double.pi / 2
        
        if abs(abs(normalizedRadians) - halfPi) < 1e-10 {
            throw CalculatorError.domainError
        }
        
        let result = tan(radians)
        
        // 결과가 무한대인 경우 에러 처리
        guard result.isFinite else {
            throw CalculatorError.domainError
        }
        
        // 매우 작은 값은 0으로 처리
        return abs(result) < 1e-15 ? 0 : result
    }
    
    // MARK: - Inverse Trigonometric Functions
    
    /// 아크사인 함수
    /// - Parameters:
    ///   - value: 입력 값 (-1 ~ 1)
    ///   - angleUnit: 결과 각도 단위
    /// - Returns: 아크사인 값
    /// - Throws: CalculatorError.domainError
    static func arcsine(_ value: Double, angleUnit: AngleUnit) throws -> Double {
        guard value >= -1 && value <= 1 else {
            throw CalculatorError.domainError
        }
        
        let radians = asin(value)
        return convertFromRadians(radians, to: angleUnit)
    }
    
    /// 아크코사인 함수
    /// - Parameters:
    ///   - value: 입력 값 (-1 ~ 1)
    ///   - angleUnit: 결과 각도 단위
    /// - Returns: 아크코사인 값
    /// - Throws: CalculatorError.domainError
    static func arccosine(_ value: Double, angleUnit: AngleUnit) throws -> Double {
        guard value >= -1 && value <= 1 else {
            throw CalculatorError.domainError
        }
        
        let radians = acos(value)
        return convertFromRadians(radians, to: angleUnit)
    }
    
    /// 아크탄젠트 함수
    /// - Parameters:
    ///   - value: 입력 값
    ///   - angleUnit: 결과 각도 단위
    /// - Returns: 아크탄젠트 값
    static func arctangent(_ value: Double, angleUnit: AngleUnit) -> Double {
        let radians = atan(value)
        return convertFromRadians(radians, to: angleUnit)
    }
    
    // MARK: - Logarithmic Functions
    
    /// 자연로그 함수
    /// - Parameter value: 입력 값 (양수)
    /// - Returns: 자연로그 값
    /// - Throws: CalculatorError.domainError
    static func naturalLog(_ value: Double) throws -> Double {
        guard value.isFinite else {
            throw CalculatorError.domainError
        }
        
        guard value > 0 else {
            throw CalculatorError.domainError
        }
        
        let result = log(value)
        try validateResult(result)
        
        return result
    }
    
    /// 상용로그 함수 (밑이 10)
    /// - Parameter value: 입력 값 (양수)
    /// - Returns: 상용로그 값
    /// - Throws: CalculatorError.domainError
    static func commonLog(_ value: Double) throws -> Double {
        guard value.isFinite else {
            throw CalculatorError.domainError
        }
        
        guard value > 0 else {
            throw CalculatorError.domainError
        }
        
        let result = log10(value)
        try validateResult(result)
        
        return result
    }
    
    /// 이진로그 함수 (밑이 2)
    /// - Parameter value: 입력 값 (양수)
    /// - Returns: 이진로그 값
    /// - Throws: CalculatorError.domainError
    static func binaryLog(_ value: Double) throws -> Double {
        guard value.isFinite else {
            throw CalculatorError.domainError
        }
        
        guard value > 0 else {
            throw CalculatorError.domainError
        }
        
        let result = log2(value)
        try validateResult(result)
        
        return result
    }
    
    // MARK: - Exponential Functions
    
    /// 자연지수 함수 (e^x)
    /// - Parameter value: 지수 값
    /// - Returns: 자연지수 값
    /// - Throws: CalculatorError.overflow, CalculatorError.underflow
    static func naturalExp(_ value: Double) throws -> Double {
        guard value.isFinite else {
            throw CalculatorError.domainError
        }
        
        // 오버플로우 방지를 위한 값 제한
        if value > 700 {
            throw CalculatorError.overflow
        }
        
        if value < -700 {
            return 0  // 언더플로우는 0으로 처리
        }
        
        let result = exp(value)
        try validateResult(result)
        
        return result
    }
    
    /// 10의 거듭제곱 함수 (10^x)
    /// - Parameter value: 지수 값
    /// - Returns: 10의 거듭제곱 값
    /// - Throws: CalculatorError.overflow, CalculatorError.underflow
    static func powerOfTen(_ value: Double) throws -> Double {
        guard value.isFinite else {
            throw CalculatorError.domainError
        }
        
        // 오버플로우 방지를 위한 값 제한
        if value > 300 {
            throw CalculatorError.overflow
        }
        
        if value < -300 {
            return 0  // 언더플로우는 0으로 처리
        }
        
        let result = pow(10, value)
        try validateResult(result)
        
        return result
    }
    
    // MARK: - Other Functions
    
    /// 제곱근 함수
    /// - Parameter value: 입력 값 (음이 아닌 수)
    /// - Returns: 제곱근 값
    /// - Throws: CalculatorError.domainError
    static func squareRoot(_ value: Double) throws -> Double {
        guard value.isFinite else {
            throw CalculatorError.domainError
        }
        
        guard value >= 0 else {
            throw CalculatorError.domainError
        }
        
        let result = sqrt(value)
        try validateResult(result)
        
        return result
    }
    
    /// 절댓값 함수
    /// - Parameter value: 입력 값
    /// - Returns: 절댓값
    static func absoluteValue(_ value: Double) -> Double {
        guard value.isFinite else { return Double.nan }
        return abs(value)
    }
    
    /// 세제곱근 함수
    /// - Parameter value: 입력 값
    /// - Returns: 세제곱근 값
    /// - Throws: CalculatorError.domainError (복소수 결과인 경우)
    static func cubeRoot(_ value: Double) throws -> Double {
        guard value.isFinite else {
            throw CalculatorError.domainError
        }
        
        let result: Double
        
        // 음수의 세제곱근은 음수
        if value < 0 {
            result = -pow(-value, 1.0/3.0)
        } else {
            result = pow(value, 1.0/3.0)
        }
        
        try validateResult(result)
        
        return result
    }
    
    // MARK: - Angle Conversion Helpers
    
    /// 각도를 라디안으로 변환
    /// - Parameters:
    ///   - value: 각도 값
    ///   - angleUnit: 현재 각도 단위
    /// - Returns: 라디안 값
    private static func convertToRadians(_ value: Double, from angleUnit: AngleUnit) -> Double {
        switch angleUnit {
        case .degree:
            return value * Double.pi / 180.0
        case .radian:
            return value
        }
    }
    
    /// 라디안을 지정된 각도 단위로 변환
    /// - Parameters:
    ///   - radians: 라디안 값
    ///   - angleUnit: 목표 각도 단위
    /// - Returns: 변환된 각도 값
    private static func convertFromRadians(_ radians: Double, to angleUnit: AngleUnit) -> Double {
        switch angleUnit {
        case .degree:
            return radians * 180.0 / Double.pi
        case .radian:
            return radians
        }
    }
    
    // MARK: - Private Helper Methods
    
    /// 계산 결과의 유효성을 검증하는 헬퍼 메서드
    /// - Parameter result: 검증할 결과
    /// - Throws: CalculatorError
    private static func validateResult(_ result: Double) throws {
        if result.isNaN {
            throw CalculatorError.domainError
        }
        
        if result.isInfinite {
            if result > 0 {
                throw CalculatorError.overflow
            } else {
                throw CalculatorError.underflow
            }
        }
    }
}

// MARK: - Double Extension for Validation

extension Double {
    /// 값이 정수인지 확인
    var isInteger: Bool {
        return floor(self) == self
    }
}