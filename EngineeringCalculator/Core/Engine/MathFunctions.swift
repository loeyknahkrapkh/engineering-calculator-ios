import Foundation

/// 수학 함수들을 제공하는 클래스
/// 공학용 계산기에서 사용하는 모든 수학 함수를 구현
class MathFunctions {
    
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
        let result = pow(base, exponent)
        
        // 결과 유효성 검증
        guard result.isFinite else {
            if result.isInfinite {
                throw CalculatorError.overflow
            } else {
                throw CalculatorError.domainError
            }
        }
        
        return result
    }
    
    // MARK: - Trigonometric Functions
    
    /// 사인 함수
    /// - Parameters:
    ///   - value: 각도 값
    ///   - angleUnit: 각도 단위
    /// - Returns: 사인 값
    static func sine(_ value: Double, angleUnit: AngleUnit) -> Double {
        let radians = convertToRadians(value, from: angleUnit)
        return sin(radians)
    }
    
    /// 코사인 함수
    /// - Parameters:
    ///   - value: 각도 값
    ///   - angleUnit: 각도 단위
    /// - Returns: 코사인 값
    static func cosine(_ value: Double, angleUnit: AngleUnit) -> Double {
        let radians = convertToRadians(value, from: angleUnit)
        return cos(radians)
    }
    
    /// 탄젠트 함수
    /// - Parameters:
    ///   - value: 각도 값
    ///   - angleUnit: 각도 단위
    /// - Returns: 탄젠트 값
    static func tangent(_ value: Double, angleUnit: AngleUnit) -> Double {
        let radians = convertToRadians(value, from: angleUnit)
        return tan(radians)
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
        guard value > 0 else {
            throw CalculatorError.domainError
        }
        return log(value)
    }
    
    /// 상용로그 함수 (밑이 10)
    /// - Parameter value: 입력 값 (양수)
    /// - Returns: 상용로그 값
    /// - Throws: CalculatorError.domainError
    static func commonLog(_ value: Double) throws -> Double {
        guard value > 0 else {
            throw CalculatorError.domainError
        }
        return log10(value)
    }
    
    /// 이진로그 함수 (밑이 2)
    /// - Parameter value: 입력 값 (양수)
    /// - Returns: 이진로그 값
    /// - Throws: CalculatorError.domainError
    static func binaryLog(_ value: Double) throws -> Double {
        guard value > 0 else {
            throw CalculatorError.domainError
        }
        return log2(value)
    }
    
    // MARK: - Exponential Functions
    
    /// 자연지수 함수 (e^x)
    /// - Parameter value: 지수 값
    /// - Returns: 자연지수 값
    /// - Throws: CalculatorError.overflow
    static func naturalExp(_ value: Double) throws -> Double {
        let result = exp(value)
        guard result.isFinite else {
            throw CalculatorError.overflow
        }
        return result
    }
    
    /// 10의 거듭제곱 함수 (10^x)
    /// - Parameter value: 지수 값
    /// - Returns: 10의 거듭제곱 값
    /// - Throws: CalculatorError.overflow
    static func powerOfTen(_ value: Double) throws -> Double {
        let result = pow(10, value)
        guard result.isFinite else {
            throw CalculatorError.overflow
        }
        return result
    }
    
    // MARK: - Other Functions
    
    /// 제곱근 함수
    /// - Parameter value: 입력 값 (음이 아닌 수)
    /// - Returns: 제곱근 값
    /// - Throws: CalculatorError.domainError
    static func squareRoot(_ value: Double) throws -> Double {
        guard value >= 0 else {
            throw CalculatorError.domainError
        }
        return sqrt(value)
    }
    
    /// 절댓값 함수
    /// - Parameter value: 입력 값
    /// - Returns: 절댓값
    static func absoluteValue(_ value: Double) -> Double {
        return abs(value)
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
} 