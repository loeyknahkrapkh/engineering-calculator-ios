import SwiftUI

/// 공학용 계산기 메인 화면 (세로 모드 전용)
struct CalculatorView: View {
    @StateObject private var viewModel: CalculatorViewModel
    let appContainer: AppContainer
    @State private var showHistory = false
    @State private var showHelp = false
    @State private var showFunctionPopup = false
    @State private var selectedFunctionDescription: FunctionDescription?
    @State private var showDailyTip = false
    @State private var dailyTip: CalculatorTip?
    
    init(viewModel: CalculatorViewModel, appContainer: AppContainer) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.appContainer = appContainer
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    // 상단 여백
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 20)
                    
                    // 일일 팁 배너
                    if showDailyTip, let tip = dailyTip {
                        DailyTipBanner(
                            tip: tip,
                            onDismiss: {
                                withAnimation {
                                    showDailyTip = false
                                }
                            },
                            onOpenHelp: {
                                showHelp = true
                            }
                        )
                        .padding(.horizontal, 20)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // 디스플레이 영역
                    displaySection
                        .padding(.horizontal, 20) // 디스플레이와 버튼 영역 동일한 패딩
                    
                    // 버튼 영역
                    buttonSection(geometry: geometry)
                        .padding(.horizontal, 20) // 디스플레이와 버튼 영역 동일한 패딩
                }
                
                // 함수 설명 팝업
                if showFunctionPopup, let description = selectedFunctionDescription {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showFunctionPopup = false
                            }
                        }
                    
                    VStack {
                        Spacer()
                        FunctionHelpPopup(functionDescription: description)
                            .padding(.horizontal, 40)
                        Spacer()
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .background(AppColors.background)
        .onAppear {
            checkForDailyTip()
        }
        .sheet(isPresented: $showHistory) {
            let historyViewModel = appContainer.makeHistoryViewModel()
            NavigationView {
                HistoryView(
                    viewModel: historyViewModel,
                    onHistorySelected: { expression in
                        viewModel.loadExpressionFromHistory(expression)
                        showHistory = false
                    }
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("완료") {
                            showHistory = false
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showHelp) {
            let helpViewModel = appContainer.makeHelpViewModel()
            NavigationView {
                HelpView(viewModel: helpViewModel)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("완료") {
                                showHelp = false
                            }
                        }
                    }
            }
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
            .padding(.bottom, 20)
        }
        .frame(height: showDailyTip ? 180 : 200)
    }
    
    // MARK: - Button Section
    
    private func buttonSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: buttonSpacing(geometry)) {
                // 유틸리티 버튼 행 ((, ), hist, help)
                utilityButtonRow(geometry)
                
                // 추가 공학 함수 버튼 행 (ln, log, e, rad/deg)
                advancedFunctionButtonRow(geometry)
                
                // 기본 공학 함수 버튼 행 (sin, cos, tan, π)
                basicFunctionButtonRow(geometry)
                
                // 기능 버튼 행 (C, ±, %, ÷)
                functionButtonRow(geometry)
                
                // 숫자 및 연산자 버튼 그리드
                numberAndOperatorGrid(geometry)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0) // 남은 공간 차지
        }
        .padding(.bottom, geometry.safeAreaInsets.bottom + 10)
    }
    
    // MARK: - Button Rows
    
    /// 유틸리티 버튼 행 ((, ), hist, help)
    private func utilityButtonRow(_ geometry: GeometryProxy) -> some View {
        HStack(spacing: buttonSpacing(geometry)) {
            calculatorButton(.openParenthesis, geometry)
            calculatorButton(.closeParenthesis, geometry)
            calculatorButton(.history, geometry) {
                showHistory = true
            }
            calculatorButton(.help, geometry) {
                showHelp = true
            }
        }
    }
    
    /// 추가 공학 함수 버튼 행 (ln, log, e, rad/deg)
    private func advancedFunctionButtonRow(_ geometry: GeometryProxy) -> some View {
        HStack(spacing: buttonSpacing(geometry)) {
            calculatorButton(.ln, geometry)
            calculatorButton(.log, geometry)
            calculatorButton(.e, geometry)
            
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
            .frame(width: buttonWidth(geometry), height: buttonHeight(geometry))
        }
    }
    
    /// 기본 공학 함수 버튼 행 (sin, cos, tan, π)
    private func basicFunctionButtonRow(_ geometry: GeometryProxy) -> some View {
        HStack(spacing: buttonSpacing(geometry)) {
            calculatorButton(.sin, geometry)
            calculatorButton(.cos, geometry)
            calculatorButton(.tan, geometry)
            calculatorButton(.pi, geometry)
        }
    }
    
    /// 기능 버튼 행 (C, ±, %, ÷)
    private func functionButtonRow(_ geometry: GeometryProxy) -> some View {
        HStack(spacing: buttonSpacing(geometry)) {
            calculatorButton(.clear, geometry)
            calculatorButton(.plusMinus, geometry)
            calculatorButton(.percent, geometry)
            calculatorButton(.divide, geometry)
        }
    }
    
    /// 숫자 및 연산자 버튼 그리드
    private func numberAndOperatorGrid(_ geometry: GeometryProxy) -> some View {
        VStack(spacing: buttonSpacing(geometry)) {
            // 7, 8, 9, ×
            HStack(spacing: buttonSpacing(geometry)) {
                calculatorButton(.seven, geometry)
                calculatorButton(.eight, geometry)
                calculatorButton(.nine, geometry)
                calculatorButton(.multiply, geometry)
            }
            
            // 4, 5, 6, -
            HStack(spacing: buttonSpacing(geometry)) {
                calculatorButton(.four, geometry)
                calculatorButton(.five, geometry)
                calculatorButton(.six, geometry)
                calculatorButton(.subtract, geometry)
            }
            
            // 1, 2, 3, +
            HStack(spacing: buttonSpacing(geometry)) {
                calculatorButton(.one, geometry)
                calculatorButton(.two, geometry)
                calculatorButton(.three, geometry)
                calculatorButton(.add, geometry)
            }
            
            // 0, ., =
            HStack(spacing: buttonSpacing(geometry)) {
                calculatorButton(.zero, geometry)
                    .frame(width: buttonWidth(geometry) * 2 + buttonSpacing(geometry))
                calculatorButton(.decimal, geometry)
                calculatorButton(.equals, geometry)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// 계산기 버튼 생성
    private func calculatorButton(_ button: CalculatorButton, _ geometry: GeometryProxy, customAction: (() -> Void)? = nil) -> some View {
        CalculatorButtonView(button: button) {
            if let customAction = customAction {
                customAction()
            } else {
                viewModel.handleButtonPress(button)
            }
        }
        .frame(width: buttonWidth(geometry), height: buttonHeight(geometry))
        .onLongPressGesture {
            // 길게 누르기 시 함수 설명 표시
            showFunctionDescription(for: button)
        }
        .contextMenu {
            // 길게 누르기 시 확장 기능 메뉴
            contextMenuItems(for: button)
        }
    }
    
    /// 버튼 높이 계산 (화면 크기에 따른 동적 계산)
    private func buttonHeight(_ geometry: GeometryProxy) -> CGFloat {
        // 사용 가능한 높이 계산
        let displayHeight: CGFloat = showDailyTip ? 180 : 200
        let topMargin: CGFloat = 20
        let bottomMargin = geometry.safeAreaInsets.bottom + 10
        let verticalPadding: CGFloat = 40 // 버튼 영역 상하 패딩
        let tipHeight: CGFloat = showDailyTip ? 80 : 0 // 일일 팁 높이
        let availableHeight = geometry.size.height - displayHeight - topMargin - bottomMargin - verticalPadding - tipHeight
        
        let numberOfRows: CGFloat = 8 // 총 8행
        let totalSpacing = buttonSpacing(geometry) * (numberOfRows - 1)
        let buttonHeight = (availableHeight - totalSpacing) / numberOfRows
        
        // 최소/최대 높이 보장
        return max(45, min(buttonHeight, 75))
    }
    
    /// 버튼 가로 크기 계산 (사용 가능한 가로 공간을 4등분)
    private func buttonWidth(_ geometry: GeometryProxy) -> CGFloat {
        // 사용 가능한 가로 크기 계산 (외부 패딩 40pt 제외)
        let contentWidth = geometry.size.width - 40 // 20pt씩 좌우 패딩
        let totalSpacingWidth = buttonSpacing(geometry) * 3 // 4개 버튼 간 3개 간격
        return (contentWidth - totalSpacingWidth) / 4
    }
    
    /// 버튼 간격 계산
    private func buttonSpacing(_ geometry: GeometryProxy) -> CGFloat {
        let screenWidth = geometry.size.width
        if screenWidth > 428 { // iPhone Pro Max
            return 14
        } else if screenWidth > 390 { // iPhone Pro
            return 12
        } else {
            return 10
        }
    }
    
    /// 함수 설명 표시
    private func showFunctionDescription(for button: CalculatorButton) {
        if let description = viewModel.getFunctionDescription(for: button) {
            selectedFunctionDescription = description
            withAnimation(.easeInOut(duration: 0.3)) {
                showFunctionPopup = true
            }
        }
    }
    
    /// 일일 팁 확인 및 표시
    private func checkForDailyTip() {
        if viewModel.shouldShowDailyTip() {
            dailyTip = viewModel.getDailyTip()
            if dailyTip != nil {
                withAnimation(.easeInOut(duration: 0.5).delay(1.0)) {
                    showDailyTip = true
                }
            }
        }
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
    let container = AppContainer()
    NavigationView {
        CalculatorView(
            viewModel: container.calculatorViewModel,
            appContainer: container
        )
    }
    .preferredColorScheme(.light)
}

#Preview("Calculator View Dark") {
    let container = AppContainer()
    NavigationView {
        CalculatorView(
            viewModel: container.calculatorViewModel,
            appContainer: container
        )
    }
    .preferredColorScheme(.dark)
} 