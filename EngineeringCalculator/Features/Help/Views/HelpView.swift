import SwiftUI

/// 도움말을 표시하는 메인 화면
struct HelpView: View {
    // MARK: - Properties
    
    @ObservedObject var viewModel: HelpViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    
    @State private var selectedTab: HelpTab = .functions
    @State private var showingCategoryFilter = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // 탭 바
            helpTabBar
            
            // 컨텐츠 영역
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.hasError {
                    errorView
                } else if viewModel.isEmpty {
                    emptyStateView
                } else {
                    contentView
                }
            }
        }
        .navigationTitle("도움말")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("닫기") {
                    dismiss()
                }
            }
            
            if selectedTab == .functions && viewModel.hasContent {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("필터") {
                        showingCategoryFilter = true
                    }
                }
            }
        }
        .confirmationDialog("카테고리 선택", isPresented: $showingCategoryFilter) {
            categoryFilterDialog
        }
        .task {
            await viewModel.loadContent()
        }
        .refreshable {
            await viewModel.refreshContent()
        }
    }
    
    // MARK: - Help Tab Bar
    
    private var helpTabBar: some View {
        HStack {
            ForEach(HelpTab.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.title2)
                        
                        Text(tab.displayName)
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == tab ? .accentColor : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
    }
    
    // MARK: - Content View
    
    private var contentView: some View {
        Group {
            switch selectedTab {
            case .functions:
                functionsView
            case .tips:
                tipsView
            case .daily:
                dailyTipView
            }
        }
    }
    
    // MARK: - Functions View
    
    private var functionsView: some View {
        VStack(spacing: 0) {
            // 검색 바
            searchBar
            
            // 함수 목록
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.isSearching || viewModel.isCategoryFiltered {
                        filteredFunctionsSection
                    } else {
                        ForEach(viewModel.functionSections) { section in
                            functionSectionView(section)
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("함수 검색...", text: $viewModel.searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if viewModel.isSearching {
                Button("취소") {
                    viewModel.clearSearch()
                }
                .foregroundColor(.accentColor)
            }
        }
        .padding()
    }
    
    private var filteredFunctionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 필터 상태 표시
            HStack {
                if viewModel.isSearching {
                    Text("검색 결과: \(viewModel.filteredFunctions.count)개")
                } else if let category = viewModel.selectedCategory {
                    Text("카테고리: \(category.displayName)")
                }
                
                Spacer()
                
                if viewModel.isCategoryFiltered {
                    Button("필터 해제") {
                        viewModel.clearCategorySelection()
                    }
                    .foregroundColor(.accentColor)
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            // 필터링된 함수 목록
            ForEach(viewModel.filteredFunctions) { function in
                FunctionRowView(function: function)
            }
        }
    }
    
    private func functionSectionView(_ section: HelpSection) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // 섹션 제목
            HStack {
                Text(section.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(section.functions.count)개")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // 함수 목록
            ForEach(section.functions) { function in
                FunctionRowView(function: function)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("도움말을 불러오고 있습니다...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error View
    
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("오류가 발생했습니다")
                .font(.headline)
                .fontWeight(.semibold)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("다시 시도") {
                Task {
                    await viewModel.refreshContent()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Empty State View
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("도움말 내용이 없습니다")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text("나중에 다시 확인해보세요")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("새로고침") {
                Task {
                    await viewModel.refreshContent()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Category Filter Dialog
    
    private var categoryFilterDialog: some View {
        Group {
            Button("전체") {
                viewModel.clearCategorySelection()
            }
            
            ForEach(FunctionCategory.allCases, id: \.self) { category in
                Button(category.displayName) {
                    viewModel.selectCategory(category)
                }
            }
            
            Button("취소", role: .cancel) { }
        }
    }
    
    // MARK: - Tips View
    
    private var tipsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(TipCategory.allCases, id: \.self) { category in
                    tipCategorySection(category)
                }
            }
            .padding()
        }
    }
    
    private func tipCategorySection(_ category: TipCategory) -> some View {
        let tips = viewModel.getTipsForCategory(category)
        
        return Group {
            if !tips.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    // 카테고리 제목
                    HStack {
                        Text(category.displayName)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("\(tips.count)개")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // 팁 목록
                    ForEach(tips) { tip in
                        TipRowView(tip: tip)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Daily Tip View
    
    private var dailyTipView: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let dailyTip = viewModel.dailyTip {
                    // 오늘의 팁
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.title2)
                            
                            Text("오늘의 팁")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        TipRowView(tip: dailyTip)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                } else {
                    // 오늘의 팁이 없을 때
                    VStack(spacing: 16) {
                        Image(systemName: "lightbulb")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text("오늘의 팁이 없습니다")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("내일 다시 확인해보세요!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 40)
                }
                
                // 모든 팁 (난이도별 정렬)
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("모든 팁")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("난이도별 정렬")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    ForEach(viewModel.getTipsSortedByDifficulty()) { tip in
                        TipRowView(tip: tip, showDifficulty: true)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

// MARK: - Help Tab

enum HelpTab: String, CaseIterable {
    case functions = "함수"
    case tips = "팁"
    case daily = "오늘의 팁"
    
    var displayName: String {
        return self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .functions: return "function"
        case .tips: return "lightbulb"
        case .daily: return "calendar"
        }
    }
}

// MARK: - Function Row View (Placeholder)

struct FunctionRowView: View {
    let function: FunctionDescription
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(function.symbol)
                    .font(.system(.title3, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
                    .frame(minWidth: 40, alignment: .leading)
                
                Text(function.functionName)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(function.category.displayName)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.accentColor.opacity(0.1))
                    .foregroundColor(.accentColor)
                    .cornerRadius(8)
            }
            
            Text(function.description)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("사용법: \(function.usage)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("예시: \(function.example)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Previews

#Preview("기본 도움말 화면") {
    HelpView(
        viewModel: HelpViewModel()
    )
}
