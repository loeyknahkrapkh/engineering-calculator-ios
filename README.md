# 공학용 계산기 iOS 앱

📱 학생들을 위한 간단하고 직관적인 공학용 계산기 iOS 앱

## 🎯 프로젝트 개요

수업 시간에 사용할 수 있는 학습 환경에 최적화된 공학용 계산기 앱입니다.

### 주요 특징

-   **세로 모드 전용**: 학습 환경에 최적화된 단일 화면 방향 지원
-   **공학 함수**: 삼각함수, 로그함수, 지수함수 등 학습에 필요한 핵심 함수 제공
-   **계산 히스토리**: 최근 10개 계산 결과 저장 및 재사용
-   **직관적 UI**: 간단하고 깔끔한 사용자 인터페이스
-   **도움말 기능**: 함수 설명 및 사용 예제 제공

### 기술 스택

-   **언어**: Swift 6.0
-   **UI Framework**: SwiftUI
-   **최소 지원 버전**: iOS 18.4
-   **아키텍처**: MVVM + Protocol Oriented Programming
-   **테스트**: Swift Testing (TDD)

### 지원 기능

#### 기본 계산

-   사칙연산 (+, -, ×, ÷)
-   괄호 연산
-   소수점 연산 (4자리 표시)

#### 공학 함수

-   **삼각함수**: sin, cos, tan, asin, acos, atan
-   **로그함수**: log, ln, log₂
-   **지수함수**: eˣ, 10ˣ, xʸ
-   **수학 상수**: π, e
-   **각도 단위**: 라디안(rad), 도(deg) 전환

#### 부가 기능

-   계산 히스토리 (최근 10개)
-   도움말 및 함수 설명
-   설정 저장 (각도 단위 등)

## 📱 화면 구성

이 앱은 **세로 모드 전용**으로 설계되어 학습 환경에서 일관된 사용 경험을 제공합니다.

### 메인 계산기 화면

```
┌─────────────────────────┐
│     Display Area        │ ← 계산식과 결과 표시
│    1234.5678           │
├─────────────────────────┤
│ C   ±   %   ÷          │ ← 기능 버튼
├─────────────────────────┤
│ 7   8   9   ×          │ ← 숫자 + 연산자
│ 4   5   6   -          │
│ 1   2   3   +          │
│   0     .   =          │
├─────────────────────────┤
│ sin cos tan π          │ ← 기본 공학 함수
│ ln  log e   rad/deg    │
├─────────────────────────┤
│ (   )  hist help       │ ← 유틸리티
└─────────────────────────┘
```

### 확장 기능 접근

-   **기본 공학 함수**: sin, cos, tan, ln, log, π, e
-   **확장 함수**: 버튼 길게 누르기로 접근 (asin, acos, atan, x², √x, eˣ, 10ˣ, xʸ)
-   **유틸리티**: 히스토리, 도움말, 각도 단위 전환

## 📂 프로젝트 구조

```
EngineeringCalculator/
├── Core/                 # 핵심 비즈니스 로직
│   ├── Engine/          # 계산 엔진
│   └── Storage/         # 데이터 저장
├── Features/            # 기능별 모듈
│   ├── Calculator/      # 메인 계산기
│   ├── History/         # 계산 히스토리
│   └── Help/           # 도움말
├── Shared/             # 공통 컴포넌트
│   ├── Models/         # 데이터 모델
│   ├── Extensions/     # 확장
│   └── Constants/      # 상수
└── Resources/          # 리소스
    ├── Colors/         # 색상 시스템
    └── Fonts/          # 폰트 시스템
```

## 🧪 테스트

이 프로젝트는 **TDD(Test-Driven Development)** 방식으로 개발됩니다.

-   **Swift Testing**: 주요 테스트 프레임워크
-   **XCTest**: UI 테스트용
-   **단위 테스트**: 모든 비즈니스 로직
-   **UI 테스트**: 주요 사용자 플로우

## 📋 문서

-   [📋 요구사항 정의](docs/requirements.md)
-   [📝 기능 명세서](docs/functional_specification.md)
-   [🏗️ 기술 아키텍처](docs/technical_architecture.md)
-   [✅ 개발 체크리스트](docs/development_checklist.md)
-   [🎨 와이어프레임](docs/wireframes/README.md)

## 🚀 시작하기

1. **프로젝트 클론**

    ```bash
    git clone [repository-url]
    cd engineering-calculator-ios
    ```

2. **Xcode에서 열기**

    ```bash
    open EngineeringCalculator.xcodeproj
    ```

3. **빌드 및 실행**
    - iOS 시뮬레이터에서 실행
    - 최소 요구사항: iOS 18.4
    - 권장 기기: iPhone 13 이상

## 🎯 타겟 사용자

-   **주요 사용자**: 중고등학생, 대학생
-   **사용 환경**: 수업 시간
-   **사용 빈도**: 매 수업 시간마다 사용
-   **핵심 가치**: 간단함, 직관성, 학습 지원

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

---

**Engineering Calculator iOS App** - Made with ❤️ and Cursor AI
