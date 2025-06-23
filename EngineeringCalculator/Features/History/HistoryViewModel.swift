import Foundation
import Combine

/// History 화면의 ViewModel
/// MVVM 패턴과 Protocol Oriented Programming을 적용하여 설계
@MainActor
public class HistoryViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 히스토리 항목들
    @Published public var historyItems: [CalculationHistory] = []
    
    /// 로딩 상태
    @Published public var isLoading: Bool = false
    
    /// 에러 상태 여부
    @Published public var hasError: Bool = false
    
    /// 에러 메시지
    @Published public var errorMessage: String? = nil
    
    /// 현재 선택된 히스토리 항목
    @Published public var selectedHistory: CalculationHistory? = nil
    
    // MARK: - Dependencies
    
    private let historyStorage: HistoryStorage
    
    // MARK: - Computed Properties
    
    /// 히스토리가 비어있는지 확인
    public var isEmpty: Bool {
        return historyItems.isEmpty
    }
    
    /// 선택된 히스토리의 수식
    public var selectedExpression: String? {
        return selectedHistory?.expression
    }
    
    // MARK: - Initialization
    
    nonisolated public init(historyStorage: HistoryStorage) {
        self.historyStorage = historyStorage
    }
    
    // MARK: - History Management
    
    /// 히스토리 로드
    public func loadHistory() async {
        isLoading = true
        clearError()
        
        do {
            let loadedHistory = try historyStorage.loadAllHistory()
            historyItems = loadedHistory
        } catch {
            setError("히스토리를 불러오는데 실패했습니다: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    /// 최근 히스토리 로드 (제한된 개수)
    /// - Parameter limit: 로드할 최대 개수
    public func loadRecentHistory(limit: Int = 50) async {
        isLoading = true
        clearError()
        
        do {
            let recentHistory = try historyStorage.loadRecentHistory(limit: limit)
            historyItems = recentHistory
        } catch {
            setError("최근 히스토리를 불러오는데 실패했습니다: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    /// 특정 히스토리 항목 삭제
    /// - Parameter history: 삭제할 히스토리 항목
    public func deleteHistory(_ history: CalculationHistory) async {
        clearError()
        
        do {
            try historyStorage.deleteHistory(history)
            
            // UI에서 해당 항목 제거
            historyItems.removeAll { $0.id == history.id }
            
            // 선택된 항목이 삭제된 경우 선택 해제
            if selectedHistory?.id == history.id {
                deselectHistory()
            }
            
        } catch {
            setError("히스토리 삭제에 실패했습니다: \(error.localizedDescription)")
        }
    }
    
    /// 모든 히스토리 삭제
    public func clearAllHistory() async {
        clearError()
        
        do {
            try historyStorage.clearAllHistory()
            historyItems.removeAll()
            deselectHistory()
        } catch {
            setError("모든 히스토리 삭제에 실패했습니다: \(error.localizedDescription)")
        }
    }
    
    // MARK: - History Selection
    
    /// 히스토리 항목 선택
    /// - Parameter history: 선택할 히스토리 항목
    public func selectHistory(_ history: CalculationHistory) {
        selectedHistory = history
    }
    
    /// 히스토리 선택 해제
    public func deselectHistory() {
        selectedHistory = nil
    }
    
    /// 선택된 히스토리의 수식을 반환하고 선택 해제
    /// - Returns: 선택된 히스토리의 수식
    public func getSelectedExpressionAndDeselect() -> String? {
        let expression = selectedExpression
        deselectHistory()
        return expression
    }
    
    // MARK: - Error Handling
    
    /// 에러 설정
    /// - Parameter message: 에러 메시지
    public func setError(_ message: String) {
        errorMessage = message
        hasError = true
    }
    
    /// 에러 초기화
    public func clearError() {
        errorMessage = nil
        hasError = false
    }
    
    // MARK: - Refresh
    
    /// 히스토리 새로고침
    public func refresh() async {
        await loadHistory()
    }
    
    // MARK: - Utility Methods
    
    /// 특정 인덱스의 히스토리 항목 가져오기
    /// - Parameter index: 인덱스
    /// - Returns: 해당 인덱스의 히스토리 항목 (없으면 nil)
    public func historyItem(at index: Int) -> CalculationHistory? {
        guard index >= 0 && index < historyItems.count else {
            return nil
        }
        return historyItems[index]
    }
    
    /// 히스토리 항목의 인덱스 찾기
    /// - Parameter history: 찾을 히스토리 항목
    /// - Returns: 해당 항목의 인덱스 (없으면 nil)
    public func indexOf(_ history: CalculationHistory) -> Int? {
        return historyItems.firstIndex { $0.id == history.id }
    }
    
    /// 특정 수식을 포함하는 히스토리 검색
    /// - Parameter searchText: 검색할 텍스트
    /// - Returns: 검색 결과 히스토리 배열
    public func searchHistory(with searchText: String) -> [CalculationHistory] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return historyItems
        }
        
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        return historyItems.filter { history in
            history.expression.lowercased().contains(trimmedSearchText) ||
            history.formattedResult.lowercased().contains(trimmedSearchText)
        }
    }
    
    /// 날짜별로 히스토리 그룹화
    /// - Returns: 날짜별로 그룹화된 히스토리 딕셔너리
    public func groupedHistoryByDate() -> [Date: [CalculationHistory]] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: historyItems) { history in
            calendar.startOfDay(for: history.timestamp)
        }
        return grouped
    }
}

// MARK: - Private Extensions

private extension HistoryViewModel {
    
    /// 에러 로깅 (개발용)
    func logError(_ error: Error, context: String) {
        print("HistoryViewModel Error in \(context): \(error.localizedDescription)")
    }
} 