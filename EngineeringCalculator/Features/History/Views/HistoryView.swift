import SwiftUI

/// 계산 히스토리를 표시하는 메인 화면
struct HistoryView: View {
    // MARK: - Properties
    
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss
    
    /// 히스토리 항목이 선택되었을 때 호출되는 클로저
    var onHistorySelected: ((String) -> Void)?
    
    // MARK: - State
    
    @State private var showingClearAlert = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.isEmpty {
                    emptyStateView
                } else {
                    historyListView
                }
            }
            .navigationTitle("계산 기록")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("닫기") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewModel.isEmpty {
                        Button("전체 삭제") {
                            showingClearAlert = true
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .alert("모든 기록 삭제", isPresented: $showingClearAlert) {
                Button("취소", role: .cancel) { }
                Button("삭제", role: .destructive) {
                    Task {
                        await viewModel.clearAllHistory()
                    }
                }
            } message: {
                Text("모든 계산 기록을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.")
            }
        }
        .task {
            await viewModel.loadHistory()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    // MARK: - Subviews
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("기록을 불러오는 중...")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("계산 기록이 없습니다")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("계산을 시작하면 여기에 기록이 표시됩니다")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("계산기로 돌아가기") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
    private var historyListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.historyItems) { history in
                    HistoryRowView(history: history)
                        .onTapGesture {
                            // 히스토리 항목 선택하여 계산기로 전달
                            viewModel.selectHistory(history)
                            if let expression = viewModel.getSelectedExpressionAndDeselect() {
                                onHistorySelected?(expression)
                            }
                            dismiss()
                        }
                        .swipeActions(edge: .trailing) {
                            Button("삭제", role: .destructive) {
                                Task {
                                    await viewModel.deleteHistory(history)
                                }
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Preview

#Preview("비어있는 히스토리") {
    HistoryView(
        viewModel: HistoryViewModel(historyStorage: InMemoryHistoryStorage()),
        onHistorySelected: { expression in
            print("Selected expression: \(expression)")
        }
    )
}

#Preview("히스토리가 있는 상태") {
    let storage = InMemoryHistoryStorage()
    
    // 샘플 데이터 추가
    let sampleHistory = [
        CalculationHistory(expression: "2 + 3", result: 5.0),
        CalculationHistory(expression: "sin(π/2)", result: 1.0),
        CalculationHistory(expression: "log(10)", result: 1.0),
        CalculationHistory(expression: "√16", result: 4.0),
        CalculationHistory(expression: "1/0", error: "Division by zero")
    ]
    
    for history in sampleHistory {
        try? storage.saveHistory(history)
    }
    
    let viewModel = HistoryViewModel(historyStorage: storage)
    
    return HistoryView(
        viewModel: viewModel,
        onHistorySelected: { expression in
            print("Selected expression: \(expression)")
        }
    )
    .task {
        await viewModel.loadHistory()
    }
}

#Preview("로딩 상태") {
    let viewModel = HistoryViewModel(historyStorage: InMemoryHistoryStorage())
    viewModel.isLoading = true
    
    return HistoryView(
        viewModel: viewModel,
        onHistorySelected: { expression in
            print("Selected expression: \(expression)")
        }
    )
} 