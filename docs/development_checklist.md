# 공학용 계산기 iOS 앱 개발 체크리스트

## 📋 프로젝트 개요

-   **목표**: 학생용 공학용 계산기 iOS 앱 개발
-   **기술 스택**: Swift 6.0, SwiftUI, iOS 18.4+
-   **아키텍처**: MVVM + Protocol Oriented Programming

---

## Phase 1: 프로젝트 설정 및 기본 구조

### 1.1 프로젝트 초기 설정

-   [x] Xcode 프로젝트 생성 (iOS 18.4 minimum deployment target)
-   [x] Bundle Identifier 설정 (`com.demo.EngineeringCalculator`)
-   [x] SwiftUI 기본 템플릿 확인
-   [x] .gitignore 파일 생성
-   [x] 프로젝트 폴더 구조 생성
    -   [x] `Features/` 폴더 생성 (Calculator, History, Help)
    -   [x] `Core/` 폴더 생성 (Engine, Storage)
    -   [x] `Shared/` 폴더 생성 (Models, Extensions, Constants)
    -   [x] `Resources/` 폴더 생성 (Colors, Fonts)
-   [x] 각 폴더별 README 파일 생성

**🔄 Commit Point**: `feat: 초기 프로젝트 설정 및 폴더 구조 생성`

### 1.2 기본 모델 생성

-   [x] `CalculatorButton` enum 구현
-   [x] `CalculatorSettings` struct 구현
-   [x] `CalculationHistory` struct 구현
-   [x] `AngleUnit` enum 구현
-   [x] 기본 상수 정의 (`AppConstants.swift`)

**🔄 Commit Point**: `feat: 기본 데이터 모델 및 상수 정의`

---

## Phase 2: 핵심 계산 엔진 개발

### 2.1 계산 엔진 프로토콜 및 기본 구조

-   [x] `CalculatorEngine` protocol 정의
-   [x] `ExpressionParser` 클래스 기본 구조 생성
-   [x] `MathFunctions` 클래스 기본 구조 생성
-   [x] `ScientificCalculatorEngine` 클래스 기본 구조 생성

**🔄 Commit Point**: `feat: 계산 엔진 기본 구조 및 프로토콜 정의`

### 2.2 수식 파서 구현

-   [x] 토큰화(Tokenization) 로직 구현
-   [x] 중위 표기법을 후위 표기법으로 변환 (Shunting Yard Algorithm)
-   [x] 후위 표기법 계산 로직 구현
-   [x] 괄호 처리 로직 구현
-   [x] 연산자 우선순위 정의

**🔄 Commit Point**: `feat: 수식 파서 및 계산 로직 구현`

### 2.3 수학 함수 구현

-   [x] 기본 사칙연산 (+, -, ×, ÷) 구현
-   [x] 삼각함수 (sin, cos, tan) 구현
-   [x] 역삼각함수 (asin, acos, atan) 구현
-   [x] 로그함수 (ln, log, log₂) 구현
-   [x] 지수함수 (eˣ, 10ˣ, xʸ) 구현
-   [x] 수학 상수 (π, e) 구현
-   [x] 각도 단위 변환 (degree ↔ radian) 구현

**🔄 Commit Point**: `feat: 수학 함수 및 공학 계산 기능 구현`

### 2.4 에러 처리 및 유효성 검증

-   [x] 0으로 나누기 에러 처리
-   [x] 정의역 벗어남 에러 처리 (log 음수, asin 범위 초과 등)
-   [x] 오버플로우/언더플로우 처리
-   [x] 잘못된 수식 입력 처리
-   [x] 결과 포맷팅 (소수점 4자리)

**🔄 Commit Point**: `feat: 에러 처리 및 결과 포맷팅 구현`

---

## Phase 3: 데이터 저장소 구현

### 3.1 설정 저장소 구현

-   [x] `SettingsStorage` protocol 정의
-   [x] `UserDefaultsSettingsStorage` 클래스 구현
-   [x] 각도 단위 설정 저장/로드
-   [x] 소수점 자릿수 설정 저장/로드
-   [x] 첫 실행 여부 저장/로드

**🔄 Commit Point**: `feat: 설정 저장소 구현`

### 3.2 히스토리 저장소 구현

-   [x] `HistoryStorage` protocol 정의
-   [x] `InMemoryHistoryStorage` 클래스 구현 (개발용)
-   [x] 계산 히스토리 저장 기능
-   [x] 최근 N개 히스토리 로드 기능
-   [x] 히스토리 삭제 기능
-   [x] 전체 히스토리 삭제 기능

**🔄 Commit Point**: `feat: 히스토리 저장소 구현`

---

## Phase 4: UI 컴포넌트 개발

### 4.1 기본 UI 컴포넌트

-   [ ] `CalculatorButtonView` 구현
    -   [ ] 버튼 스타일링 (Rounded Rectangle)
    -   [ ] 색상 구분 (숫자, 연산자, 함수별)
    -   [ ] 터치 피드백 구현
-   [ ] `DisplayView` 구현
    -   [ ] 수식 표시 영역
    -   [ ] 결과 표시 영역
    -   [ ] 텍스트 크기 자동 조정

**🔄 Commit Point**: `feat: 기본 UI 컴포넌트 구현`

### 4.2 색상 및 폰트 시스템

-   [ ] `Colors.swift` 파일 생성
-   [ ] 버튼별 색상 정의
-   [ ] 다크/라이트 모드 색상 정의
-   [ ] `Fonts.swift` 파일 생성
-   [ ] SF Pro Display, SF Mono 폰트 설정

**🔄 Commit Point**: `feat: 디자인 시스템 (색상, 폰트) 구현`

---

## Phase 5: ViewModel 구현

### 5.1 Calculator ViewModel

-   [ ] `CalculatorViewModel` 클래스 기본 구조
-   [ ] `@Published` 속성들 정의
    -   [ ] `displayText`
    -   [ ] `currentExpression`
    -   [ ] `isNewNumber`
    -   [ ] `settings`
-   [ ] 버튼 입력 처리 로직
-   [ ] 숫자 입력 처리
-   [ ] 연산자 입력 처리
-   [ ] 함수 입력 처리
-   [ ] 계산 실행 및 결과 처리

**🔄 Commit Point**: `feat: Calculator ViewModel 기본 기능 구현`

### 5.2 History ViewModel

-   [ ] `HistoryViewModel` 클래스 구현
-   [ ] 히스토리 로드 기능
-   [ ] 히스토리 삭제 기능
-   [ ] 히스토리 항목 선택 기능

**🔄 Commit Point**: `feat: History ViewModel 구현`

### 5.3 Help ViewModel

-   [ ] `HelpViewModel` 클래스 구현
-   [ ] 함수 설명 데이터 관리
-   [ ] 팁 데이터 관리

**🔄 Commit Point**: `feat: Help ViewModel 구현`

---

## Phase 6: 메인 화면 구현

### 6.1 세로 모드 계산기 화면

-   [ ] `CalculatorView` 기본 구조 생성
-   [ ] 디스플레이 영역 레이아웃
-   [ ] 기능 버튼 행 (C, ±, %, ÷) 구현
-   [ ] 숫자 버튼 그리드 구현
-   [ ] 연산자 버튼 구현
-   [ ] 공학 함수 버튼 행 구현
-   [ ] 버튼 액션 연결

**🔄 Commit Point**: `feat: 세로 모드 계산기 화면 구현`

### 6.2 가로 모드 계산기 화면

-   [ ] 가로 모드 레이아웃 구현
-   [ ] 확장된 공학 함수 버튼들 추가
-   [ ] 역삼각함수 버튼 추가
-   [ ] 추가 수학 함수 버튼 추가
-   [ ] 유틸리티 버튼 (hist, help, unit) 추가
-   [ ] 방향 전환 시 레이아웃 자동 조정

**🔄 Commit Point**: `feat: 가로 모드 계산기 화면 구현`

### 6.3 반응형 레이아웃

-   [ ] `GeometryReader`를 사용한 동적 크기 조정
-   [ ] 다양한 iPhone 크기 대응
-   [ ] Safe Area 처리
-   [ ] 버튼 크기 자동 조정

**🔄 Commit Point**: `feat: 반응형 레이아웃 및 다기기 대응`

---

## Phase 7: 히스토리 화면 구현

### 7.1 히스토리 리스트 화면

-   [ ] `HistoryView` 기본 구조 생성
-   [ ] 네비게이션 바 구현
-   [ ] 히스토리 리스트 구현
-   [ ] `HistoryRowView` 컴포넌트 구현
-   [ ] 계산식 및 결과 표시
-   [ ] 시간 표시 (상대적 시간)

**🔄 Commit Point**: `feat: 히스토리 리스트 화면 구현`

### 7.2 히스토리 기능

-   [ ] 히스토리 항목 재사용 기능
-   [ ] 전체 히스토리 삭제 기능
-   [ ] 빈 상태 화면 구현
-   [ ] 스와이프 제스처로 삭제 기능

**🔄 Commit Point**: `feat: 히스토리 상호작용 기능 구현`

---

## Phase 8: 도움말 화면 구현

### 8.1 도움말 컨텐츠 화면

-   [ ] `HelpView` 기본 구조 생성
-   [ ] 스크롤 가능한 컨텐츠 영역
-   [ ] 섹션별 함수 설명 구현
-   [ ] 사용 예시 표시
-   [ ] 팁 섹션 구현

**🔄 Commit Point**: `feat: 도움말 화면 구현`

### 8.2 상호작용 도움말

-   [ ] 함수 버튼 길게 누르기 기능
-   [ ] 팝업 형태의 함수 설명
-   [ ] 일일 팁 표시 기능

**🔄 Commit Point**: `feat: 상호작용 도움말 기능 구현`

---

## Phase 9: 네비게이션 및 통합

### 9.1 화면 간 네비게이션

-   [ ] Sheet를 사용한 모달 화면 구현
-   [ ] 히스토리 화면 네비게이션
-   [ ] 도움말 화면 네비게이션
-   [ ] 뒤로가기 기능 구현

**🔄 Commit Point**: `feat: 화면 간 네비게이션 구현`

### 9.2 앱 상태 관리

-   [ ] 앱 생명주기 관리
-   [ ] 백그라운드/포그라운드 전환 처리
-   [ ] 설정 자동 저장
-   [ ] 메모리 관리 최적화

**🔄 Commit Point**: `feat: 앱 상태 관리 및 생명주기 처리`

---

## Phase 10: 테스트 구현

### 10.1 Unit Tests

-   [ ] `CalculatorEngineTests` 구현
    -   [ ] 기본 사칙연산 테스트
    -   [ ] 삼각함수 테스트
    -   [ ] 로그함수 테스트
    -   [ ] 에러 처리 테스트
-   [ ] `ExpressionParserTests` 구현
-   [ ] `MathFunctionsTests` 구현
-   [ ] `ViewModelTests` 구현

**🔄 Commit Point**: `test: Unit Tests 구현`

### 10.2 UI Tests

-   [ ] `CalculatorUITests` 구현
    -   [ ] 기본 계산 시나리오 테스트
    -   [ ] 공학 함수 사용 테스트
    -   [ ] 히스토리 기능 테스트
    -   [ ] 도움말 기능 테스트
-   [ ] 접근성 테스트
-   [ ] 다양한 기기 크기 테스트

**🔄 Commit Point**: `test: UI Tests 및 접근성 테스트 구현`

---

## Phase 11: 성능 최적화 및 버그 수정

### 11.1 성능 최적화

-   [ ] 계산 성능 최적화
-   [ ] UI 렌더링 최적화
-   [ ] 메모리 사용량 최적화
-   [ ] 배터리 사용량 최적화
-   [ ] 앱 시작 시간 최적화

**🔄 Commit Point**: `perf: 성능 최적화 구현`

### 11.2 버그 수정 및 예외 처리

-   [ ] 크래시 방지 로직 추가
-   [ ] 경계값 테스트 및 수정
-   [ ] 메모리 누수 확인 및 수정
-   [ ] 사용자 입력 검증 강화

**🔄 Commit Point**: `fix: 버그 수정 및 안정성 개선`

---

## Phase 12: 최종 검증 및 배포 준비

### 12.1 최종 테스트

-   [ ] 전체 기능 통합 테스트
-   [ ] 다양한 기기에서 테스트
-   [ ] 성능 벤치마크 테스트
-   [ ] 사용성 테스트

**🔄 Commit Point**: `test: 최종 통합 테스트 완료`

### 12.2 배포 준비

-   [ ] 앱 아이콘 설정
-   [ ] Launch Screen 구현
-   [ ] 앱 메타데이터 설정
-   [ ] 프로젝트 설정 최종 검토
-   [ ] 릴리스 노트 작성

**🔄 Commit Point**: `release: v1.0.0 배포 준비 완료`

---

## 📝 추가 고려사항

### 향후 버전 개발 (Optional)

-   [ ] 다크 모드 지원
-   [ ] 단위 변환 기능 확장
-   [ ] 추가 수학 함수 (팩토리얼, 조합, 순열 등)
-   [ ] 그래프 기능
-   [ ] Apple Watch 앱
-   [ ] 위젯 지원

### 문서화

-   [ ] API 문서 작성
-   [ ] 사용자 가이드 작성
-   [ ] 개발자 문서 업데이트
-   [ ] README 파일 업데이트

---

## ✅ 체크리스트 사용 가이드

1. **순차적 진행**: 각 Phase를 순서대로 완료
2. **Commit 규칙**: 각 Commit Point에서 반드시 커밋
3. **테스트**: 각 기능 구현 후 즉시 테스트
4. **코드 리뷰**: 주요 기능 완료 시 코드 리뷰 진행
5. **문서 업데이트**: 기능 변경 시 관련 문서 업데이트

**예상 개발 기간**: 4-6주 (1인 개발 기준)
