import Foundation
import Combine

/// Help 화면의 ViewModel
/// MVVM 패턴과 Protocol Oriented Programming을 적용하여 설계
@MainActor
public class HelpViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 카테고리별로 정리된 함수 섹션들
    @Published public var functionSections: [HelpSection] = []
    
    /// 모든 팁 목록
    @Published public var allTips: [CalculatorTip] = []
    
    /// 필터링된 함수 목록 (검색 결과)
    @Published public var filteredFunctions: [FunctionDescription] = []
    
    /// 검색어
    @Published public var searchQuery: String = ""
    
    /// 선택된 카테고리 (필터링용)
    @Published public var selectedCategory: FunctionCategory? = nil
    
    /// 로딩 상태
    @Published public var isLoading: Bool = false
    
    /// 에러 상태 여부
    @Published public var hasError: Bool = false
    
    /// 에러 메시지
    @Published public var errorMessage: String? = nil
    
    /// 오늘의 팁
    @Published public var dailyTip: CalculatorTip? = nil
    
    // MARK: - Dependencies
    
    private let contentProvider: HelpContentProvider
    
    // MARK: - Private Properties
    
    private var allFunctions: [FunctionDescription] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    
    /// 컨텐츠가 있는지 확인
    public var hasContent: Bool {
        return !allFunctions.isEmpty || !allTips.isEmpty
    }
    
    /// 컨텐츠가 비어있는지 확인
    public var isEmpty: Bool {
        return allFunctions.isEmpty && allTips.isEmpty
    }
    
    /// 검색 중인지 확인
    public var isSearching: Bool {
        return !searchQuery.isEmpty
    }
    
    /// 카테고리 필터가 적용되었는지 확인
    public var isCategoryFiltered: Bool {
        return selectedCategory != nil
    }
    
    // MARK: - Initialization
    
    public init(contentProvider: HelpContentProvider = DefaultHelpContentProvider()) {
        self.contentProvider = contentProvider
        setupSearchObserver()
        setupCategoryObserver()
    }
    
    // MARK: - Public Methods
    
    /// 컨텐츠를 로드합니다
    public func loadContent() async {
        isLoading = true
        clearError()
        
        do {
            // 함수 설명 로드
            let functions = try contentProvider.loadFunctionDescriptions()
            allFunctions = functions
            
            // 팁 로드
            let tips = try contentProvider.loadCalculatorTips()
            allTips = tips
            
            // 오늘의 팁 설정
            dailyTip = contentProvider.getDailyTip()
            
            // 함수 섹션 생성
            createFunctionSections()
            
            // 필터링된 함수 목록 업데이트
            updateFilteredFunctions()
            
        } catch {
            hasError = true
            errorMessage = "컨텐츠를 로드하는 중 오류가 발생했습니다: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    /// 컨텐츠를 새로고침합니다
    public func refreshContent() async {
        await loadContent()
    }
    
    /// 함수를 검색합니다
    public func searchFunctions(_ query: String) {
        searchQuery = query
        updateFilteredFunctions()
    }
    
    /// 검색을 초기화합니다
    public func clearSearch() {
        searchQuery = ""
    }
    
    /// 카테고리를 선택합니다
    public func selectCategory(_ category: FunctionCategory) {
        selectedCategory = category
        updateFilteredFunctions()
    }
    
    /// 카테고리 선택을 해제합니다
    public func clearCategorySelection() {
        selectedCategory = nil
        updateFilteredFunctions()
    }
    
    /// 특정 카테고리의 팁을 가져옵니다
    public func getTipsForCategory(_ category: TipCategory) -> [CalculatorTip] {
        return contentProvider.getTipsForCategory(category)
    }
    
    /// 난이도별로 정렬된 팁을 가져옵니다
    public func getTipsSortedByDifficulty() -> [CalculatorTip] {
        return allTips.sorted { $0.difficulty.sortOrder < $1.difficulty.sortOrder }
    }
    
    /// 특정 함수 설명을 가져옵니다
    public func getFunctionDescription(for symbol: String) -> FunctionDescription? {
        return allFunctions.first { $0.symbol == symbol }
    }
    
    /// 에러를 초기화합니다
    public func clearError() {
        hasError = false
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    
    /// 검색어 변경 감지 설정
    private func setupSearchObserver() {
        $searchQuery
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.updateFilteredFunctions()
            }
            .store(in: &cancellables)
    }
    
    /// 카테고리 변경 감지 설정
    private func setupCategoryObserver() {
        $selectedCategory
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.updateFilteredFunctions()
            }
            .store(in: &cancellables)
    }
    
    /// 카테고리별 함수 섹션 생성
    private func createFunctionSections() {
        let groupedFunctions = Dictionary(grouping: allFunctions) { $0.category }
        
        functionSections = FunctionCategory.allCases.compactMap { category in
            guard let functions = groupedFunctions[category], !functions.isEmpty else {
                return nil
            }
            
            let sortedFunctions = functions.sorted { $0.functionName < $1.functionName }
            return HelpSection(title: category.displayName, functions: sortedFunctions)
        }
    }
    
    /// 필터링된 함수 목록 업데이트
    private func updateFilteredFunctions() {
        var functions = allFunctions
        
        // 검색 필터 적용
        if !searchQuery.isEmpty {
            functions = functions.filter { function in
                function.functionName.localizedCaseInsensitiveContains(searchQuery) ||
                function.symbol.localizedCaseInsensitiveContains(searchQuery) ||
                function.description.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        
        // 카테고리 필터 적용
        if let category = selectedCategory {
            functions = functions.filter { $0.category == category }
        }
        
        filteredFunctions = functions.sorted { $0.functionName < $1.functionName }
    }
} 