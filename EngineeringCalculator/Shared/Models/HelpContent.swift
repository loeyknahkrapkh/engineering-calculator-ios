import Foundation

/// 함수 설명 데이터 모델
public struct FunctionDescription: Identifiable, Codable, Equatable {
    public let id = UUID()
    public let functionName: String
    public let symbol: String
    public let description: String
    public let usage: String
    public let example: String
    public let category: FunctionCategory
    
    public init(functionName: String, symbol: String, description: String, usage: String, example: String, category: FunctionCategory) {
        self.functionName = functionName
        self.symbol = symbol
        self.description = description
        self.usage = usage
        self.example = example
        self.category = category
    }
    
    /// Equatable 구현 - ID를 제외하고 비교
    public static func == (lhs: FunctionDescription, rhs: FunctionDescription) -> Bool {
        return lhs.functionName == rhs.functionName &&
               lhs.symbol == rhs.symbol &&
               lhs.description == rhs.description &&
               lhs.usage == rhs.usage &&
               lhs.example == rhs.example &&
               lhs.category == rhs.category
    }
}

/// 함수 카테고리
public enum FunctionCategory: String, CaseIterable, Codable {
    case basic = "기본 연산"
    case trigonometric = "삼각함수"
    case logarithmic = "로그함수"
    case exponential = "지수함수"
    case constants = "수학 상수"
    case utility = "유틸리티"
    
    public var displayName: String {
        return self.rawValue
    }
}

/// 계산기 팁 데이터 모델
public struct CalculatorTip: Identifiable, Codable, Equatable, Sendable {
    public let id = UUID()
    public let title: String
    public let content: String
    public let category: TipCategory
    public let difficulty: TipDifficulty
    public let isDaily: Bool
    
    public init(title: String, content: String, category: TipCategory, difficulty: TipDifficulty, isDaily: Bool = false) {
        self.title = title
        self.content = content
        self.category = category
        self.difficulty = difficulty
        self.isDaily = isDaily
    }
}

/// 팁 카테고리
public enum TipCategory: String, CaseIterable, Codable {
    case calculation = "계산 팁"
    case functions = "함수 사용법"
    case shortcuts = "단축키"
    case tricks = "계산 꿀팁"
    
    public var displayName: String {
        return self.rawValue
    }
}

/// 팁 난이도
public enum TipDifficulty: String, CaseIterable, Codable {
    case beginner = "초급"
    case intermediate = "중급"
    case advanced = "고급"
    
    public var displayName: String {
        return self.rawValue
    }
    
    public var sortOrder: Int {
        switch self {
        case .beginner: return 1
        case .intermediate: return 2
        case .advanced: return 3
        }
    }
}

/// 도움말 섹션 데이터 모델
public struct HelpSection: Identifiable, Codable, Equatable {
    public let id = UUID()
    public let title: String
    public let functions: [FunctionDescription]
    
    public init(title: String, functions: [FunctionDescription]) {
        self.title = title
        self.functions = functions
    }
    
    /// Equatable 구현 - ID를 제외하고 비교
    public static func == (lhs: HelpSection, rhs: HelpSection) -> Bool {
        return lhs.title == rhs.title &&
               lhs.functions == rhs.functions
    }
} 