# Shared

이 폴더는 앱 전체에서 공유되는 코드를 포함합니다.

## 구조

-   `Models/` - 공통 데이터 모델

    -   `CalculatorButton.swift` - 계산기 버튼 타입
    -   `CalculatorSettings.swift` - 앱 설정 모델
    -   `CalculationHistory.swift` - 계산 히스토리 모델
    -   `AngleUnit.swift` - 각도 단위 enum

-   `Extensions/` - Swift 타입 확장

    -   `Double+Extensions.swift` - Double 타입 확장
    -   `String+Extensions.swift` - String 타입 확장

-   `Constants/` - 앱 상수
    -   `AppConstants.swift` - 앱 전역 상수
    -   `MathConstants.swift` - 수학 상수 (π, e 등)
