import Foundation

/// 계산기 설정 모델
struct CalculatorSettings: Codable, Equatable {
    /// 각도 단위 (라디안/도)
    var angleUnit: AngleUnit
    
    /// 결과 표시 소수점 자릿수
    var decimalPlaces: Int
    
    /// 첫 실행 여부
    var isFirstLaunch: Bool
    
    /// 팁 표시 여부
    var showTips: Bool
    
    /// 과학적 표기법 사용 여부
    var useScientificNotation: Bool
    
    /// 히스토리 자동 저장 여부
    var autoSaveHistory: Bool
    
    /// 최대 히스토리 개수
    var maxHistoryCount: Int
    
    /// 기본 설정으로 초기화
    init() {
        self.angleUnit = .degree
        self.decimalPlaces = 4
        self.isFirstLaunch = true
        self.showTips = true
        self.useScientificNotation = false
        self.autoSaveHistory = true
        self.maxHistoryCount = 100
    }
    
    /// 커스텀 설정으로 초기화
    init(
        angleUnit: AngleUnit = .degree,
        decimalPlaces: Int = 4,
        isFirstLaunch: Bool = true,
        showTips: Bool = true,
        useScientificNotation: Bool = false,
        autoSaveHistory: Bool = true,
        maxHistoryCount: Int = 100
    ) {
        self.angleUnit = angleUnit
        self.decimalPlaces = max(0, min(10, decimalPlaces)) // 0-10 범위로 제한
        self.isFirstLaunch = isFirstLaunch
        self.showTips = showTips
        self.useScientificNotation = useScientificNotation
        self.autoSaveHistory = autoSaveHistory
        self.maxHistoryCount = max(10, min(1000, maxHistoryCount)) // 10-1000 범위로 제한
    }
    
    /// 설정 유효성 검증
    var isValid: Bool {
        return decimalPlaces >= 0 && decimalPlaces <= 10 &&
               maxHistoryCount >= 10 && maxHistoryCount <= 1000
    }
    
    /// 설정을 기본값으로 리셋
    mutating func resetToDefaults() {
        self = CalculatorSettings()
    }
    
    /// 각도 단위 토글
    mutating func toggleAngleUnit() {
        self.angleUnit = self.angleUnit.toggled()
    }
} 