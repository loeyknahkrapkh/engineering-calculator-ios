import Testing
import Foundation
@testable import EngineeringCalculator

/// HelpContent 모델들에 대한 테스트 모음
@Suite("HelpContent Models Tests")
struct HelpContentTests {
    
    // MARK: - FunctionDescription Tests
    
    @Test("FunctionDescription 초기화 테스트")
    func testFunctionDescriptionInitialization() {
        // Given & When
        let function = FunctionDescription(
            functionName: "사인",
            symbol: "sin",
            description: "사인 함수",
            usage: "sin(x)",
            example: "sin(30°) = 0.5",
            category: .trigonometric
        )
        
        // Then
        #expect(function.functionName == "사인")
        #expect(function.symbol == "sin")
        #expect(function.description == "사인 함수")
        #expect(function.usage == "sin(x)")
        #expect(function.example == "sin(30°) = 0.5")
        #expect(function.category == .trigonometric)
        #expect(function.id != UUID())  // ID는 항상 새로 생성됨
    }
    
    @Test("FunctionDescription Equatable 테스트")
    func testFunctionDescriptionEquatable() {
        // Given
        let function1 = FunctionDescription(
            functionName: "사인",
            symbol: "sin",
            description: "사인 함수",
            usage: "sin(x)",
            example: "sin(30°) = 0.5",
            category: .trigonometric
        )
        
        let function2 = FunctionDescription(
            functionName: "사인",
            symbol: "sin",
            description: "사인 함수",
            usage: "sin(x)",
            example: "sin(30°) = 0.5",
            category: .trigonometric
        )
        
        let function3 = FunctionDescription(
            functionName: "코사인",
            symbol: "cos",
            description: "코사인 함수",
            usage: "cos(x)",
            example: "cos(0°) = 1",
            category: .trigonometric
        )
        
        // Then
        #expect(function1 == function2)  // 내용이 같으면 같은 객체
        #expect(function1 != function3)  // 내용이 다르면 다른 객체
    }
    
    // MARK: - FunctionCategory Tests
    
    @Test("FunctionCategory displayName 테스트")
    func testFunctionCategoryDisplayName() {
        // Given & When & Then
        #expect(FunctionCategory.basic.displayName == "기본 연산")
        #expect(FunctionCategory.trigonometric.displayName == "삼각함수")
        #expect(FunctionCategory.logarithmic.displayName == "로그함수")
        #expect(FunctionCategory.exponential.displayName == "지수함수")
        #expect(FunctionCategory.constants.displayName == "수학 상수")
        #expect(FunctionCategory.utility.displayName == "유틸리티")
    }
    
    @Test("FunctionCategory allCases 테스트")
    func testFunctionCategoryAllCases() {
        // Given & When
        let allCases = FunctionCategory.allCases
        
        // Then
        #expect(allCases.count == 6)
        #expect(allCases.contains(.basic))
        #expect(allCases.contains(.trigonometric))
        #expect(allCases.contains(.logarithmic))
        #expect(allCases.contains(.exponential))
        #expect(allCases.contains(.constants))
        #expect(allCases.contains(.utility))
    }
    
    // MARK: - CalculatorTip Tests
    
    @Test("CalculatorTip 초기화 테스트")
    func testCalculatorTipInitialization() {
        // Given & When
        let tip = CalculatorTip(
            title: "계산 팁",
            content: "팁 내용",
            category: .calculation,
            difficulty: .beginner,
            isDaily: true
        )
        
        // Then
        #expect(tip.title == "계산 팁")
        #expect(tip.content == "팁 내용")
        #expect(tip.category == .calculation)
        #expect(tip.difficulty == .beginner)
        #expect(tip.isDaily == true)
        #expect(tip.id != UUID())  // ID는 항상 새로 생성됨
    }
    
    @Test("CalculatorTip 기본값 테스트")
    func testCalculatorTipDefaultValues() {
        // Given & When
        let tip = CalculatorTip(
            title: "계산 팁",
            content: "팁 내용",
            category: .calculation,
            difficulty: .beginner
        )
        
        // Then
        #expect(tip.isDaily == false)  // 기본값은 false
    }
    
    // MARK: - TipCategory Tests
    
    @Test("TipCategory displayName 테스트")
    func testTipCategoryDisplayName() {
        // Given & When & Then
        #expect(TipCategory.calculation.displayName == "계산 팁")
        #expect(TipCategory.functions.displayName == "함수 사용법")
        #expect(TipCategory.shortcuts.displayName == "단축키")
        #expect(TipCategory.tricks.displayName == "계산 꿀팁")
    }
    
    // MARK: - TipDifficulty Tests
    
    @Test("TipDifficulty displayName 테스트")
    func testTipDifficultyDisplayName() {
        // Given & When & Then
        #expect(TipDifficulty.beginner.displayName == "초급")
        #expect(TipDifficulty.intermediate.displayName == "중급")
        #expect(TipDifficulty.advanced.displayName == "고급")
    }
    
    @Test("TipDifficulty sortOrder 테스트")
    func testTipDifficultySortOrder() {
        // Given & When & Then
        #expect(TipDifficulty.beginner.sortOrder == 1)
        #expect(TipDifficulty.intermediate.sortOrder == 2)
        #expect(TipDifficulty.advanced.sortOrder == 3)
        
        // 정렬 테스트
        let difficulties: [TipDifficulty] = [.advanced, .beginner, .intermediate]
        let sorted = difficulties.sorted { $0.sortOrder < $1.sortOrder }
        
        #expect(sorted == [.beginner, .intermediate, .advanced])
    }
    
    // MARK: - HelpSection Tests
    
    @Test("HelpSection 초기화 테스트")
    func testHelpSectionInitialization() {
        // Given
        let functions = [
            FunctionDescription(
                functionName: "사인",
                symbol: "sin",
                description: "사인 함수",
                usage: "sin(x)",
                example: "sin(30°) = 0.5",
                category: .trigonometric
            ),
            FunctionDescription(
                functionName: "코사인",
                symbol: "cos",
                description: "코사인 함수",
                usage: "cos(x)",
                example: "cos(0°) = 1",
                category: .trigonometric
            )
        ]
        
        // When
        let section = HelpSection(title: "삼각함수", functions: functions)
        
        // Then
        #expect(section.title == "삼각함수")
        #expect(section.functions.count == 2)
        #expect(section.functions[0].functionName == "사인")
        #expect(section.functions[1].functionName == "코사인")
        #expect(section.id != UUID())  // ID는 항상 새로 생성됨
    }
    
    @Test("HelpSection Equatable 테스트")
    func testHelpSectionEquatable() {
        // Given
        let functions = [
            FunctionDescription(
                functionName: "사인",
                symbol: "sin",
                description: "사인 함수",
                usage: "sin(x)",
                example: "sin(30°) = 0.5",
                category: .trigonometric
            )
        ]
        
        let section1 = HelpSection(title: "삼각함수", functions: functions)
        let section2 = HelpSection(title: "삼각함수", functions: functions)
        let section3 = HelpSection(title: "지수함수", functions: functions)
        
        // Then
        #expect(section1 == section2)  // 내용이 같으면 같은 객체
        #expect(section1 != section3)  // 제목이 다르면 다른 객체
    }
    
    // MARK: - Codable Tests
    
    @Test("FunctionDescription Codable 테스트")
    func testFunctionDescriptionCodable() throws {
        // Given
        let originalFunction = FunctionDescription(
            functionName: "사인",
            symbol: "sin",
            description: "사인 함수",
            usage: "sin(x)",
            example: "sin(30°) = 0.5",
            category: .trigonometric
        )
        
        // When - Encoding
        let encoded = try JSONEncoder().encode(originalFunction)
        
        // Then - Decoding
        let decodedFunction = try JSONDecoder().decode(FunctionDescription.self, from: encoded)
        
        #expect(decodedFunction.functionName == originalFunction.functionName)
        #expect(decodedFunction.symbol == originalFunction.symbol)
        #expect(decodedFunction.description == originalFunction.description)
        #expect(decodedFunction.usage == originalFunction.usage)
        #expect(decodedFunction.example == originalFunction.example)
        #expect(decodedFunction.category == originalFunction.category)
    }
    
    @Test("CalculatorTip Codable 테스트")
    func testCalculatorTipCodable() throws {
        // Given
        let originalTip = CalculatorTip(
            title: "계산 팁",
            content: "팁 내용",
            category: .calculation,
            difficulty: .beginner,
            isDaily: true
        )
        
        // When - Encoding
        let encoded = try JSONEncoder().encode(originalTip)
        
        // Then - Decoding
        let decodedTip = try JSONDecoder().decode(CalculatorTip.self, from: encoded)
        
        #expect(decodedTip.title == originalTip.title)
        #expect(decodedTip.content == originalTip.content)
        #expect(decodedTip.category == originalTip.category)
        #expect(decodedTip.difficulty == originalTip.difficulty)
        #expect(decodedTip.isDaily == originalTip.isDaily)
    }
} 