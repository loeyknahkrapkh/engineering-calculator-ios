import SwiftUI
import Foundation

/// 앱 전체의 의존성과 상태를 관리하는 컨테이너
@MainActor
final class AppContainer: ObservableObject {
    
    // MARK: - Core Dependencies
    
    let calculatorEngine: CalculatorEngine
    let settingsStorage: SettingsStorage
    let historyStorage: HistoryStorage
    let helpContentProvider: HelpContentProvider
    
    // MARK: - ViewModels
    
    lazy var calculatorViewModel: CalculatorViewModel = {
        return CalculatorViewModel(
            calculatorEngine: calculatorEngine,
            settingsStorage: settingsStorage,
            historyStorage: historyStorage
        )
    }()
    
    // MARK: - App State
    
    @Published var isFirstLaunch: Bool
    
    // MARK: - Initialization
    
    init() {
        // Core dependencies 초기화
        self.calculatorEngine = ScientificCalculatorEngine()
        self.settingsStorage = UserDefaultsSettingsStorage()
        self.historyStorage = InMemoryHistoryStorage()
        self.helpContentProvider = DefaultHelpContentProvider()
        
        // 첫 실행 여부 확인
        self.isFirstLaunch = settingsStorage.isFirstLaunch()
        
        // 첫 실행이 완료되었다고 표시
        if isFirstLaunch {
            settingsStorage.setFirstLaunchCompleted()
        }
    }
    
    // MARK: - Factory Methods
    
    /// HistoryViewModel 생성
    func makeHistoryViewModel() -> HistoryViewModel {
        return HistoryViewModel(historyStorage: historyStorage)
    }
    
    /// HelpViewModel 생성
    func makeHelpViewModel() -> HelpViewModel {
        return HelpViewModel(contentProvider: helpContentProvider)
    }
    
    // MARK: - App Lifecycle Methods
    
    /// 앱이 백그라운드로 갈 때 호출
    func applicationDidEnterBackground() {
        // 현재 설정 저장
        settingsStorage.saveSettings(calculatorViewModel.settings)
    }
    
    /// 앱이 포그라운드로 올 때 호출
    func applicationWillEnterForeground() {
        // 설정 다시 로드 (다른 앱에서 변경되었을 수 있음)
        let settings = settingsStorage.loadSettings()
        calculatorViewModel.settings = settings
    }
    
    /// 앱이 종료될 때 호출
    func applicationWillTerminate() {
        // 최종 설정 저장
        settingsStorage.saveSettings(calculatorViewModel.settings)
    }
} 