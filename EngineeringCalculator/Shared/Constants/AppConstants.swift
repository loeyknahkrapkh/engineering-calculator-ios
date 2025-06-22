import Foundation

/// 앱 전체에서 사용하는 상수들을 정의하는 구조체
struct AppConstants {
    
    // MARK: - App Information
    
    /// 앱 이름
    static let appName = "Engineering Calculator"
    
    /// 앱 버전
    static let appVersion = "1.0.0"
    
    /// 번들 식별자
    static let bundleIdentifier = "com.demo.EngineeringCalculator"
    
    // MARK: - UI Constants
    
    /// 최소 터치 타겟 크기 (Apple HIG 권장)
    static let minimumTouchTarget: CGFloat = 44.0
    
    /// 기본 버튼 크기
    static let defaultButtonSize: CGFloat = 60.0
    
    /// 버튼 간격
    static let defaultSpacing: CGFloat = 8.0
    
    /// 기본 패딩
    static let defaultPadding: CGFloat = 16.0
    
    /// 모서리 반경
    static let cornerRadius: CGFloat = 8.0
    
    /// 애니메이션 지속 시간
    static let defaultAnimationDuration: TimeInterval = 0.3
    
    /// 버튼 눌림 애니메이션 지속 시간
    static let buttonPressAnimationDuration: TimeInterval = 0.1
    
    /// 스프링 애니메이션 감쇠도
    static let springAnimationDamping: CGFloat = 0.8
    
    /// 스프링 애니메이션 속도
    static let springAnimationVelocity: CGFloat = 0.6
    
    // MARK: - Calculator Constants
    
    /// 기본 소수점 자릿수
    static let defaultDecimalPlaces = 4
    
    /// 최대 소수점 자릿수
    static let maxDecimalPlaces = 10
    
    /// 과학적 표기법 임계값
    static let scientificNotationThreshold = 1e10
    
    /// 작은 수 임계값
    static let minScientificNotationThreshold = 1e-4
    
    // MARK: - History Constants
    
    /// 기본 최대 히스토리 개수
    static let defaultMaxHistoryCount = 100
    
    /// 최소 히스토리 개수
    static let minHistoryCount = 10
    
    /// 최대 히스토리 개수
    static let maxHistoryCount = 1000
    
    /// 히스토리 표시 개수 (메인 화면)
    static let recentHistoryDisplayCount = 5
    
    // MARK: - UserDefaults Keys
    
    /// 설정 저장 키
    static let settingsKey = "CalculatorSettings"
    
    /// 각도 단위 키
    static let angleUnitKey = "AngleUnit"
    
    /// 소수점 자릿수 키
    static let decimalPlacesKey = "DecimalPlaces"
    
    /// 첫 실행 여부 키
    static let isFirstLaunchKey = "IsFirstLaunch"
    
    /// 팁 표시 여부 키
    static let showTipsKey = "ShowTips"
    
    // MARK: - Error Messages
    
    /// 일반 계산 오류
    static let generalCalculationError = "계산 오류가 발생했습니다"
    
    /// 0으로 나누기 오류
    static let divisionByZeroError = "0으로 나눌 수 없습니다"
    
    /// 정의역 오류
    static let domainError = "정의되지 않은 값입니다"
    
    /// 범위 오류
    static let rangeError = "값이 범위를 벗어났습니다"
    
    /// 구문 오류
    static let syntaxError = "잘못된 수식입니다"
    
    /// 오버플로우 오류
    static let overflowError = "결과가 너무 큽니다"
    
    /// 언더플로우 오류
    static let underflowError = "결과가 너무 작습니다"
    
    // MARK: - Accessibility
    
    /// 접근성 레이블
    struct AccessibilityLabels {
        static let calculatorButton = "계산기 버튼"
        static let numberButton = "숫자 버튼"
        static let operatorButton = "연산자 버튼"
        static let functionButton = "함수 버튼"
        static let clearButton = "지우기 버튼"
        static let equalsButton = "계산 버튼"
        static let historyButton = "히스토리 버튼"
        static let helpButton = "도움말 버튼"
        static let settingsButton = "설정 버튼"
    }
    
    // MARK: - Notifications
    
    /// 설정 변경 알림
    static let settingsDidChangeNotification = Notification.Name("SettingsDidChange")
    
    /// 히스토리 업데이트 알림
    static let historyDidUpdateNotification = Notification.Name("HistoryDidUpdate")
    
    /// 계산 완료 알림
    static let calculationDidCompleteNotification = Notification.Name("CalculationDidComplete")
}

/// 수학 상수들을 정의하는 구조체
struct MathConstants {
    
    // MARK: - Mathematical Constants
    
    /// 원주율 π
    static let pi = Double.pi
    
    /// 자연상수 e
    static let e = 2.718281828459045
    
    /// 황금비 φ
    static let phi = (1.0 + sqrt(5.0)) / 2.0
    
    /// 오일러-마스케로니 상수 γ
    static let gamma = 0.5772156649015329
    
    /// 제곱근 2
    static let sqrt2 = sqrt(2.0)
    
    /// 제곱근 3
    static let sqrt3 = sqrt(3.0)
    
    /// 자연로그 2
    static let ln2 = log(2.0)
    
    /// 자연로그 10
    static let ln10 = log(10.0)
    
    // MARK: - Angle Conversion Constants
    
    /// 도-라디안 변환 계수
    static let degreesToRadians = Double.pi / 180.0
    
    /// 라디안-도 변환 계수
    static let radiansToDegrees = 180.0 / Double.pi
    
    // MARK: - Physical Constants (for educational purposes)
    
    /// 빛의 속도 (m/s)
    static let speedOfLight = 299792458.0
    
    /// 플랑크 상수 (J⋅s)
    static let planckConstant = 6.62607015e-34
    
    /// 아보가드로 수 (mol⁻¹)
    static let avogadroNumber = 6.02214076e23
    
    /// 중력가속도 (m/s², 표준 중력)
    static let gravitationalConstant = 9.80665
} 