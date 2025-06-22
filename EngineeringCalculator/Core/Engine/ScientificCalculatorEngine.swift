import Foundation

/// 공학용 계산기 엔진의 구체적인 구현
/// CalculatorEngine 프로토콜을 구현하여 실제 계산 기능을 제공
class ScientificCalculatorEngine: CalculatorEngine {
    
    // MARK: - Properties
    
    /// 현재 각도 단위 설정
    var angleUnit: AngleUnit = .degree
    
    /// 수식 파서 인스턴스
    private let parser = ExpressionParser()
    
    /// 결과 포맷터
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 4
        formatter.minimumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        return formatter
    }()
    
    // MARK: - Initializer
    
    /// 초기화
    /// - Parameter angleUnit: 초기 각도 단위 (기본값: degree)
    init(angleUnit: AngleUnit = .degree) {
        self.angleUnit = angleUnit
    }
    
    // MARK: - CalculatorEngine Protocol Implementation
    
    /// 수식을 계산하고 결과를 반환
    /// - Parameter expression: 계산할 수식 문자열
    /// - Returns: 계산 결과
    /// - Throws: CalculatorError
    func calculate(_ expression: String) throws -> Double {
        // 빈 문자열 체크
        guard !expression.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw CalculatorError.invalidExpression
        }
        
        // 수식 전처리 (공백 제거, 소문자 변환 등)
        let preprocessedExpression = preprocessExpression(expression)
        
        // 괄호 균형 검증
        guard parser.validateParentheses(preprocessedExpression) else {
            throw CalculatorError.invalidParentheses
        }
        
        // 토큰화
        let tokens = try parser.tokenize(preprocessedExpression)
        
        // 중위 표기법을 후위 표기법으로 변환
        let postfixTokens = try parser.infixToPostfix(tokens)
        
        // 후위 표기법 계산
        let result = try parser.evaluatePostfix(postfixTokens, angleUnit: angleUnit)
        
        // 결과 유효성 검증
        try validateResult(result)
        
        return result
    }
    
    /// 수식의 유효성을 검증
    /// - Parameter expression: 검증할 수식 문자열
    /// - Returns: 유효성 여부
    func validateExpression(_ expression: String) -> Bool {
        // 빈 문자열이나 공백만 있는 경우
        let trimmed = expression.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            return false
        }
        
        // 기본적인 유효성 검증
        do {
            // 괄호 균형 검증
            guard parser.validateParentheses(trimmed) else {
                return false
            }
            
            // 토큰화 시도
            let tokens = try parser.tokenize(preprocessExpression(trimmed))
            
            // 토큰이 비어있으면 유효하지 않음
            if tokens.isEmpty {
                return false
            }
            
            // 중위 표기법을 후위 표기법으로 변환 시도
            _ = try parser.infixToPostfix(tokens)
            
            return true
        } catch {
            return false
        }
    }
    
    /// 결과를 포맷팅하여 문자열로 반환
    /// - Parameter result: 포맷팅할 숫자
    /// - Returns: 포맷팅된 문자열
    func formatResult(_ result: Double) -> String {
        // 특수 값 처리
        if result.isNaN {
            return "오류"
        }
        
        if result.isInfinite {
            return result > 0 ? "∞" : "-∞"
        }
        
        // 매우 큰 수나 작은 수는 과학적 표기법 사용
        let absResult = abs(result)
        if absResult >= 1e10 || (absResult > 0 && absResult < 1e-4) {
            return formatScientificNotation(result)
        }
        
        // 일반 숫자 포맷팅
        return numberFormatter.string(from: NSNumber(value: result)) ?? "오류"
    }
    
    // MARK: - Private Helper Methods
    
    /// 수식 전처리
    /// - Parameter expression: 원본 수식
    /// - Returns: 전처리된 수식
    private func preprocessExpression(_ expression: String) -> String {
        var processed = expression
        
        // 공백 제거
        processed = processed.replacingOccurrences(of: " ", with: "")
        
        // 일반적인 수학 기호 변환
        processed = processed.replacingOccurrences(of: "×", with: "*")
        processed = processed.replacingOccurrences(of: "÷", with: "/")
        processed = processed.replacingOccurrences(of: "−", with: "-")
        
        // 암시적 곱셈 처리 (예: 2π → 2*π, 3sin(x) → 3*sin(x))
        processed = addImplicitMultiplication(processed)
        
        return processed
    }
    
    /// 암시적 곱셈 추가
    /// - Parameter expression: 수식
    /// - Returns: 암시적 곱셈이 추가된 수식
    private func addImplicitMultiplication(_ expression: String) -> String {
        // TODO: 구현 예정
        // 예: "2π" → "2*π", "3sin(x)" → "3*sin(x)"
        return expression
    }
    
    /// 결과 유효성 검증
    /// - Parameter result: 검증할 결과
    /// - Throws: CalculatorError
    private func validateResult(_ result: Double) throws {
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
    
    /// 과학적 표기법으로 포맷팅
    /// - Parameter value: 포맷팅할 값
    /// - Returns: 과학적 표기법 문자열
    private func formatScientificNotation(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        
        return formatter.string(from: NSNumber(value: value)) ?? "오류"
    }
}

// MARK: - Extensions

extension ScientificCalculatorEngine {
    
    /// 계산 엔진의 현재 상태를 문자열로 반환 (디버깅용)
    var debugDescription: String {
        return """
        ScientificCalculatorEngine:
        - Angle Unit: \(angleUnit)
        - Number Formatter Max Fraction Digits: \(numberFormatter.maximumFractionDigits)
        """
    }
} 