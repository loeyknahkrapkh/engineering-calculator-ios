# Core

이 폴더는 앱의 핵심 비즈니스 로직과 인프라 코드를 포함합니다.

## 구조

-   `Engine/` - 계산 엔진 및 수학 함수

    -   `CalculatorEngine.swift` - 계산 엔진 프로토콜
    -   `ScientificCalculatorEngine.swift` - 공학용 계산기 구현
    -   `ExpressionParser.swift` - 수식 파싱 로직
    -   `MathFunctions.swift` - 수학 함수 구현

-   `Storage/` - 데이터 저장 및 관리
    -   `SettingsStorage.swift` - 설정 저장소 프로토콜
    -   `HistoryStorage.swift` - 히스토리 저장소 프로토콜
    -   `UserDefaultsSettingsStorage.swift` - UserDefaults 구현
    -   `CoreDataHistoryStorage.swift` - Core Data 구현
