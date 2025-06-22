import Foundation

/// 수식을 파싱하고 계산하는 클래스
/// Shunting Yard Algorithm을 사용하여 중위 표기법을 후위 표기법으로 변환
class ExpressionParser {
    
    /// 토큰 타입 정의
    enum Token: Equatable {
        case number(Double)
        case `operator`(String)
        case function(String)
        case leftParenthesis
        case rightParenthesis
        case constant(String)
    }
    
    /// 연산자 우선순위 정의
    private let operatorPrecedence: [String: Int] = [
        "+": 1,
        "-": 1,
        "*": 2,
        "/": 2,
        "^": 3,
        "**": 3
    ]
    
    /// 연산자의 결합성 정의 (true: 좌결합, false: 우결합)
    private let operatorAssociativity: [String: Bool] = [
        "+": true,
        "-": true,
        "*": true,
        "/": true,
        "^": false,
        "**": false
    ]
    
    /// 지원하는 함수 목록
    private let supportedFunctions: Set<String> = [
        "sin", "cos", "tan",
        "asin", "acos", "atan",
        "ln", "log", "log2",
        "exp", "sqrt", "abs"
    ]
    
    /// 수학 상수 정의
    private let constants: [String: Double] = [
        "π": Double.pi,
        "pi": Double.pi,
        "e": exp(1.0)
    ]
    
    // MARK: - Public Methods
    
    /// 수식 문자열을 토큰으로 분해
    /// - Parameter expression: 수식 문자열
    /// - Returns: 토큰 배열
    /// - Throws: CalculatorError
    func tokenize(_ expression: String) throws -> [Token] {
        // TODO: 구현 예정
        return []
    }
    
    /// 중위 표기법을 후위 표기법으로 변환 (Shunting Yard Algorithm)
    /// - Parameter tokens: 중위 표기법 토큰 배열
    /// - Returns: 후위 표기법 토큰 배열
    /// - Throws: CalculatorError
    func infixToPostfix(_ tokens: [Token]) throws -> [Token] {
        // TODO: 구현 예정
        return []
    }
    
    /// 후위 표기법 토큰을 계산
    /// - Parameters:
    ///   - tokens: 후위 표기법 토큰 배열
    ///   - angleUnit: 각도 단위
    /// - Returns: 계산 결과
    /// - Throws: CalculatorError
    func evaluatePostfix(_ tokens: [Token], angleUnit: AngleUnit) throws -> Double {
        // TODO: 구현 예정
        return 0.0
    }
    
    /// 수식의 괄호 균형을 검증
    /// - Parameter expression: 수식 문자열
    /// - Returns: 괄호가 균형있는지 여부
    func validateParentheses(_ expression: String) -> Bool {
        var openCount = 0
        
        for char in expression {
            switch char {
            case "(":
                openCount += 1
            case ")":
                openCount -= 1
                // 닫는 괄호가 여는 괄호보다 많으면 즉시 false 반환
                if openCount < 0 {
                    return false
                }
            default:
                continue
            }
        }
        
        // 모든 괄호가 균형있게 닫혔는지 확인
        return openCount == 0
    }
    
    // MARK: - Private Helper Methods
    
    /// 연산자 우선순위 비교
    /// - Parameters:
    ///   - op1: 첫 번째 연산자
    ///   - op2: 두 번째 연산자
    /// - Returns: op1이 op2보다 우선순위가 높거나 같은지 여부
    private func hasHigherOrEqualPrecedence(_ op1: String, than op2: String) -> Bool {
        guard let prec1 = operatorPrecedence[op1],
              let prec2 = operatorPrecedence[op2] else {
            return false
        }
        
        if prec1 > prec2 {
            return true
        } else if prec1 == prec2 {
            return operatorAssociativity[op1] ?? true
        } else {
            return false
        }
    }
    
    /// 문자가 숫자인지 확인
    /// - Parameter char: 확인할 문자
    /// - Returns: 숫자 여부
    private func isDigit(_ char: Character) -> Bool {
        return char.isNumber || char == "."
    }
    
    /// 문자가 알파벳인지 확인
    /// - Parameter char: 확인할 문자
    /// - Returns: 알파벳 여부
    private func isAlpha(_ char: Character) -> Bool {
        return char.isLetter
    }
} 
