import SwiftUI
import Foundation
import UIKit

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
    @Published var isInBackground: Bool = false
    @Published var hasUnsavedChanges: Bool = false
    
    // MARK: - Private Properties
    
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var saveTimer: Timer?
    
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
    
    /// 앱이 백그라운드로 전환될 때 호출
    func applicationDidEnterBackground() {
        isInBackground = true
        startBackgroundTask()
        saveAllData()
        setupAutoSaveTimer()
    }
    
    /// 앱이 포그라운드로 전환될 때 호출
    func applicationWillEnterForeground() {
        isInBackground = false
        endBackgroundTask()
        invalidateAutoSaveTimer()
        
        // 포그라운드 복귀 시 설정 다시 로드
        Task { @MainActor in
            calculatorViewModel.loadSettings()
        }
    }
    
    /// 앱이 비활성화될 때 호출 (전화 수신 등)
    func applicationWillResignActive() {
        saveAllData()
    }
    
    /// 앱이 활성화될 때 호출
    func applicationDidBecomeActive() {
        // 필요한 경우 상태 복원
        if hasUnsavedChanges {
            saveAllData()
        }
    }
    
    /// 앱이 종료될 때 호출
    func applicationWillTerminate() {
        endBackgroundTask()
        invalidateAutoSaveTimer()
        saveAllData()
    }
    
    // MARK: - Data Management
    
    /// 모든 데이터 저장
    private func saveAllData() {
        let currentSettings = calculatorViewModel.settings
        settingsStorage.saveSettings(currentSettings)
        hasUnsavedChanges = false
    }
    
    /// 변경사항 표시
    func markAsChanged() {
        hasUnsavedChanges = true
    }
    
    // MARK: - Background Task Management
    
    private func startBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "SaveData") {
            self.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    // MARK: - Auto Save Timer
    
    private func setupAutoSaveTimer() {
        invalidateAutoSaveTimer()
        saveTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            if self.hasUnsavedChanges {
                self.saveAllData()
            }
        }
    }
    
    private func invalidateAutoSaveTimer() {
        saveTimer?.invalidate()
        saveTimer = nil
    }
    
    // MARK: - Memory Management
    
    /// 메모리 경고 시 호출
    func handleMemoryWarning() {
        // 캐시된 데이터 정리
        if let provider = helpContentProvider as? DefaultHelpContentProvider {
            provider.clearCache()
        }
        
        // 필요한 경우 다른 캐시 정리
        calculatorViewModel.clearTemporaryData()
    }
    
    /// 저전력 모드 처리
    func handleLowPowerMode() {
        // 자동 저장 간격 늘리기
        if ProcessInfo.processInfo.isLowPowerModeEnabled {
            invalidateAutoSaveTimer()
            setupAutoSaveTimer(interval: 60.0) // 1분으로 늘림
        } else {
            invalidateAutoSaveTimer()
            setupAutoSaveTimer(interval: 30.0) // 30초로 복원
        }
    }
    
    private func setupAutoSaveTimer(interval: TimeInterval) {
        invalidateAutoSaveTimer()
        saveTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if self.hasUnsavedChanges {
                self.saveAllData()
            }
        }
    }
} 