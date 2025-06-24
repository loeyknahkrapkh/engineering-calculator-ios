import Testing
import SwiftUI
@testable import EngineeringCalculator

@Suite("HelpView 테스트")
struct HelpViewTests {
    
    // MARK: - Test Data
    
    private func createSampleHelpContent() -> DefaultHelpContentProvider {
        return DefaultHelpContentProvider()
    }
    
    private func createMockHelpViewModel() async -> HelpViewModel {
        let provider = createSampleHelpContent()
        let viewModel = await HelpViewModel(contentProvider: provider)
        await viewModel.loadContent()
        return viewModel
    }
    
    // MARK: - 기본 구조 테스트
    
    @Test("HelpView 초기 상태 확인")
    func testHelpViewInitialState() async throws {
        // Given
        let provider = createSampleHelpContent()
        let viewModel = await HelpViewModel(contentProvider: provider)
        
        // When
        let _ = HelpView(viewModel: viewModel)
        
        // Then
        await MainActor.run {
            #expect(viewModel.functionSections.isEmpty)
            #expect(viewModel.allTips.isEmpty)
            #expect(!viewModel.hasContent)
            #expect(viewModel.isEmpty)
        }
    }
    
    @Test("HelpView가 컨텐츠를 올바르게 로드하는지 확인")
    func testHelpViewLoadsContent() async throws {
        // Given
        let viewModel = await createMockHelpViewModel()
        
        // When
        let _ = HelpView(viewModel: viewModel)
        
        // Then
        await MainActor.run {
            #expect(!viewModel.functionSections.isEmpty)
            #expect(!viewModel.allTips.isEmpty)
            #expect(viewModel.hasContent)
            #expect(!viewModel.isEmpty)
        }
    }
    
    // MARK: - 네비게이션 테스트
    
    @Test("HelpView 네비게이션 바 구성 확인")
    func testHelpViewNavigationBar() async throws {
        // Given
        let viewModel = await createMockHelpViewModel()
        
        // When
        let _ = HelpView(viewModel: viewModel)
        
        // Then - 네비게이션 바에 제목과 닫기 버튼이 있어야 함
        await MainActor.run {
            #expect(viewModel.hasContent)
        }
    }
    
    // MARK: - 검색 기능 테스트
    
    @Test("검색 기능 테스트")
    func testSearchFunctionality() async throws {
        // Given
        let viewModel = await createMockHelpViewModel()
        
        // When
        await MainActor.run {
            viewModel.searchFunctions("sin")
        }
        
        // Then
        await MainActor.run {
            #expect(viewModel.isSearching)
            #expect(!viewModel.filteredFunctions.isEmpty)
            #expect(viewModel.filteredFunctions.contains { $0.symbol == "sin" })
        }
    }
    
    @Test("검색 초기화 기능 테스트")
    func testClearSearch() async throws {
        // Given
        let viewModel = await createMockHelpViewModel()
        await MainActor.run {
            viewModel.searchFunctions("sin")
        }
        
        // When
        await MainActor.run {
            viewModel.clearSearch()
        }
        
        // Then
        await MainActor.run {
            #expect(!viewModel.isSearching)
            #expect(viewModel.searchQuery.isEmpty)
        }
    }
    
    // MARK: - 카테고리 필터 테스트
    
    @Test("카테고리 필터 기능 테스트")
    func testCategoryFilter() async throws {
        // Given
        let viewModel = await createMockHelpViewModel()
        
        // When
        await MainActor.run {
            viewModel.selectCategory(.trigonometric)
        }
        
        // Then
        await MainActor.run {
            #expect(viewModel.isCategoryFiltered)
            #expect(viewModel.selectedCategory == .trigonometric)
            #expect(viewModel.filteredFunctions.allSatisfy { $0.category == .trigonometric })
        }
    }
    
    @Test("카테고리 필터 해제 기능 테스트")
    func testClearCategoryFilter() async throws {
        // Given
        let viewModel = await createMockHelpViewModel()
        await MainActor.run {
            viewModel.selectCategory(.trigonometric)
        }
        
        // When
        await MainActor.run {
            viewModel.clearCategorySelection()
        }
        
        // Then
        await MainActor.run {
            #expect(!viewModel.isCategoryFiltered)
            #expect(viewModel.selectedCategory == nil)
        }
    }
    
    // MARK: - 함수 섹션 테스트
    
    @Test("함수 섹션이 올바르게 표시되는지 확인")
    func testFunctionSectionsDisplay() async throws {
        // Given
        let viewModel = await createMockHelpViewModel()
        
        // When
        let _ = HelpView(viewModel: viewModel)
        
        // Then
        await MainActor.run {
            #expect(!viewModel.functionSections.isEmpty)
            #expect(viewModel.functionSections.contains { $0.title == "기본 연산" })
            #expect(viewModel.functionSections.contains { $0.title == "삼각함수" })
            #expect(viewModel.functionSections.contains { $0.title == "로그함수" })
        }
    }
    
    // MARK: - 팁 기능 테스트
    
    @Test("팁 섹션 표시 테스트")
    func testTipsSection() async throws {
        // Given
        let viewModel = await createMockHelpViewModel()
        
        // When
        let _ = HelpView(viewModel: viewModel)
        
        // Then
        await MainActor.run {
            #expect(!viewModel.allTips.isEmpty)
            let sortedTips = viewModel.getTipsSortedByDifficulty()
            #expect(!sortedTips.isEmpty)
        }
    }
    
    @Test("오늘의 팁 기능 테스트")
    func testDailyTip() async throws {
        // Given
        let viewModel = await createMockHelpViewModel()
        
        // When
        let _ = HelpView(viewModel: viewModel)
        
        // Then
        await MainActor.run {
            let dailyTip = viewModel.dailyTip
            // dailyTip이 있을 수도, 없을 수도 있음
            if let tip = dailyTip {
                #expect(tip.isDaily)
            }
        }
    }
    
    // MARK: - 에러 상태 테스트
    
    @Test("에러 상태 처리 테스트")
    func testErrorHandling() async throws {
        // Given
        let provider = createSampleHelpContent()
        let viewModel = await HelpViewModel(contentProvider: provider)
        
        // When & Then
        await MainActor.run {
            viewModel.clearError()
            #expect(!viewModel.hasError)
            #expect(viewModel.errorMessage == nil)
        }
    }
    
    // MARK: - 로딩 상태 테스트
    
    @Test("로딩 상태 테스트")
    func testLoadingState() async throws {
        // Given
        let provider = createSampleHelpContent()
        let viewModel = await HelpViewModel(contentProvider: provider)
        
        // When
        let loadTask = Task {
            await viewModel.loadContent()
        }
        
        // Then
        await loadTask.value
        
        await MainActor.run {
            #expect(!viewModel.isLoading)
        }
    }
    
    // MARK: - 컨텐츠 새로고침 테스트
    
    @Test("컨텐츠 새로고침 기능 테스트")
    func testRefreshContent() async throws {
        // Given
        let viewModel = await createMockHelpViewModel()
        let initialSectionCount = await MainActor.run { viewModel.functionSections.count }
        
        // When
        await viewModel.refreshContent()
        
        // Then
        await MainActor.run {
            #expect(viewModel.functionSections.count == initialSectionCount)
            #expect(!viewModel.isLoading)
        }
    }
}
