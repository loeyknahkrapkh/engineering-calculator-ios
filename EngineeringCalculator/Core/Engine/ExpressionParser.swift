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
        "exp", "sqrt", "abs", "cbrt", "pow10"
    ]
    
    /// 수학 상수 정의
    private let constants: [String: Double] = [
        "π": Double.pi,
        "pi": Double.pi,
        "e": exp(1.0)  // 더 정확한 자연상수 e
    ]
    
    // MARK: - Public Methods
    
    /// 수식 문자열을 토큰으로 분해
    /// - Parameter expression: 수식 문자열
    /// - Returns: 토큰 배열
    /// - Throws: CalculatorError
    func tokenize(_ expression: String) throws -> [Token] {
        // 빈 문자열 검증
        guard !expression.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw CalculatorError.invalidExpression
        }
        
        // 음수 처리를 위한 전처리
        let preprocessed = preprocessNegativeNumbers(expression)
        
        var tokens: [Token] = []
        var i = preprocessed.startIndex
        let maxIterations = 1000  // 무한루프 방지
        var iterations = 0
        
        while i < preprocessed.endIndex && iterations < maxIterations {
            let char = preprocessed[i]
            let previousIndex = i  // 무한루프 감지용
            
            // 공백 건너뛰기
            if char.isWhitespace {
                i = preprocessed.index(after: i)
                iterations += 1
                continue
            }
            
            // 숫자 파싱
            if char.isNumber || char == "." {
                let (number, nextIndex) = try parseNumber(from: preprocessed, startIndex: i)
                tokens.append(.number(number))
                i = nextIndex
                
                // 인덱스가 진행되었는지 확인
                guard i > previousIndex else {
                    throw CalculatorError.invalidExpression
                }
                iterations += 1
                continue
            }
            
            // 알파벳 (함수명 또는 상수)
            if char.isLetter || char == "π" {
                let (identifier, nextIndex) = parseIdentifier(from: preprocessed, startIndex: i)
                
                // 빈 식별자 체크 (무한루프 방지)
                guard !identifier.isEmpty else {
                    throw CalculatorError.invalidExpression
                }
                
                // 인덱스가 진행되었는지 확인
                guard nextIndex > previousIndex else {
                    throw CalculatorError.invalidExpression
                }
                
                // 상수 확인
                if constants.keys.contains(identifier) {
                    tokens.append(.constant(identifier))
                }
                // 함수 확인
                else if supportedFunctions.contains(identifier) {
                    tokens.append(.function(identifier))
                }
                else {
                    throw CalculatorError.unknownFunction
                }
                
                i = nextIndex
                iterations += 1
                continue
            }
            
            // 단일 문자 토큰들
            switch char {
            case "(":
                tokens.append(.leftParenthesis)
            case ")":
                tokens.append(.rightParenthesis)
            case "+", "-", "*", "/", "^":
                tokens.append(.operator(String(char)))
            case "×":
                tokens.append(.operator("*"))
            case "÷":
                tokens.append(.operator("/"))
            default:
                throw CalculatorError.invalidExpression
            }
            
            i = preprocessed.index(after: i)
            iterations += 1
        }
        
        // 최대 반복 횟수 초과 시 에러
        if iterations >= maxIterations {
            throw CalculatorError.invalidExpression
        }
        
        // 빈 토큰 배열 검증
        guard !tokens.isEmpty else {
            throw CalculatorError.invalidExpression
        }
        
        // 토큰 배열 유효성 검증
        try validateTokenSequence(tokens)
        
        return tokens
    }
    
    /// 중위 표기법을 후위 표기법으로 변환 (Shunting Yard Algorithm)
    /// - Parameter tokens: 중위 표기법 토큰 배열
    /// - Returns: 후위 표기법 토큰 배열
    /// - Throws: CalculatorError
    func infixToPostfix(_ tokens: [Token]) throws -> [Token] {
        var output: [Token] = []
        var operatorStack: [Token] = []
        let maxIterations = 1000  // 무한루프 방지
        var totalIterations = 0
        
        for token in tokens {
            guard totalIterations < maxIterations else {
                throw CalculatorError.invalidExpression
            }
            
            switch token {
            case .number(_), .constant(_):
                // 숫자와 상수는 직접 출력 큐에 추가
                output.append(token)
                
            case .function(_):
                // 함수는 연산자 스택에 푸시
                operatorStack.append(token)
                
            case .leftParenthesis:
                // 왼쪽 괄호는 연산자 스택에 푸시
                operatorStack.append(token)
                
            case .rightParenthesis:
                // 오른쪽 괄호를 만나면 왼쪽 괄호까지 모든 연산자를 출력
                var foundLeftParen = false
                var parenIterations = 0
                
                while operatorStack.last != nil && parenIterations < 100 {
                    let topToken = operatorStack.removeLast()
                    
                    if case .leftParenthesis = topToken {
                        foundLeftParen = true
                        break
                    } else {
                        output.append(topToken)
                    }
                    parenIterations += 1
                }
                
                if !foundLeftParen {
                    throw CalculatorError.invalidParentheses
                }
                
                // 함수가 있다면 출력 큐에 추가
                if let topToken = operatorStack.last,
                   case .function(_) = topToken {
                    operatorStack.removeLast()
                    output.append(topToken)
                }
                
            case .operator(let op):
                // 연산자 처리
                var operatorIterations = 0
                let maxOperatorIterations = 50
                
                while operatorStack.last != nil && operatorIterations < maxOperatorIterations {
                    guard let topToken = operatorStack.last else { break }
                    
                    var shouldBreak = false
                    
                    switch topToken {
                    case .operator(let topOp):
                        let hasHigherPrec = hasHigherOrEqualPrecedence(topOp, than: op)
                        
                        if hasHigherPrec {
                            operatorStack.removeLast()
                            output.append(topToken)
                        } else {
                            shouldBreak = true
                        }
                    case .function(_):
                        // 함수는 항상 연산자보다 우선순위가 높음
                        operatorStack.removeLast()
                        output.append(topToken)
                    default:
                        shouldBreak = true
                    }
                    
                    if shouldBreak {
                        break
                    }
                    
                    operatorIterations += 1
                }
                
                // 무한루프 감지
                if operatorIterations >= maxOperatorIterations {
                    throw CalculatorError.invalidExpression
                }
                
                operatorStack.append(token)
            }
            
            totalIterations += 1
        }
        
        // 남은 연산자들을 모두 출력 큐에 추가
        var finalIterations = 0
        while operatorStack.last != nil && finalIterations < 100 {
            let topToken = operatorStack.removeLast()
            
            if case .leftParenthesis = topToken {
                throw CalculatorError.invalidParentheses
            }
            
            output.append(topToken)
            finalIterations += 1
        }
        
        return output
    }
    
    /// 후위 표기법 토큰을 계산
    /// - Parameters:
    ///   - tokens: 후위 표기법 토큰 배열
    ///   - angleUnit: 각도 단위
    /// - Returns: 계산 결과
    /// - Throws: CalculatorError
    func evaluatePostfix(_ tokens: [Token], angleUnit: AngleUnit) throws -> Double {
        var stack: [Double] = []
        
        for token in tokens {
            switch token {
            case .number(let value):
                stack.append(value)
                
            case .constant(let constantName):
                guard let value = constants[constantName] else {
                    throw CalculatorError.invalidExpression
                }
                stack.append(value)
                
            case .operator(let op):
                guard stack.count >= 2 else {
                    throw CalculatorError.missingOperand
                }
                
                let rhs = stack.removeLast()
                let lhs = stack.removeLast()
                
                let result = try evaluateOperation(lhs: lhs, op: op, rhs: rhs)
                stack.append(result)
                
            case .function(let functionName):
                guard stack.count >= 1 else {
                    throw CalculatorError.missingOperand
                }
                
                let operand = stack.removeLast()
                let result = try evaluateFunction(functionName: functionName, operand: operand, angleUnit: angleUnit)
                stack.append(result)
                
            case .leftParenthesis, .rightParenthesis:
                // 후위 표기법에서는 괄호가 없어야 함
                throw CalculatorError.invalidExpression
            }
        }
        
        guard stack.count == 1 else {
            throw CalculatorError.invalidExpression
        }
        
        return stack[0]
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
    
    // MARK: - Private Preprocessing Methods
    
    /// 음수 처리를 위한 전처리
    /// - Parameter expression: 원본 수식
    /// - Returns: 전처리된 수식
    private func preprocessNegativeNumbers(_ expression: String) -> String {
        var result = expression
        
        // 함수 뒤의 음수를 처리 (예: "ln(-1)" → "ln(0-1)")
        let functionPattern = #"(\b(?:sin|cos|tan|asin|acos|atan|ln|log|log2|exp|sqrt|abs|cbrt|pow10)\s*\(\s*)-"#
        result = result.replacingOccurrences(of: functionPattern, with: "$10-", options: .regularExpression)
        
        // 괄호 시작 부분의 음수 처리 (예: "(-1)" → "(0-1)")
        result = result.replacingOccurrences(of: "(-", with: "(0-")
        
        // 수식 시작 부분의 음수 처리 (예: "-5" → "0-5")
        if result.hasPrefix("-") {
            result = "0" + result
        }
        
        return result
    }
    
    // MARK: - Private Validation Methods
    
    /// 토큰 시퀀스의 유효성을 검증
    /// - Parameter tokens: 검증할 토큰 배열
    /// - Throws: CalculatorError
    private func validateTokenSequence(_ tokens: [Token]) throws {
        guard !tokens.isEmpty else {
            throw CalculatorError.invalidExpression
        }
        
        var previousToken: Token? = nil
        var openParenthesesCount = 0
        
        for (index, token) in tokens.enumerated() {
            switch token {
            case .number(_), .constant(_):
                // 숫자나 상수 다음에 또 다른 숫자/상수가 오면 에러
                if let prev = previousToken,
                   case .number(_) = prev {
                    throw CalculatorError.invalidExpression
                }
                if let prev = previousToken,
                   case .constant(_) = prev {
                    throw CalculatorError.invalidExpression
                }
                
            case .operator(let op):
                // 연산자가 마지막에 오면 에러
                if index == tokens.count - 1 {
                    throw CalculatorError.missingOperand
                }
                
                // 연산자가 처음에 오는 경우는 음수/양수 부호일 수 있음
                if index == 0 && !(op == "+" || op == "-") {
                    throw CalculatorError.invalidExpression
                }
                
                // 연속된 연산자 체크
                if let prev = previousToken,
                   case .operator(let prevOp) = prev {
                    // 같은 연산자가 연속으로 오는 경우 (예: "++", "--", "**")
                    if op == prevOp {
                        throw CalculatorError.invalidExpression
                    }
                    // 일반적으로 연속된 연산자는 허용하지 않음 (음수 처리는 전처리에서 해결)
                    throw CalculatorError.invalidExpression
                }
                
            case .function(_):
                // 함수 다음에는 반드시 여는 괄호가 와야 함 (암시적으로 처리됨)
                break
                
            case .leftParenthesis:
                openParenthesesCount += 1
                
            case .rightParenthesis:
                openParenthesesCount -= 1
                if openParenthesesCount < 0 {
                    throw CalculatorError.invalidParentheses
                }
                
                // 빈 괄호 체크
                if let prev = previousToken,
                   case .leftParenthesis = prev {
                    throw CalculatorError.invalidExpression
                }
            }
            
            previousToken = token
        }
        
        // 괄호 균형 체크
        if openParenthesesCount != 0 {
            throw CalculatorError.invalidParentheses
        }
    }
    
    // MARK: - Private Helper Methods
    
    /// 연산자 우선순위 비교
    /// - Parameters:
    ///   - op1: 첫 번째 연산자 (스택의 top)
    ///   - op2: 두 번째 연산자 (새로 들어오는 연산자)
    /// - Returns: op1이 op2보다 우선순위가 높거나 같은지 여부
    private func hasHigherOrEqualPrecedence(_ op1: String, than op2: String) -> Bool {
        guard let prec1 = operatorPrecedence[op1],
              let prec2 = operatorPrecedence[op2] else {
            return false
        }
        
        if prec1 > prec2 {
            return true
        } else if prec1 == prec2 {
            // 같은 우선순위일 때는 새로 들어오는 연산자(op2)의 결합성을 확인
            // 좌결합(true)이면 스택의 연산자가 높거나 같은 우선순위로 처리
            // 우결합(false)이면 스택의 연산자가 낮은 우선순위로 처리
            let isLeftAssociative = operatorAssociativity[op2] ?? true
            return isLeftAssociative
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
    
    // MARK: - Private Parsing Helper Methods
    
    /// 숫자를 파싱하는 헬퍼 메서드
    /// - Parameters:
    ///   - expression: 전체 수식 문자열
    ///   - startIndex: 파싱 시작 인덱스
    /// - Returns: 파싱된 숫자와 다음 인덱스
    /// - Throws: CalculatorError.invalidExpression
    private func parseNumber(from expression: String, startIndex: String.Index) throws -> (Double, String.Index) {
        var i = startIndex
        var numberString = ""
        var hasDecimalPoint = false
        let maxIterations = 50  // 무한루프 방지
        var iterations = 0
        
        while i < expression.endIndex && iterations < maxIterations {
            let char = expression[i]
            
            if char.isNumber {
                numberString.append(char)
            } else if char == "." && !hasDecimalPoint {
                hasDecimalPoint = true
                numberString.append(char)
            } else {
                break
            }
            
            i = expression.index(after: i)
            iterations += 1
        }
        
        // 빈 숫자 문자열 체크 (무한루프 방지)
        guard !numberString.isEmpty else {
            throw CalculatorError.invalidExpression
        }
        
        guard let number = Double(numberString) else {
            throw CalculatorError.invalidExpression
        }
        
        return (number, i)
    }
    
    /// 식별자(함수명, 상수명)를 파싱하는 헬퍼 메서드
    /// - Parameters:
    ///   - expression: 전체 수식 문자열
    ///   - startIndex: 파싱 시작 인덱스
    /// - Returns: 파싱된 식별자와 다음 인덱스
    private func parseIdentifier(from expression: String, startIndex: String.Index) -> (String, String.Index) {
        var i = startIndex
        var identifier = ""
        let maxIterations = 50  // 무한루프 방지
        var iterations = 0
        
        while i < expression.endIndex && iterations < maxIterations {
            let char = expression[i]
            
            if char.isLetter || char.isNumber || char == "π" {
                identifier.append(char)
            } else {
                break
            }
            
            i = expression.index(after: i)
            iterations += 1
        }
        
        return (identifier, i)
    }
    
    // MARK: - Private Evaluation Helper Methods
    
    /// 이항 연산을 수행하는 헬퍼 메서드
    /// - Parameters:
    ///   - lhs: 좌측 피연산자
    ///   - op: 연산자
    ///   - rhs: 우측 피연산자
    /// - Returns: 연산 결과
    /// - Throws: CalculatorError
    private func evaluateOperation(lhs: Double, op: String, rhs: Double) throws -> Double {
        switch op {
        case "+":
            return MathFunctions.add(lhs, rhs)
        case "-":
            return MathFunctions.subtract(lhs, rhs)
        case "*":
            return MathFunctions.multiply(lhs, rhs)
        case "/":
            return try MathFunctions.divide(lhs, rhs)
        case "^":
            return try MathFunctions.power(lhs, rhs)
        default:
            throw CalculatorError.invalidExpression
        }
    }
    
    /// 함수를 평가하는 헬퍼 메서드
    /// - Parameters:
    ///   - functionName: 함수명
    ///   - operand: 피연산자
    ///   - angleUnit: 각도 단위
    /// - Returns: 함수 계산 결과
    /// - Throws: CalculatorError
    private func evaluateFunction(functionName: String, operand: Double, angleUnit: AngleUnit) throws -> Double {
        switch functionName {
        // 삼각함수
        case "sin":
            return MathFunctions.sine(operand, angleUnit: angleUnit)
        case "cos":
            return MathFunctions.cosine(operand, angleUnit: angleUnit)
        case "tan":
            return try MathFunctions.tangent(operand, angleUnit: angleUnit)
            
        // 역삼각함수
        case "asin":
            return try MathFunctions.arcsine(operand, angleUnit: angleUnit)
        case "acos":
            return try MathFunctions.arccosine(operand, angleUnit: angleUnit)
        case "atan":
            return MathFunctions.arctangent(operand, angleUnit: angleUnit)
            
        // 로그함수
        case "ln":
            return try MathFunctions.naturalLog(operand)
        case "log":
            return try MathFunctions.commonLog(operand)
        case "log2":
            return try MathFunctions.binaryLog(operand)
            
        // 지수함수
        case "exp":
            return try MathFunctions.naturalExp(operand)
            
        // 기타 함수
        case "sqrt":
            return try MathFunctions.squareRoot(operand)
        case "abs":
            return MathFunctions.absoluteValue(operand)
        case "cbrt":
            return try MathFunctions.cubeRoot(operand)
        case "pow10":
            return try MathFunctions.powerOfTen(operand)
            
        default:
            throw CalculatorError.unknownFunction
        }
    }
} 
