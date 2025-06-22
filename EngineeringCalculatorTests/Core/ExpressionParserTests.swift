import Testing
@testable import EngineeringCalculator

/// 수식 파서의 기능을 테스트하는 구조체
struct ExpressionParserTests {
    
    // MARK: - Parentheses Validation Tests
    
    @Test("균형잡힌 괄호 검증", arguments: [
        "(1+2)",
        "((1+2)*3)",
        "(1+(2*3))",
        "sin(30)"
    ])
    func validateParenthesesWithBalancedParentheses(expression: String) {
        // Given
        let parser = ExpressionParser()
        
        // When
        let isValid = parser.validateParentheses(expression)
        
        // Then
        #expect(isValid, "균형잡힌 괄호는 유효해야 합니다: \(expression)")
    }
    
    @Test("불균형한 괄호 검증", arguments: [
        "(1+2",
        "1+2)",
        "((1+2)",
        "(1+2))",
        ")1+2("
    ])
    func validateParenthesesWithUnbalancedParentheses(expression: String) {
        // Given
        let parser = ExpressionParser()
        
        // When
        let isValid = parser.validateParentheses(expression)
        
        // Then
        #expect(!isValid, "불균형한 괄호는 유효하지 않아야 합니다: \(expression)")
    }
    
    @Test("괄호가 없는 수식 검증")
    func validateParenthesesWithNoParentheses() {
        // Given
        let parser = ExpressionParser()
        let expression = "1+2*3"
        
        // When
        let isValid = parser.validateParentheses(expression)
        
        // Then
        #expect(isValid, "괄호가 없는 수식은 유효해야 합니다")
    }
    
    @Test("빈 문자열 괄호 검증")
    func validateParenthesesWithEmptyString() {
        // Given
        let parser = ExpressionParser()
        let expression = ""
        
        // When
        let isValid = parser.validateParentheses(expression)
        
        // Then
        #expect(isValid, "빈 문자열은 괄호 검증에서 유효해야 합니다")
    }
    
    // MARK: - Token Tests
    
    @Test("토큰 생성 확인")
    func tokenCreation() {
        // Given & When
        let numberToken = ExpressionParser.Token.number(3.14)
        let operatorToken = ExpressionParser.Token.operator("+")
        let functionToken = ExpressionParser.Token.function("sin")
        let leftParenToken = ExpressionParser.Token.leftParenthesis
        let rightParenToken = ExpressionParser.Token.rightParenthesis
        let constantToken = ExpressionParser.Token.constant("π")
        
        // Then - 토큰들이 정상적으로 생성되는지 확인
        switch numberToken {
        case .number(let value):
            #expect(value == 3.14, "숫자 토큰의 값이 올바르지 않습니다")
        default:
            Issue.record("숫자 토큰이 생성되지 않았습니다")
        }
        
        switch operatorToken {
        case .`operator`(let op):
            #expect(op == "+", "연산자 토큰의 값이 올바르지 않습니다")
        default:
            Issue.record("연산자 토큰이 생성되지 않았습니다")
        }
        
        switch functionToken {
        case .function(let functionName):
            #expect(functionName == "sin", "함수 토큰의 값이 올바르지 않습니다")
        default:
            Issue.record("함수 토큰이 생성되지 않았습니다")
        }
        
        switch leftParenToken {
        case .leftParenthesis:
            break // 성공
        default:
            Issue.record("왼쪽 괄호 토큰이 생성되지 않았습니다")
        }
        
        switch rightParenToken {
        case .rightParenthesis:
            break // 성공
        default:
            Issue.record("오른쪽 괄호 토큰이 생성되지 않았습니다")
        }
        
        switch constantToken {
        case .constant(let const):
            #expect(const == "π", "상수 토큰의 값이 올바르지 않습니다")
        default:
            Issue.record("상수 토큰이 생성되지 않았습니다")
        }
    }
    
    // MARK: - Future Test Placeholders
    
    // TODO: 실제 구현 후 활성화할 테스트들
    
    /*
    @Test("간단한 수식 토큰화")
    func tokenizeSimpleExpression() throws {
        // Given
        let parser = ExpressionParser()
        
        // When
        let tokens = try parser.tokenize("1+2")
        
        // Then
        #expect(tokens.count == 3)
    }
    
    @Test("중위 표기법을 후위 표기법으로 변환")
    func infixToPostfixConversion() throws {
        // Given
        let parser = ExpressionParser()
        let tokens = [ExpressionParser.Token.number(1), ExpressionParser.Token.`operator`("+"), ExpressionParser.Token.number(2)]
        
        // When
        let postfix = try parser.infixToPostfix(tokens)
        
        // Then
        #expect(postfix.count == 3)
    }
    
    @Test("후위 표기법 계산")
    func evaluatePostfixExpression() throws {
        // Given
        let parser = ExpressionParser()
        let tokens = [ExpressionParser.Token.number(1), ExpressionParser.Token.number(2), ExpressionParser.Token.`operator`("+")]
        
        // When
        let result = try parser.evaluatePostfix(tokens, angleUnit: .degree)
        
        // Then
        #expect(result == 3.0)
    }
    */
} 