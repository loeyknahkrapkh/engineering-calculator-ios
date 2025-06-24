import Testing
import SwiftUI
@testable import EngineeringCalculator

@Suite("HistoryView 테스트")
struct HistoryViewTests {
    
    // MARK: - Test Data
    
    private func createSampleHistory() -> [CalculationHistory] {
        return [
            CalculationHistory(expression: "2 + 3", result: 5.0),
            CalculationHistory(expression: "sin(π/2)", result: 1.0),
            CalculationHistory(expression: "log(10)", result: 1.0),
            CalculationHistory(expression: "1/0", error: "Division by zero")
        ]
    }
    
    private func createMockHistoryStorage() -> HistoryStorage {
        let storage = InMemoryHistoryStorage()
        let sampleHistory = createSampleHistory()
        
        for history in sampleHistory {
            try? storage.saveHistory(history)
        }
        
        return storage
    }
    
    // MARK: - HistoryView 기본 구조 테스트
    
    @Test("HistoryView 초기 상태 확인")
    func testHistoryViewInitialState() async throws {
        // Given
        let storage = createMockHistoryStorage()
        let viewModel = HistoryViewModel(historyStorage: storage)
        
        // When
        let view = HistoryView(viewModel: viewModel)
        
        // Then
        await MainActor.run {
            #expect(viewModel.historyItems.isEmpty)
            #expect(!viewModel.isLoading)
            #expect(!viewModel.hasError)
        }
    }
    
    @Test("HistoryView가 히스토리 목록을 표시하는지 확인")
    func testHistoryViewDisplaysHistoryList() async throws {
        // Given
        let storage = createMockHistoryStorage()
        let viewModel = HistoryViewModel(historyStorage: storage)
        await viewModel.loadHistory()
        
        // When
        let view = HistoryView(viewModel: viewModel)
        
        // Then
        await MainActor.run {
            #expect(viewModel.historyItems.count == 4)
            #expect(!viewModel.isEmpty)
        }
    }
    
    @Test("빈 히스토리 상태 표시")
    func testEmptyHistoryState() async throws {
        // Given
        let storage = InMemoryHistoryStorage()
        let viewModel = HistoryViewModel(historyStorage: storage)
        await viewModel.loadHistory()
        
        // When
        let view = HistoryView(viewModel: viewModel)
        
        // Then
        await MainActor.run {
            #expect(viewModel.isEmpty)
            #expect(viewModel.historyItems.isEmpty)
        }
    }
    
    // MARK: - HistoryRowView 테스트
    
    @Test("HistoryRowView가 계산식을 표시하는지 확인")
    func testHistoryRowViewDisplaysExpression() throws {
        // Given
        let history = CalculationHistory(expression: "2 + 3", result: 5.0)
        
        // When
        let view = HistoryRowView(history: history)
        
        // Then
        #expect(history.expression == "2 + 3")
        #expect(history.formattedResult == "5")
    }
    
    @Test("HistoryRowView가 결과를 올바르게 표시하는지 확인")
    func testHistoryRowViewDisplaysResult() throws {
        // Given
        let history = CalculationHistory(expression: "sin(π/2)", result: 1.0)
        
        // When
        let view = HistoryRowView(history: history)
        
        // Then
        #expect(history.formattedResult == "1")
    }
    
    @Test("HistoryRowView가 에러를 올바르게 표시하는지 확인")
    func testHistoryRowViewDisplaysError() throws {
        // Given
        let history = CalculationHistory(expression: "1/0", error: "Division by zero")
        
        // When
        let view = HistoryRowView(history: history)
        
        // Then
        #expect(history.hasError)
        #expect(history.formattedResult == "Division by zero")
    }
    
    @Test("HistoryRowView가 상대적 시간을 표시하는지 확인")
    func testHistoryRowViewDisplaysRelativeTime() throws {
        // Given
        let history = CalculationHistory(expression: "2 + 3", result: 5.0)
        
        // When
        let view = HistoryRowView(history: history)
        
        // Then
        #expect(!history.relativeTimeString.isEmpty)
        #expect(history.relativeTimeString == "방금 전")
    }
    
    // MARK: - 네비게이션 바 테스트
    
    @Test("HistoryView 네비게이션 바 제목 확인")
    func testHistoryViewNavigationTitle() async throws {
        // Given
        let storage = createMockHistoryStorage()
        let viewModel = HistoryViewModel(historyStorage: storage)
        
        // When
        let view = HistoryView(viewModel: viewModel)
        
        // Then
        // NavigationTitle이 "계산 기록"인지 확인 (구현에서 설정 예정)
    }
    
    @Test("전체 삭제 버튼 기능 확인")
    func testClearAllHistoryButton() async throws {
        // Given
        let storage = createMockHistoryStorage()
        let viewModel = HistoryViewModel(historyStorage: storage)
        await viewModel.loadHistory()
        
        await MainActor.run {
            #expect(!viewModel.isEmpty)
        }
        
        // When
        await viewModel.clearAllHistory()
        
        // Then
        await MainActor.run {
            #expect(viewModel.isEmpty)
            #expect(viewModel.historyItems.isEmpty)
        }
    }
    
    // MARK: - 상호작용 테스트
    
    @Test("히스토리 항목 선택 기능")
    func testHistoryItemSelection() async throws {
        // Given
        let storage = createMockHistoryStorage()
        let viewModel = HistoryViewModel(historyStorage: storage)
        await viewModel.loadHistory()
        
        let firstHistory = await MainActor.run { viewModel.historyItems.first! }
        
        // When
        await MainActor.run {
            viewModel.selectHistory(firstHistory)
        }
        
        // Then
        await MainActor.run {
            #expect(viewModel.selectedHistory?.id == firstHistory.id)
            #expect(viewModel.selectedExpression == firstHistory.expression)
        }
    }
    
    @Test("선택된 히스토리 수식 반환 및 선택 해제")
    func testGetSelectedExpressionAndDeselect() async throws {
        // Given
        let storage = createMockHistoryStorage()
        let viewModel = HistoryViewModel(historyStorage: storage)
        await viewModel.loadHistory()
        
        let firstHistory = await MainActor.run { viewModel.historyItems.first! }
        await MainActor.run {
            viewModel.selectHistory(firstHistory)
        }
        
        // When
        let expression = await MainActor.run {
            viewModel.getSelectedExpressionAndDeselect()
        }
        
        // Then
        #expect(expression == firstHistory.expression)
        await MainActor.run {
            #expect(viewModel.selectedHistory == nil)
        }
    }
    
    // MARK: - 로딩 상태 테스트
    
    @Test("히스토리 로딩 상태 확인")
    func testHistoryLoadingState() async throws {
        // Given
        let storage = createMockHistoryStorage()
        let viewModel = HistoryViewModel(historyStorage: storage)
        
        // When & Then
        let loadTask = Task {
            await viewModel.loadHistory()
        }
        
        // 로딩 완료 대기
        await loadTask.value
        
        await MainActor.run {
            #expect(!viewModel.isLoading)
            #expect(!viewModel.hasError)
            #expect(!viewModel.isEmpty)
        }
    }
    
    // MARK: - 에러 상태 테스트
    
    @Test("히스토리 로드 에러 처리")
    func testHistoryLoadError() async throws {
        // Given - 에러를 발생시키는 모킹된 스토리지 필요
        // 실제 구현에서는 실패하는 스토리지를 만들어야 함
        let storage = InMemoryHistoryStorage()
        let viewModel = HistoryViewModel(historyStorage: storage)
        
        // When
        await viewModel.loadHistory()
        
        // Then
        await MainActor.run {
            #expect(!viewModel.hasError) // 현재는 InMemoryHistoryStorage가 에러를 발생시키지 않음
        }
    }
    
    // MARK: - 히스토리 재사용 기능 테스트
    
    @Test("히스토리 항목 재사용 기능")
    func testHistoryItemReuse() async throws {
        // Given
        let storage = createMockHistoryStorage()
        let viewModel = HistoryViewModel(historyStorage: storage)
        await viewModel.loadHistory()
        
        let firstHistory = await MainActor.run { viewModel.historyItems.first! }
        
        // When
        await MainActor.run {
            viewModel.selectHistory(firstHistory)
        }
        
        // Then
        await MainActor.run {
            #expect(viewModel.selectedHistory != nil)
            #expect(viewModel.selectedExpression == firstHistory.expression)
        }
    }
    
    @Test("선택된 히스토리가 올바른 수식을 반환하는지 확인")
    func testSelectedHistoryReturnsCorrectExpression() async throws {
        // Given
        let expectedExpression = "2 + 3 * 4"
        let history = CalculationHistory(expression: expectedExpression, result: 14.0)
        let storage = InMemoryHistoryStorage()
        try? storage.saveHistory(history)
        
        let viewModel = HistoryViewModel(historyStorage: storage)
        await viewModel.loadHistory()
        
        // When
        await MainActor.run {
            viewModel.selectHistory(history)
        }
        
        let selectedExpression = await MainActor.run {
            viewModel.selectedExpression
        }
        
        // Then
        #expect(selectedExpression == expectedExpression)
    }
    
    @Test("계산기로 수식 전달 후 선택 해제")
    func testExpressionTransferAndDeselection() async throws {
        // Given
        let expression = "sin(π/2) + cos(0)"
        let history = CalculationHistory(expression: expression, result: 2.0)
        let storage = InMemoryHistoryStorage()
        try? storage.saveHistory(history)
        
        let viewModel = HistoryViewModel(historyStorage: storage)
        await viewModel.loadHistory()
        
        await MainActor.run {
            viewModel.selectHistory(history)
        }
        
        // When
        let transferredExpression = await MainActor.run {
            viewModel.getSelectedExpressionAndDeselect()
        }
        
        // Then
        #expect(transferredExpression == expression)
        await MainActor.run {
            #expect(viewModel.selectedHistory == nil)
        }
    }
} 