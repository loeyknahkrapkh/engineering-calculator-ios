import Testing
import Foundation
@testable import EngineeringCalculator

/// 수식 파서의 기능을 테스트하는 구조체
@Suite("Expression Parser Tests")
struct ExpressionParserTests {
    let parser = ExpressionParser()
    
    // MARK: - Tokenization Tests
    
    @Test("토큰화 - 기본 숫자")
    func testTokenizeNumbers() throws {
        let tokens = try parser.tokenize("123")
        #expect(tokens == [.number(123)])
    }
    
    @Test("토큰화 - 기본 숫자 - 소수점")
    func testTokenizeDecimalNumbers() throws {
        let tokensDecimal = try parser.tokenize("3.14")
        #expect(tokensDecimal == [.number(3.14)])
    }
    
    @Test("토큰화 - 기본 연산자")
    func testTokenizeOperators() throws {
        let tokens = try parser.tokenize("1+2")
        #expect(tokens == [.number(1), .operator("+"), .number(2)])
        
        let tokensMultiple = try parser.tokenize("1+2*3")
        #expect(tokensMultiple == [.number(1), .operator("+"), .number(2), .operator("*"), .number(3)])
    }
    
    @Test("토큰화 - 괄호")
    func testTokenizeParentheses() throws {
        let tokens = try parser.tokenize("(1+2)")
        #expect(tokens == [.leftParenthesis, .number(1), .operator("+"), .number(2), .rightParenthesis])
    }
    
    @Test("토큰화 - 함수")
    func testTokenizeFunctions() throws {
        let tokens = try parser.tokenize("sin(30)")
        #expect(tokens == [.function("sin"), .leftParenthesis, .number(30), .rightParenthesis])
    }
    
    @Test("토큰화 - 상수")
    func testTokenizeConstants() throws {
        let tokens = try parser.tokenize("π+e")
        #expect(tokens == [.constant("π"), .operator("+"), .constant("e")])
    }
    
    @Test("토큰화 - 복잡한 수식")
    func testTokenizeComplexExpression() throws {
        let tokens = try parser.tokenize("sin(π/2)+log(10)")
        let expected: [ExpressionParser.Token] = [
            .function("sin"), .leftParenthesis, .constant("π"), .operator("/"), .number(2), .rightParenthesis,
            .operator("+"),
            .function("log"), .leftParenthesis, .number(10), .rightParenthesis
        ]
        #expect(tokens == expected)
    }
    
    @Test("토큰화 - 공백 처리")
    func testTokenizeWithSpaces() throws {
        let tokens = try parser.tokenize("  1  +  2  ")
        #expect(tokens == [.number(1), .operator("+"), .number(2)])
    }
    
    @Test("토큰화 - 잘못된 수식")
    func testTokenizeInvalidExpression() {
        #expect(throws: CalculatorError.invalidExpression) {
            try parser.tokenize("1++2")
        }
        
        #expect(throws: CalculatorError.unknownFunction) {
            try parser.tokenize("unknown(1)")
        }
    }
    
    // MARK: - Infix to Postfix Tests
    
    @Test("중위->후위 변환 - 기본 연산")
    func testInfixToPostfixBasic() throws {
        let tokens: [ExpressionParser.Token] = [.number(1), .operator("+"), .number(2)]
        let postfix = try parser.infixToPostfix(tokens)
        #expect(postfix == [.number(1), .number(2), .operator("+")])
    }
    
    @Test("중위->후위 변환 - 연산자 우선순위")
    func testInfixToPostfixPrecedence() throws {
        let tokens: [ExpressionParser.Token] = [.number(1), .operator("+"), .number(2), .operator("*"), .number(3)]
        let postfix = try parser.infixToPostfix(tokens)
        #expect(postfix == [.number(1), .number(2), .number(3), .operator("*"), .operator("+")])
    }
    
    @Test("중위->후위 변환 - 괄호")
    func testInfixToPostfixParentheses() throws {
        let tokens: [ExpressionParser.Token] = [
            .leftParenthesis, .number(1), .operator("+"), .number(2), .rightParenthesis, .operator("*"), .number(3)
        ]
        let postfix = try parser.infixToPostfix(tokens)
        #expect(postfix == [.number(1), .number(2), .operator("+"), .number(3), .operator("*")])
    }
    
    @Test("중위->후위 변환 - 함수")
    func testInfixToPostfixFunction() throws {
        let tokens: [ExpressionParser.Token] = [
            .function("sin"), .leftParenthesis, .number(30), .rightParenthesis
        ]
        let postfix = try parser.infixToPostfix(tokens)
        #expect(postfix == [.number(30), .function("sin")])
    }
    
    @Test("중위->후위 변환 - 거듭제곱 (우결합) - 간단한 케이스")
    func testInfixToPostfixPowerSimple() throws {
        let tokens: [ExpressionParser.Token] = [.number(2), .operator("^"), .number(3)]
        let postfix = try parser.infixToPostfix(tokens)
        #expect(postfix == [.number(2), .number(3), .operator("^")])
    }
    
    @Test("중위->후위 변환 - 거듭제곱 (우결합) - 복잡한 케이스")
    func testInfixToPostfixPowerRightAssociative() throws {
        let tokens: [ExpressionParser.Token] = [.number(2), .operator("^"), .number(3), .operator("^"), .number(2)]
        let postfix = try parser.infixToPostfix(tokens)
        #expect(postfix == [.number(2), .number(3), .number(2), .operator("^"), .operator("^")])
    }
    
    // MARK: - Postfix Evaluation Tests
    
    @Test("후위 계산 - 기본 연산")
    func testEvaluatePostfixBasic() throws {
        let tokens: [ExpressionParser.Token] = [.number(1), .number(2), .operator("+")]
        let result = try parser.evaluatePostfix(tokens, angleUnit: .degree)
        #expect(result == 3.0)
    }
    
    @Test("후위 계산 - 복합 연산")
    func testEvaluatePostfixComplex() throws {
        let tokens: [ExpressionParser.Token] = [.number(1), .number(2), .number(3), .operator("*"), .operator("+")]
        let result = try parser.evaluatePostfix(tokens, angleUnit: .degree)
        #expect(result == 7.0)
    }
    
    @Test("후위 계산 - 함수")
    func testEvaluatePostfixFunction() throws {
        let tokens: [ExpressionParser.Token] = [.number(90), .function("sin")]
        let result = try parser.evaluatePostfix(tokens, angleUnit: .degree)
        #expect(abs(result - 1.0) < 0.0001)
    }
    
    @Test("후위 계산 - 상수")
    func testEvaluatePostfixConstant() throws {
        let tokens: [ExpressionParser.Token] = [.constant("π"), .number(2), .operator("/")]
        let result = try parser.evaluatePostfix(tokens, angleUnit: .degree)
        #expect(abs(result - Double.pi/2) < 0.0001)
    }
    
    @Test("후위 계산 - 0으로 나누기 에러")
    func testEvaluatePostfixDivisionByZero() {
        let tokens: [ExpressionParser.Token] = [.number(1), .number(0), .operator("/")]
        #expect(throws: CalculatorError.divisionByZero) {
            try parser.evaluatePostfix(tokens, angleUnit: .degree)
        }
    }
    
    // MARK: - Parentheses Validation Tests
    
    @Test("괄호 검증 - 올바른 괄호")
    func testValidateParenthesesValid() {
        #expect(parser.validateParentheses("(1+2)"))
        #expect(parser.validateParentheses("((1+2)*3)"))
        #expect(parser.validateParentheses("sin(30)"))
        #expect(parser.validateParentheses(""))
        #expect(parser.validateParentheses("1+2"))
    }
    
    @Test("괄호 검증 - 잘못된 괄호")
    func testValidateParenthesesInvalid() {
        #expect(!parser.validateParentheses("(1+2"))
        #expect(!parser.validateParentheses("1+2)"))
        #expect(!parser.validateParentheses("((1+2)"))
        #expect(!parser.validateParentheses("(1+2))"))
        #expect(!parser.validateParentheses(")1+2("))
    }
    
    // MARK: - Integration Tests
    
    @Test("통합 테스트 - 간단한 수식")
    func testFullParsingSimple() throws {
        let expression = "1+2*3"
        let tokens = try parser.tokenize(expression)
        let postfix = try parser.infixToPostfix(tokens)
        let result = try parser.evaluatePostfix(postfix, angleUnit: .degree)
        #expect(result == 7.0)
    }
    
    @Test("통합 테스트 - 괄호가 있는 수식")
    func testFullParsingWithParentheses() throws {
        let expression = "(1+2)*3"
        let tokens = try parser.tokenize(expression)
        let postfix = try parser.infixToPostfix(tokens)
        let result = try parser.evaluatePostfix(postfix, angleUnit: .degree)
        #expect(result == 9.0)
    }
    
    @Test("통합 테스트 - 삼각함수")
    func testFullParsingTrigonometric() throws {
        let expression = "sin(90)"
        let tokens = try parser.tokenize(expression)
        let postfix = try parser.infixToPostfix(tokens)
        let result = try parser.evaluatePostfix(postfix, angleUnit: .degree)
        #expect(abs(result - 1.0) < 0.0001)
    }
    
    @Test("통합 테스트 - 복잡한 수식")
    func testFullParsingComplex() throws {
        let expression = "sin(π/2)+log(10)"
        let tokens = try parser.tokenize(expression)
        let postfix = try parser.infixToPostfix(tokens)
        let result = try parser.evaluatePostfix(postfix, angleUnit: .radian)
        // sin(π/2) = 1, log(10) = log₁₀(10) = 1 (상용로그)
        let expectedResult = 1.0 + 1.0  // 2.0
        #expect(abs(result - expectedResult) < 0.0001)
    }
    
    // MARK: - Performance Tests
    
    @Test("성능 검증 - 간단한 계산 응답 시간")
    func performanceSimpleCalculation() {
        let engine = ScientificCalculatorEngine()
        let expression = "2 + 3 * 4"
        
        // 단일 계산이 1ms 이내에 완료되는지 확인
        let startTime = CFAbsoluteTimeGetCurrent()
        _ = try? engine.calculate(expression)
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        // 1ms 이내 응답 (사용자 체감 지연 없음)
        #expect(timeElapsed < 0.001)
    }
    
    @Test("성능 검증 - 복잡한 계산 응답 시간")
    func performanceComplexCalculation() {
        let engine = ScientificCalculatorEngine()
        let expression = "sin(30) + cos(45) * log(10) + sqrt(25) / (2 + 3)"
        
        // 복잡한 계산도 10ms 이내에 완료되는지 확인
        let startTime = CFAbsoluteTimeGetCurrent()
        _ = try? engine.calculate(expression)
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        // 10ms 이내 응답 (여전히 사용자 체감 지연 없음)
        #expect(timeElapsed < 0.01)
    }
} 