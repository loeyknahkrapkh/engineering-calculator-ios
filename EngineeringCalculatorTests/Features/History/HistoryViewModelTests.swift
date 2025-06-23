import Testing
import Foundation
@testable import EngineeringCalculator

/// HistoryViewModel에 대한 테스트 모음
@Suite("HistoryViewModel Tests")
struct HistoryViewModelTests {
    
    // MARK: - Test Dependencies
    
    /// Mock HistoryStorage for testing
    class MockHistoryStorage: HistoryStorage {
        private var historyItems: [CalculationHistory] = []
        var shouldThrowError = false
        
        func saveHistory(_ history: CalculationHistory) throws {
            if shouldThrowError {
                throw NSError(domain: "TestError", code: 1, userInfo: nil)
            }
            historyItems.insert(history, at: 0)
        }
        
        func loadRecentHistory(limit: Int) throws -> [CalculationHistory] {
            if shouldThrowError {
                throw NSError(domain: "TestError", code: 1, userInfo: nil)
            }
            return Array(historyItems.prefix(limit))
        }
        
        func loadAllHistory() throws -> [CalculationHistory] {
            if shouldThrowError {
                throw NSError(domain: "TestError", code: 1, userInfo: nil)
            }
            return historyItems
        }
        
        func deleteHistory(_ history: CalculationHistory) throws {
            if shouldThrowError {
                throw NSError(domain: "TestError", code: 1, userInfo: nil)
            }
            historyItems.removeAll { $0.id == history.id }
        }
        
        func clearAllHistory() throws {
            if shouldThrowError {
                throw NSError(domain: "TestError", code: 1, userInfo: nil)
            }
            historyItems.removeAll()
        }
        
        // Test helper methods
        func addTestHistory(_ history: CalculationHistory) {
            historyItems.insert(history, at: 0)
        }
        
        func getHistoryCount() -> Int {
            return historyItems.count
        }
    }
    
    // MARK: - Helper Methods
    
    @MainActor
    func createTestViewModel() -> (HistoryViewModel, MockHistoryStorage) {
        let mockStorage = MockHistoryStorage()
        let viewModel = HistoryViewModel(historyStorage: mockStorage)
        return (viewModel, mockStorage)
    }
    
    func createTestHistory() -> CalculationHistory {
        return CalculationHistory(
            expression: "2 + 3",
            result: 5.0,
            angleUnit: .degree
        )
    }
    
    // MARK: - Initialization Tests
    
    @Test("HistoryViewModel 초기화 테스트")
    @MainActor
    func testInitialization() {
        let (viewModel, _) = createTestViewModel()
        
        #expect(viewModel.historyItems.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
        #expect(!viewModel.hasError)
    }
    
    // MARK: - History Loading Tests
    
    @Test("히스토리 로드 기능 테스트")
    @MainActor
    func testLoadHistory() async {
        let (viewModel, mockStorage) = createTestViewModel()
        
        // Given: 테스트 히스토리 데이터 추가
        let testHistory1 = CalculationHistory(expression: "2 + 3", result: 5.0)
        let testHistory2 = CalculationHistory(expression: "10 × 5", result: 50.0)
        mockStorage.addTestHistory(testHistory1)
        mockStorage.addTestHistory(testHistory2)
        
        // When: 히스토리 로드
        await viewModel.loadHistory()
        
        // Then: 히스토리가 올바르게 로드됨
        #expect(viewModel.historyItems.count == 2)
        #expect(viewModel.historyItems[0].expression == "10 × 5")
        #expect(viewModel.historyItems[1].expression == "2 + 3")
        #expect(!viewModel.isLoading)
        #expect(!viewModel.hasError)
    }
    
    @Test("빈 히스토리 로드 테스트")
    @MainActor
    func testLoadEmptyHistory() async {
        let (viewModel, _) = createTestViewModel()
        
        // When: 빈 히스토리 로드
        await viewModel.loadHistory()
        
        // Then: 빈 상태가 올바르게 처리됨
        #expect(viewModel.historyItems.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(!viewModel.hasError)
    }
    
    @Test("히스토리 로드 에러 처리 테스트")
    @MainActor
    func testLoadHistoryError() async {
        let (viewModel, mockStorage) = createTestViewModel()
        
        // Given: 에러 발생하도록 설정
        mockStorage.shouldThrowError = true
        
        // When: 히스토리 로드 시도
        await viewModel.loadHistory()
        
        // Then: 에러가 올바르게 처리됨
        #expect(viewModel.historyItems.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(viewModel.hasError)
        #expect(viewModel.errorMessage != nil)
    }
    
    // MARK: - History Deletion Tests
    
    @Test("특정 히스토리 삭제 테스트")
    @MainActor
    func testDeleteSpecificHistory() async {
        let (viewModel, mockStorage) = createTestViewModel()
        
        // Given: 테스트 히스토리 추가
        let testHistory1 = CalculationHistory(expression: "2 + 3", result: 5.0)
        let testHistory2 = CalculationHistory(expression: "10 × 5", result: 50.0)
        mockStorage.addTestHistory(testHistory1)
        mockStorage.addTestHistory(testHistory2)
        await viewModel.loadHistory()
        
        // When: 특정 히스토리 삭제
        await viewModel.deleteHistory(testHistory1)
        
        // Then: 해당 히스토리만 삭제됨
        #expect(viewModel.historyItems.count == 1)
        #expect(viewModel.historyItems[0].expression == "10 × 5")
        #expect(!viewModel.hasError)
    }
    
    @Test("전체 히스토리 삭제 테스트")
    @MainActor
    func testClearAllHistory() async {
        let (viewModel, mockStorage) = createTestViewModel()
        
        // Given: 테스트 히스토리 추가
        let testHistory1 = CalculationHistory(expression: "2 + 3", result: 5.0)
        let testHistory2 = CalculationHistory(expression: "10 × 5", result: 50.0)
        mockStorage.addTestHistory(testHistory1)
        mockStorage.addTestHistory(testHistory2)
        await viewModel.loadHistory()
        
        // When: 전체 히스토리 삭제
        await viewModel.clearAllHistory()
        
        // Then: 모든 히스토리가 삭제됨
        #expect(viewModel.historyItems.isEmpty)
        #expect(!viewModel.hasError)
    }
    
    @Test("히스토리 삭제 에러 처리 테스트")
    @MainActor
    func testDeleteHistoryError() async {
        let (viewModel, mockStorage) = createTestViewModel()
        
        // Given: 테스트 히스토리 추가 후 에러 설정
        let testHistory = CalculationHistory(expression: "2 + 3", result: 5.0)
        mockStorage.addTestHistory(testHistory)
        await viewModel.loadHistory()
        
        mockStorage.shouldThrowError = true
        
        // When: 히스토리 삭제 시도
        await viewModel.deleteHistory(testHistory)
        
        // Then: 에러가 올바르게 처리됨
        #expect(viewModel.hasError)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.historyItems.count == 1) // 삭제되지 않음
    }
    
    // MARK: - History Selection Tests
    
    @Test("히스토리 항목 선택 테스트")
    @MainActor
    func testSelectHistory() {
        let (viewModel, _) = createTestViewModel()
        
        // Given: 테스트 히스토리
        let testHistory = CalculationHistory(expression: "2 + 3", result: 5.0)
        
        // When: 히스토리 선택
        viewModel.selectHistory(testHistory)
        
        // Then: 선택된 히스토리가 설정됨
        #expect(viewModel.selectedHistory?.id == testHistory.id)
        #expect(viewModel.selectedExpression == "2 + 3")
    }
    
    @Test("히스토리 선택 해제 테스트")
    @MainActor
    func testDeselectHistory() {
        let (viewModel, _) = createTestViewModel()
        
        // Given: 히스토리가 선택된 상태
        let testHistory = CalculationHistory(expression: "2 + 3", result: 5.0)
        viewModel.selectHistory(testHistory)
        
        // When: 선택 해제
        viewModel.deselectHistory()
        
        // Then: 선택이 해제됨
        #expect(viewModel.selectedHistory == nil)
        #expect(viewModel.selectedExpression == nil)
    }
    
    // MARK: - Loading State Tests
    
    @Test("로딩 상태 테스트")
    @MainActor
    func testLoadingState() async {
        let (viewModel, _) = createTestViewModel()
        
        // 초기 상태는 로딩 중이 아님
        #expect(!viewModel.isLoading)
        
        // 로딩 시작 시 상태 변경은 비동기로 처리되므로 
        // 실제 구현에서 확인 가능
    }
    
    // MARK: - Error Handling Tests
    
    @Test("에러 메시지 초기화 테스트")
    @MainActor
    func testClearError() {
        let (viewModel, _) = createTestViewModel()
        
        // Given: 에러 상태 설정
        viewModel.setError("Test error")
        
        // When: 에러 초기화
        viewModel.clearError()
        
        // Then: 에러가 초기화됨
        #expect(!viewModel.hasError)
        #expect(viewModel.errorMessage == nil)
    }
    
    // MARK: - Computed Properties Tests
    
    @Test("isEmpty 계산 속성 테스트")
    @MainActor
    func testIsEmpty() async {
        let (viewModel, mockStorage) = createTestViewModel()
        
        // 초기 상태는 비어있음
        #expect(viewModel.isEmpty)
        
        // 히스토리 추가 후
        let testHistory = CalculationHistory(expression: "2 + 3", result: 5.0)
        mockStorage.addTestHistory(testHistory)
        await viewModel.loadHistory()
        
        #expect(!viewModel.isEmpty)
    }
    
    @Test("히스토리 개수 확인 테스트")
    @MainActor
    func testHistoryCount() async {
        let (viewModel, mockStorage) = createTestViewModel()
        
        // 초기 개수는 0
        #expect(viewModel.historyItems.count == 0)
        
        // 히스토리 추가 후
        mockStorage.addTestHistory(CalculationHistory(expression: "1 + 1", result: 2.0))
        mockStorage.addTestHistory(CalculationHistory(expression: "2 + 2", result: 4.0))
        await viewModel.loadHistory()
        
        #expect(viewModel.historyItems.count == 2)
    }
    
    // MARK: - Integration Tests
    
    @Test("복합 작업 테스트")
    @MainActor
    func testComplexOperations() async {
        let (viewModel, mockStorage) = createTestViewModel()
        
        // 1. 여러 히스토리 추가
        for i in 1...5 {
            let history = CalculationHistory(expression: "\(i) + \(i)", result: Double(i * 2))
            mockStorage.addTestHistory(history)
        }
        
        // 2. 로드
        await viewModel.loadHistory()
        #expect(viewModel.historyItems.count == 5)
        
        // 3. 특정 항목 선택
        let selectedItem = viewModel.historyItems[2]
        viewModel.selectHistory(selectedItem)
        #expect(viewModel.selectedHistory?.id == selectedItem.id)
        
        // 4. 선택된 항목 삭제
        await viewModel.deleteHistory(selectedItem)
        #expect(viewModel.historyItems.count == 4)
        #expect(viewModel.selectedHistory == nil) // 선택이 자동으로 해제되어야 함
        
        // 5. 전체 삭제
        await viewModel.clearAllHistory()
        #expect(viewModel.isEmpty)
    }
} 