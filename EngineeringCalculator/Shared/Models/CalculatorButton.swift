import Foundation

/// 계산기 버튼 타입
enum CalculatorButton: String, CaseIterable {
    // MARK: - 숫자
    case zero = "0", one = "1", two = "2", three = "3", four = "4"
    case five = "5", six = "6", seven = "7", eight = "8", nine = "9"
    
    // MARK: - 기본 연산자
    case add = "+", subtract = "-", multiply = "×", divide = "÷"
    case equals = "=", decimal = "."
    
    // MARK: - 기능 버튼
    case clear = "C", plusMinus = "±", percent = "%"
    case openParenthesis = "(", closeParenthesis = ")"
    
    // MARK: - 공학 함수 - 삼각함수
    case sin = "sin", cos = "cos", tan = "tan"
    case asin = "asin", acos = "acos", atan = "atan"
    
    // MARK: - 공학 함수 - 로그/지수
    case ln = "ln", log = "log", log2 = "log₂"
    case exp = "eˣ", pow10 = "10ˣ", power = "xʸ"
    case sqrt = "√", cbrt = "∛"
    
    // MARK: - 수학 상수
    case pi = "π", e = "e"
    
    // MARK: - 특수 기능
    case angleUnit = "rad/deg", history = "hist", help = "help"
    case unitConverter = "unit"
    case backspace = "⌫"
    
    /// 화면에 표시될 텍스트
    var displayText: String {
        return self.rawValue
    }
    
    /// 버튼 타입 분류
    var buttonType: ButtonType {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            return .number
        case .add, .subtract, .multiply, .divide, .equals:
            return .operator
        case .sin, .cos, .tan, .asin, .acos, .atan, .ln, .log, .log2, .exp, .pow10, .power, .sqrt, .cbrt:
            return .function
        case .pi, .e:
            return .constant
        case .clear, .plusMinus, .percent, .openParenthesis, .closeParenthesis, .decimal, .backspace:
            return .utility
        case .angleUnit, .history, .help, .unitConverter:
            return .special
        }
    }
    
    /// 계산식에 사용될 문자열
    var calculationString: String {
        switch self {
        case .multiply:
            return "*"
        case .divide:
            return "/"
        case .pi:
            return "π"
        case .e:
            return "e"
        case .sqrt:
            return "sqrt"
        case .cbrt:
            return "cbrt"
        case .exp:
            return "exp"
        case .pow10:
            return "pow10"
        case .power:
            return "^"
        case .log2:
            return "log2"
        default:
            return self.rawValue
        }
    }
}

/// 버튼 타입 분류
enum ButtonType {
    case number      // 숫자 버튼
    case `operator`    // 연산자 버튼
    case function    // 함수 버튼
    case constant    // 상수 버튼
    case utility     // 유틸리티 버튼
    case special     // 특수 기능 버튼
} 
