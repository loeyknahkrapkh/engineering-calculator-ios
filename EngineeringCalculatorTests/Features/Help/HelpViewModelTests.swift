import Testing
import Foundation
@testable import EngineeringCalculator

/// HelpViewModel에 대한 테스트 모음
@Suite("HelpViewModel Tests")
struct HelpViewModelTests {
    
    // MARK: - Test Dependencies
    
    /// Mock HelpContentProvider for testing
    class MockHelpContentProvider: HelpContentProvider {
        var shouldThrowError = false
        private var functions: [FunctionDescription] = []
        private var tips: [CalculatorTip] = []
        
        func loadFunctionDescriptions() throws -> [FunctionDescription] {
            if shouldThrowError {
                throw NSError(domain: "TestError", code: 1, userInfo: nil)
            }
            return functions
        }
        
        func loadCalculatorTips() throws -> [CalculatorTip] {
            if shouldThrowError {
                throw NSError(domain: "TestError", code: 1, userInfo: nil)
            }
            return tips
        }
        
        func searchFunctions(query: String) -> [FunctionDescription] {
            return functions.filter { function in
                function.functionName.localizedCaseInsensitiveContains(query) ||
                function.symbol.localizedCaseInsensitiveContains(query) ||
                function.description.localizedCaseInsensitiveContains(query)
            }
        }
        
        func getTipsForCategory(_ category: TipCategory) -> [CalculatorTip] {
            return tips.filter { $0.category == category }
        }
        
        func getDailyTip() -> CalculatorTip? {
            return tips.first { $0.isDaily }
        }
        
        func clearCache() {
            // Mock implementation - no-op for testing
        }
        
        // Helper methods for testing
        func setTestFunctions(_ functions: [FunctionDescription]) {
            self.functions = functions
        }
        
        func setTestTips(_ tips: [CalculatorTip]) {
            self.tips = tips
        }
    }
    
    // MARK: - Helper Methods
    
    @MainActor
    func createTestViewModel() -> (HelpViewModel, MockHelpContentProvider) {
        let mockProvider = MockHelpContentProvider()
        let viewModel = HelpViewModel(contentProvider: mockProvider)
        return (viewModel, mockProvider)
    }
    
    // MARK: - Initialization Tests
    
    @Test("HelpViewModel 초기화 테스트")
    @MainActor
    func testHelpViewModelInitialization() async throws {
        // Given & When
        let (viewModel, _) = createTestViewModel()
        
        // Then
        #expect(viewModel.functionSections.isEmpty)
        #expect(viewModel.allTips.isEmpty)
        #expect(viewModel.filteredFunctions.isEmpty)
        #expect(viewModel.searchQuery.isEmpty)
        #expect(viewModel.selectedCategory == nil)
        #expect(!viewModel.isLoading)
        #expect(!viewModel.hasError)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.dailyTip == nil)
    }
    
    // MARK: - Function Loading Tests
    
    @Test("함수 설명 로드 기능 테스트")
    @MainActor
    func testLoadFunctionDescriptions() async throws {
        // Given
        let (viewModel, mockProvider) = createTestViewModel()
        let testFunctions = [
            FunctionDescription(functionName: "사인", symbol: "sin", description: "사인 함수", usage: "sin(x)", example: "sin(30°) = 0.5", category: .trigonometric),
            FunctionDescription(functionName: "로그", symbol: "log", description: "상용로그", usage: "log(x)", example: "log(100) = 2", category: .logarithmic)
        ]
        mockProvider.setTestFunctions(testFunctions)
        
        // When
        await viewModel.loadContent()
        
        // Then
        #expect(!viewModel.functionSections.isEmpty)
        #expect(viewModel.filteredFunctions.count == 2)
        #expect(!viewModel.hasError)
    }
    
    @Test("함수 로드 에러 처리 테스트")
    @MainActor
    func testLoadFunctionDescriptionsError() async throws {
        // Given
        let (viewModel, mockProvider) = createTestViewModel()
        mockProvider.shouldThrowError = true
        
        // When
        await viewModel.loadContent()
        
        // Then
        #expect(viewModel.hasError)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.functionSections.isEmpty)
    }
    
    // MARK: - Tips Loading Tests
    
    @Test("팁 로드 기능 테스트")
    @MainActor
    func testLoadCalculatorTips() async throws {
        // Given
        let (viewModel, mockProvider) = createTestViewModel()
        let testTips = [
            CalculatorTip(title: "계산 팁 1", content: "팁 내용 1", category: .calculation, difficulty: .beginner),
            CalculatorTip(title: "함수 팁 1", content: "팁 내용 2", category: .functions, difficulty: .intermediate, isDaily: true)
        ]
        mockProvider.setTestTips(testTips)
        
        // When
        await viewModel.loadContent()
        
        // Then
        #expect(viewModel.allTips.count == 2)
        #expect(viewModel.dailyTip?.title == "함수 팁 1")
        #expect(!viewModel.hasError)
    }
    
    // MARK: - Search Functionality Tests
    
    @Test("함수 검색 기능 테스트")
    @MainActor
    func testSearchFunctions() async throws {
        // Given
        let (viewModel, mockProvider) = createTestViewModel()
        let testFunctions = [
            FunctionDescription(functionName: "사인", symbol: "sin", description: "사인 함수", usage: "sin(x)", example: "sin(30°) = 0.5", category: .trigonometric),
            FunctionDescription(functionName: "코사인", symbol: "cos", description: "코사인 함수", usage: "cos(x)", example: "cos(0°) = 1", category: .trigonometric),
            FunctionDescription(functionName: "로그", symbol: "log", description: "상용로그", usage: "log(x)", example: "log(100) = 2", category: .logarithmic)
        ]
        mockProvider.setTestFunctions(testFunctions)
        await viewModel.loadContent()
        
        // When
        viewModel.searchFunctions("sin")
        
        // Then
        #expect(viewModel.filteredFunctions.count == 1)
        #expect(viewModel.filteredFunctions.first?.functionName == "사인")
    }
    
    @Test("검색어 초기화 테스트")
    @MainActor
    func testClearSearch() async throws {
        // Given
        let (viewModel, mockProvider) = createTestViewModel()
        let testFunctions = [
            FunctionDescription(functionName: "사인", symbol: "sin", description: "사인 함수", usage: "sin(x)", example: "sin(30°) = 0.5", category: .trigonometric)
        ]
        mockProvider.setTestFunctions(testFunctions)
        await viewModel.loadContent()
        viewModel.searchQuery = "test"
        
        // When
        viewModel.clearSearch()
        
        // Then
        #expect(viewModel.searchQuery.isEmpty)
        #expect(viewModel.filteredFunctions.count == 1)
    }
    
    // MARK: - Category Filtering Tests
    
    @Test("카테고리별 필터링 테스트")
    @MainActor
    func testCategoryFiltering() async throws {
        // Given
        let (viewModel, mockProvider) = createTestViewModel()
        let testFunctions = [
            FunctionDescription(functionName: "사인", symbol: "sin", description: "사인 함수", usage: "sin(x)", example: "sin(30°) = 0.5", category: .trigonometric),
            FunctionDescription(functionName: "로그", symbol: "log", description: "상용로그", usage: "log(x)", example: "log(100) = 2", category: .logarithmic)
        ]
        mockProvider.setTestFunctions(testFunctions)
        await viewModel.loadContent()
        
        // When
        viewModel.selectCategory(.trigonometric)
        
        // Then
        #expect(viewModel.filteredFunctions.count == 1)
        #expect(viewModel.filteredFunctions.first?.category == .trigonometric)
    }
    
    @Test("카테고리 선택 해제 테스트")
    @MainActor
    func testClearCategorySelection() async throws {
        // Given
        let (viewModel, mockProvider) = createTestViewModel()
        let testFunctions = [
            FunctionDescription(functionName: "사인", symbol: "sin", description: "사인 함수", usage: "sin(x)", example: "sin(30°) = 0.5", category: .trigonometric),
            FunctionDescription(functionName: "로그", symbol: "log", description: "상용로그", usage: "log(x)", example: "log(100) = 2", category: .logarithmic)
        ]
        mockProvider.setTestFunctions(testFunctions)
        await viewModel.loadContent()
        viewModel.selectedCategory = .trigonometric
        
        // When
        viewModel.clearCategorySelection()
        
        // Then
        #expect(viewModel.selectedCategory == nil)
        #expect(viewModel.filteredFunctions.count == 2)
    }
    
    // MARK: - Tips Management Tests
    
    @Test("카테고리별 팁 가져오기 테스트")
    @MainActor
    func testGetTipsForCategory() async throws {
        // Given
        let (viewModel, mockProvider) = createTestViewModel()
        let testTips = [
            CalculatorTip(title: "계산 팁 1", content: "팁 내용 1", category: .calculation, difficulty: .beginner),
            CalculatorTip(title: "계산 팁 2", content: "팁 내용 2", category: .calculation, difficulty: .intermediate),
            CalculatorTip(title: "함수 팁 1", content: "팁 내용 3", category: .functions, difficulty: .beginner)
        ]
        mockProvider.setTestTips(testTips)
        await viewModel.loadContent()
        
        // When
        let calculationTips = viewModel.getTipsForCategory(.calculation)
        
        // Then
        #expect(calculationTips.count == 2)
        #expect(calculationTips.allSatisfy { $0.category == .calculation })
    }
    
    // MARK: - Content Refresh Tests
    
    @Test("컨텐츠 새로고침 테스트")
    @MainActor
    func testRefreshContent() async throws {
        // Given
        let (viewModel, mockProvider) = createTestViewModel()
        let initialFunctions = [
            FunctionDescription(functionName: "사인", symbol: "sin", description: "사인 함수", usage: "sin(x)", example: "sin(30°) = 0.5", category: .trigonometric)
        ]
        mockProvider.setTestFunctions(initialFunctions)
        await viewModel.loadContent()
        
        // When - 새로운 데이터로 변경
        let newFunctions = [
            FunctionDescription(functionName: "사인", symbol: "sin", description: "사인 함수", usage: "sin(x)", example: "sin(30°) = 0.5", category: .trigonometric),
            FunctionDescription(functionName: "코사인", symbol: "cos", description: "코사인 함수", usage: "cos(x)", example: "cos(0°) = 1", category: .trigonometric)
        ]
        mockProvider.setTestFunctions(newFunctions)
        await viewModel.refreshContent()
        
        // Then
        #expect(viewModel.filteredFunctions.count == 2)
        #expect(!viewModel.hasError)
    }
    
    // MARK: - Error Handling Tests
    
    @Test("에러 메시지 초기화 테스트")
    @MainActor
    func testClearError() async throws {
        // Given
        let (viewModel, mockProvider) = createTestViewModel()
        mockProvider.shouldThrowError = true
        await viewModel.loadContent()
        #expect(viewModel.hasError)
        
        // When
        viewModel.clearError()
        
        // Then
        #expect(!viewModel.hasError)
        #expect(viewModel.errorMessage == nil)
    }
    
    // MARK: - Computed Properties Tests
    
    @Test("hasContent 계산 속성 테스트")
    @MainActor
    func testHasContentProperty() async throws {
        // Given
        let (viewModel, mockProvider) = createTestViewModel()
        
        // When - 처음에는 컨텐츠가 없음
        #expect(!viewModel.hasContent)
        
        // 함수 데이터 추가
        let testFunctions = [
            FunctionDescription(functionName: "사인", symbol: "sin", description: "사인 함수", usage: "sin(x)", example: "sin(30°) = 0.5", category: .trigonometric)
        ]
        mockProvider.setTestFunctions(testFunctions)
        await viewModel.loadContent()
        
        // Then
        #expect(viewModel.hasContent)
    }
    
    @Test("isEmpty 계산 속성 테스트")
    @MainActor
    func testIsEmptyProperty() async throws {
        // Given
        let (viewModel, mockProvider) = createTestViewModel()
        
        // When - 처음에는 비어있음
        #expect(viewModel.isEmpty)
        
        // 데이터 추가
        let testFunctions = [
            FunctionDescription(functionName: "사인", symbol: "sin", description: "사인 함수", usage: "sin(x)", example: "sin(30°) = 0.5", category: .trigonometric)
        ]
        mockProvider.setTestFunctions(testFunctions)
        await viewModel.loadContent()
        
        // Then
        #expect(!viewModel.isEmpty)
    }
} 