import SwiftUI

/// 공학용 계산기 메인 화면 (세로 모드 전용)
struct CalculatorView: View {
    @StateObject private var viewModel: CalculatorViewModel
    @State private var showHistory = false
    @State private var showHelp = false
    
    init(viewModel: CalculatorViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 디스플레이 영역
                displaySection
                    .frame(height: geometry.size.height * 0.3)
                
                // 버튼 영역
                buttonSection(geometry: geometry)
                    .frame(height: geometry.size.height * 0.7)
            }
        }
        .background(AppColors.background)
        .ignoresSafeArea(.all, edges: .bottom)
        .sheet(isPresented: $showHistory) {
            // TODO: HistoryView 구현 후 연결
            Text("History View")
        }
        .sheet(isPresented: $showHelp) {
            // TODO: HelpView 구현 후 연결
            Text("Help View")
        }
    }
    
    // MARK: - Display Section
    
    private var displaySection: some View {
        VStack(spacing: 0) {
            Spacer()
            
            DisplayView(
                expression: viewModel.currentExpression,
                result: viewModel.displayText,
                hasError: viewModel.hasError
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Button Section
    
    private func buttonSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 12) {
            // 유틸리티 버튼 행 ((, ), hist, help)
            utilityButtonRow(geometry: geometry)
            
            // 추가 공학 함수 버튼 행 (ln, log, e, rad/deg)
            advancedFunctionButtonRow(geometry: geometry)
            
            // 기본 공학 함수 버튼 행 (sin, cos, tan, π)
            basicFunctionButtonRow(geometry: geometry)
            
            // 기능 버튼 행 (C, ±, %, ÷)
            functionButtonRow(geometry: geometry)
            
            // 숫자 및 연산자 버튼 그리드
            numberAndOperatorGrid(geometry: geometry)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // MARK: - Button Rows
    
    /// 유틸리티 버튼 행 ((, ), hist, help)
    private func utilityButtonRow(geometry: GeometryProxy) -> some View {
        HStack(spacing: buttonSpacing(for: geometry)) {
            calculatorButton(.openParenthesis, geometry: geometry)
            calculatorButton(.closeParenthesis, geometry: geometry)
            calculatorButton(.history, geometry: geometry) {
                showHistory = true
            }
            calculatorButton(.help, geometry: geometry) {
                showHelp = true
            }
        }
    }
    
    /// 추가 공학 함수 버튼 행 (ln, log, e, rad/deg)
    private func advancedFunctionButtonRow(geometry: GeometryProxy) -> some View {
        HStack(spacing: buttonSpacing(for: geometry)) {
            calculatorButton(.ln, geometry: geometry)
            calculatorButton(.log, geometry: geometry)
            calculatorButton(.e, geometry: geometry)
            
            // 각도 단위 버튼 (동적 텍스트)
            Button {
                viewModel.toggleAngleUnit()
            } label: {
                Text(viewModel.angleUnitDisplayText)
                    .font(ButtonType.special.font)
                    .foregroundColor(ButtonType.special.textColor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ButtonType.special.backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .frame(
                width: buttonSize(for: geometry),
                height: buttonSize(for: geometry)
            )
        }
    }
    
    /// 기본 공학 함수 버튼 행 (sin, cos, tan, π)
    private func basicFunctionButtonRow(geometry: GeometryProxy) -> some View {
        HStack(spacing: buttonSpacing(for: geometry)) {
            calculatorButton(.sin, geometry: geometry)
            calculatorButton(.cos, geometry: geometry)
            calculatorButton(.tan, geometry: geometry)
            calculatorButton(.pi, geometry: geometry)
        }
    }
    
    /// 기능 버튼 행 (C, ±, %, ÷)
    private func functionButtonRow(geometry: GeometryProxy) -> some View {
        HStack(spacing: buttonSpacing(for: geometry)) {
            calculatorButton(.clear, geometry: geometry)
            calculatorButton(.plusMinus, geometry: geometry)
            calculatorButton(.percent, geometry: geometry)
            calculatorButton(.divide, geometry: geometry)
        }
    }
    
    /// 숫자 및 연산자 버튼 그리드
    private func numberAndOperatorGrid(geometry: GeometryProxy) -> some View {
        VStack(spacing: 12) {
            // 7, 8, 9, ×
            HStack(spacing: buttonSpacing(for: geometry)) {
                calculatorButton(.seven, geometry: geometry)
                calculatorButton(.eight, geometry: geometry)
                calculatorButton(.nine, geometry: geometry)
                calculatorButton(.multiply, geometry: geometry)
            }
            
            // 4, 5, 6, -
            HStack(spacing: buttonSpacing(for: geometry)) {
                calculatorButton(.four, geometry: geometry)
                calculatorButton(.five, geometry: geometry)
                calculatorButton(.six, geometry: geometry)
                calculatorButton(.subtract, geometry: geometry)
            }
            
            // 1, 2, 3, +
            HStack(spacing: buttonSpacing(for: geometry)) {
                calculatorButton(.one, geometry: geometry)
                calculatorButton(.two, geometry: geometry)
                calculatorButton(.three, geometry: geometry)
                calculatorButton(.add, geometry: geometry)
            }
            
            // 0, ., =
            HStack(spacing: buttonSpacing(for: geometry)) {
                calculatorButton(.zero, geometry: geometry)
                    .frame(width: buttonSize(for: geometry) * 2 + buttonSpacing(for: geometry))
                calculatorButton(.decimal, geometry: geometry)
                calculatorButton(.equals, geometry: geometry)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// 계산기 버튼 생성
    private func calculatorButton(_ button: CalculatorButton, geometry: GeometryProxy, customAction: (() -> Void)? = nil) -> some View {
        CalculatorButtonView(button: button) {
            if let customAction = customAction {
                customAction()
            } else {
                viewModel.handleButtonPress(button)
            }
        }
        .frame(
            width: buttonSize(for: geometry),
            height: buttonSize(for: geometry)
        )
        .contextMenu {
            // 길게 누르기 시 확장 기능 메뉴
            contextMenuItems(for: button)
        }
    }
    
    /// 버튼 크기 계산 (반응형)
    private func buttonSize(for geometry: GeometryProxy) -> CGFloat {
        let screenWidth = geometry.size.width
        let padding: CGFloat = 40 // 좌우 패딩
        let spacing: CGFloat = buttonSpacing(for: geometry)
        let availableWidth = screenWidth - padding - (spacing * 3) // 4개 버튼 간 3개 간격
        return availableWidth / 4
    }
    
    /// 버튼 간격 계산
    private func buttonSpacing(for geometry: GeometryProxy) -> CGFloat {
        let screenWidth = geometry.size.width
        return screenWidth > 400 ? 16 : 12
    }
    
    /// 컨텍스트 메뉴 아이템들 (확장 기능)
    @ViewBuilder
    private func contextMenuItems(for button: CalculatorButton) -> some View {
        switch button {
        case .sin:
            Button("asin") { viewModel.handleButtonPress(.asin) }
        case .cos:
            Button("acos") { viewModel.handleButtonPress(.acos) }
        case .tan:
            Button("atan") { viewModel.handleButtonPress(.atan) }
        case .two:
            Button("x²") { viewModel.handleSquare() }
        case .ln:
            Button("log₂") { viewModel.handleButtonPress(.log2) }
        case .log:
            Button("10ˣ") { viewModel.handleButtonPress(.pow10) }
        case .e:
            Button("eˣ") { viewModel.handleButtonPress(.exp) }
        case .pi:
            Button("√x") { viewModel.handleButtonPress(.sqrt) }
        default:
            EmptyView()
        }
    }
}

// MARK: - Preview

#Preview("Calculator View") {
    NavigationView {
        CalculatorView(
            viewModel: CalculatorViewModel(
                calculatorEngine: ScientificCalculatorEngine(),
                settingsStorage: UserDefaultsSettingsStorage(),
                historyStorage: InMemoryHistoryStorage()
            )
        )
    }
    .preferredColorScheme(.light)
}

#Preview("Calculator View Dark") {
    NavigationView {
        CalculatorView(
            viewModel: CalculatorViewModel(
                calculatorEngine: ScientificCalculatorEngine(),
                settingsStorage: UserDefaultsSettingsStorage(),
                historyStorage: InMemoryHistoryStorage()
            )
        )
    }
    .preferredColorScheme(.dark)
} 