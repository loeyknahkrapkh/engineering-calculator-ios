import Foundation

/// 계산 엔진의 핵심 프로토콜
/// Protocol Oriented Programming을 적용하여 테스트 가능하고 확장 가능한 구조로 설계
public protocol CalculatorEngine {
    /// 현재 각도 단위 설정
    var angleUnit: AngleUnit { get set }
    
    /// 수식을 계산하고 결과를 반환
    /// - Parameter expression: 계산할 수식 문자열
    /// - Returns: 계산 결과
    /// - Throws: CalculatorError
    func calculate(_ expression: String) throws -> Double
    
    /// 수식의 유효성을 검증
    /// - Parameter expression: 검증할 수식 문자열
    /// - Returns: 유효성 여부
    func validateExpression(_ expression: String) -> Bool
    
    /// 결과를 포맷팅하여 문자열로 반환
    /// - Parameter result: 포맷팅할 숫자
    /// - Returns: 포맷팅된 문자열
    func formatResult(_ result: Double) -> String
}

/// 계산 과정에서 발생할 수 있는 에러 타입
public enum CalculatorError: LocalizedError, Equatable {
    case invalidExpression
    case divisionByZero
    case domainError
    case overflow
    case underflow
    case unknownFunction
    case missingOperand
    case invalidParentheses
    
    public var errorDescription: String? {
        switch self {
        case .invalidExpression:
            return "잘못된 수식입니다"
        case .divisionByZero:
            return "0으로 나눌 수 없습니다"
        case .domainError:
            return "정의역을 벗어났습니다"
        case .overflow:
            return "결과가 너무 큽니다"
        case .underflow:
            return "결과가 너무 작습니다"
        case .unknownFunction:
            return "알 수 없는 함수입니다"
        case .missingOperand:
            return "피연산자가 누락되었습니다"
        case .invalidParentheses:
            return "괄호가 올바르지 않습니다"
        }
    }
} 