import Foundation

/// 도움말 컨텐츠 제공자 프로토콜
public protocol HelpContentProvider {
    /// 함수 설명 목록을 로드합니다
    func loadFunctionDescriptions() throws -> [FunctionDescription]
    
    /// 계산기 팁 목록을 로드합니다
    func loadCalculatorTips() throws -> [CalculatorTip]
    
    /// 함수를 검색합니다
    func searchFunctions(query: String) -> [FunctionDescription]
    
    /// 특정 카테고리의 팁을 가져옵니다
    func getTipsForCategory(_ category: TipCategory) -> [CalculatorTip]
    
    /// 오늘의 팁을 가져옵니다
    func getDailyTip() -> CalculatorTip?
}

/// 기본 도움말 컨텐츠 제공자
public class DefaultHelpContentProvider: HelpContentProvider {
    
    private var cachedFunctions: [FunctionDescription]?
    private var cachedTips: [CalculatorTip]?
    
    public init() {}
    
    public func loadFunctionDescriptions() throws -> [FunctionDescription] {
        if let cached = cachedFunctions {
            return cached
        }
        
        let functions = createDefaultFunctionDescriptions()
        cachedFunctions = functions
        return functions
    }
    
    public func loadCalculatorTips() throws -> [CalculatorTip] {
        if let cached = cachedTips {
            return cached
        }
        
        let tips = createDefaultTips()
        cachedTips = tips
        return tips
    }
    
    public func searchFunctions(query: String) -> [FunctionDescription] {
        guard let functions = cachedFunctions, !query.isEmpty else {
            return cachedFunctions ?? []
        }
        
        return functions.filter { function in
            function.functionName.localizedCaseInsensitiveContains(query) ||
            function.symbol.localizedCaseInsensitiveContains(query) ||
            function.description.localizedCaseInsensitiveContains(query)
        }
    }
    
    public func getTipsForCategory(_ category: TipCategory) -> [CalculatorTip] {
        guard let tips = cachedTips else { return [] }
        return tips.filter { $0.category == category }
    }
    
    public func getDailyTip() -> CalculatorTip? {
        guard let tips = cachedTips else { return nil }
        return tips.first { $0.isDaily }
    }
    
    // MARK: - Private Methods
    
    private func createDefaultFunctionDescriptions() -> [FunctionDescription] {
        return [
            // 기본 연산
            FunctionDescription(
                functionName: "덧셈",
                symbol: "+",
                description: "두 수를 더합니다",
                usage: "a + b",
                example: "5 + 3 = 8",
                category: .basic
            ),
            FunctionDescription(
                functionName: "뺄셈",
                symbol: "-",
                description: "첫 번째 수에서 두 번째 수를 뺍니다",
                usage: "a - b",
                example: "8 - 3 = 5",
                category: .basic
            ),
            FunctionDescription(
                functionName: "곱셈",
                symbol: "×",
                description: "두 수를 곱합니다",
                usage: "a × b",
                example: "4 × 3 = 12",
                category: .basic
            ),
            FunctionDescription(
                functionName: "나눗셈",
                symbol: "÷",
                description: "첫 번째 수를 두 번째 수로 나눕니다",
                usage: "a ÷ b",
                example: "12 ÷ 3 = 4",
                category: .basic
            ),
            
            // 삼각함수
            FunctionDescription(
                functionName: "사인",
                symbol: "sin",
                description: "각도의 사인 값을 계산합니다",
                usage: "sin(각도)",
                example: "sin(30°) = 0.5",
                category: .trigonometric
            ),
            FunctionDescription(
                functionName: "코사인",
                symbol: "cos",
                description: "각도의 코사인 값을 계산합니다",
                usage: "cos(각도)",
                example: "cos(60°) = 0.5",
                category: .trigonometric
            ),
            FunctionDescription(
                functionName: "탄젠트",
                symbol: "tan",
                description: "각도의 탄젠트 값을 계산합니다",
                usage: "tan(각도)",
                example: "tan(45°) = 1",
                category: .trigonometric
            ),
            FunctionDescription(
                functionName: "아크사인",
                symbol: "asin",
                description: "사인의 역함수로 각도를 구합니다",
                usage: "asin(값)",
                example: "asin(0.5) = 30°",
                category: .trigonometric
            ),
            FunctionDescription(
                functionName: "아크코사인",
                symbol: "acos",
                description: "코사인의 역함수로 각도를 구합니다",
                usage: "acos(값)",
                example: "acos(0.5) = 60°",
                category: .trigonometric
            ),
            FunctionDescription(
                functionName: "아크탄젠트",
                symbol: "atan",
                description: "탄젠트의 역함수로 각도를 구합니다",
                usage: "atan(값)",
                example: "atan(1) = 45°",
                category: .trigonometric
            ),
            
            // 로그함수
            FunctionDescription(
                functionName: "자연로그",
                symbol: "ln",
                description: "자연상수 e를 밑으로 하는 로그를 계산합니다",
                usage: "ln(값)",
                example: "ln(e) = 1",
                category: .logarithmic
            ),
            FunctionDescription(
                functionName: "상용로그",
                symbol: "log",
                description: "10을 밑으로 하는 로그를 계산합니다",
                usage: "log(값)",
                example: "log(100) = 2",
                category: .logarithmic
            ),
            FunctionDescription(
                functionName: "이진로그",
                symbol: "log₂",
                description: "2를 밑으로 하는 로그를 계산합니다",
                usage: "log₂(값)",
                example: "log₂(8) = 3",
                category: .logarithmic
            ),
            
            // 지수함수
            FunctionDescription(
                functionName: "자연지수",
                symbol: "eˣ",
                description: "자연상수 e의 거듭제곱을 계산합니다",
                usage: "eˣ",
                example: "e¹ = 2.718...",
                category: .exponential
            ),
            FunctionDescription(
                functionName: "십의 거듭제곱",
                symbol: "10ˣ",
                description: "10의 거듭제곱을 계산합니다",
                usage: "10ˣ",
                example: "10² = 100",
                category: .exponential
            ),
            FunctionDescription(
                functionName: "거듭제곱",
                symbol: "xʸ",
                description: "x의 y제곱을 계산합니다",
                usage: "xʸ",
                example: "2³ = 8",
                category: .exponential
            ),
            FunctionDescription(
                functionName: "제곱근",
                symbol: "√",
                description: "수의 제곱근을 계산합니다",
                usage: "√x",
                example: "√9 = 3",
                category: .exponential
            ),
            
            // 수학 상수
            FunctionDescription(
                functionName: "원주율",
                symbol: "π",
                description: "원주율 파이 (3.14159...)",
                usage: "π",
                example: "π ≈ 3.14159",
                category: .constants
            ),
            FunctionDescription(
                functionName: "자연상수",
                symbol: "e",
                description: "자연상수 오일러 수 (2.71828...)",
                usage: "e",
                example: "e ≈ 2.71828",
                category: .constants
            ),
            
            // 유틸리티
            FunctionDescription(
                functionName: "절댓값",
                symbol: "abs",
                description: "수의 절댓값을 계산합니다",
                usage: "abs(값)",
                example: "abs(-5) = 5",
                category: .utility
            ),
            FunctionDescription(
                functionName: "팩토리얼",
                symbol: "!",
                description: "양의 정수의 팩토리얼을 계산합니다",
                usage: "n!",
                example: "5! = 120",
                category: .utility
            )
        ]
    }
    
    private func createDefaultTips() -> [CalculatorTip] {
        return [
            // 계산 팁
            CalculatorTip(
                title: "연산 순서",
                content: "계산기는 수학의 연산 순서를 따릅니다: 괄호 → 지수 → 곱셈/나눗셈 → 덧셈/뺄셈",
                category: .calculation,
                difficulty: .beginner,
                isDaily: true
            ),
            CalculatorTip(
                title: "소수점 정확도",
                content: "계산 결과는 설정에서 지정한 소수점 자릿수까지 표시됩니다. 정확한 계산을 위해 충분한 자릿수를 설정하세요.",
                category: .calculation,
                difficulty: .intermediate
            ),
            CalculatorTip(
                title: "큰 수 계산",
                content: "매우 큰 수나 작은 수는 과학적 표기법(1.23e+10)으로 표시됩니다.",
                category: .calculation,
                difficulty: .intermediate
            ),
            
            // 함수 사용법
            CalculatorTip(
                title: "각도 단위 설정",
                content: "삼각함수를 사용하기 전에 각도 단위(도/라디안)를 확인하세요. 설정에서 변경할 수 있습니다.",
                category: .functions,
                difficulty: .beginner
            ),
            CalculatorTip(
                title: "역삼각함수의 범위",
                content: "asin과 acos는 -1과 1 사이의 값만 입력할 수 있습니다. 범위를 벗어나면 오류가 발생합니다.",
                category: .functions,
                difficulty: .intermediate
            ),
            CalculatorTip(
                title: "로그 함수 주의사항",
                content: "로그 함수는 양수만 입력할 수 있습니다. 0이나 음수를 입력하면 오류가 발생합니다.",
                category: .functions,
                difficulty: .intermediate
            ),
            
            // 단축키
            CalculatorTip(
                title: "빠른 지우기",
                content: "C 버튼을 누르면 현재 입력을 모두 지웁니다. 마지막 숫자만 지우려면 ⌫ 버튼을 사용하세요.",
                category: .shortcuts,
                difficulty: .beginner
            ),
            CalculatorTip(
                title: "부호 변경",
                content: "± 버튼을 누르면 현재 숫자의 부호를 빠르게 변경할 수 있습니다.",
                category: .shortcuts,
                difficulty: .beginner
            ),
            
            // 계산 꿀팁
            CalculatorTip(
                title: "연속 계산",
                content: "= 버튼을 누른 후에도 연산자를 입력하면 결과값으로 계속 계산할 수 있습니다.",
                category: .tricks,
                difficulty: .intermediate
            ),
            CalculatorTip(
                title: "괄호 활용",
                content: "복잡한 수식에서는 괄호를 적극 활용하여 연산 순서를 명확히 하세요.",
                category: .tricks,
                difficulty: .advanced
            ),
            CalculatorTip(
                title: "상수 활용",
                content: "π와 e 버튼을 사용하면 정확한 상수값으로 계산할 수 있습니다.",
                category: .tricks,
                difficulty: .intermediate
            )
        ]
    }
} 