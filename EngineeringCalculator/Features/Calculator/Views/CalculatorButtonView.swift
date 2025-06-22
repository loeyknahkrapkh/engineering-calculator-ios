import SwiftUI

/// 계산기 버튼 UI 컴포넌트
struct CalculatorButtonView: View {
    let button: CalculatorButton
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // 햅틱 피드백
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            action()
        }) {
            Text(button.displayText)
                .font(buttonFont)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: buttonCornerRadius))
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.01, perform: {
            // 길게 누르기 완료 (현재는 일반 클릭과 동일)
        }, onPressingChanged: { pressing in
            // 누르기 상태 변경
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        })
    }
    
    // MARK: - Private Properties
    
    /// 버튼 폰트
    private var buttonFont: Font {
        switch button.buttonType {
        case .number, .operator:
            return .system(size: 28, weight: .medium, design: .default)
        case .function:
            return .system(size: 16, weight: .medium, design: .default)
        case .constant:
            return .system(size: 24, weight: .medium, design: .default)
        case .utility, .special:
            return .system(size: 20, weight: .medium, design: .default)
        }
    }
    
    /// 텍스트 색상
    private var textColor: Color {
        switch button.buttonType {
        case .number, .utility:
            return .primary
        case .operator:
            return .white
        case .function, .constant:
            return .primary
        case .special:
            return .blue
        }
    }
    
    /// 배경 색상
    private var backgroundColor: Color {
        switch button.buttonType {
        case .number:
            return Color(.systemGray5)
        case .operator:
            return .orange
        case .function, .constant:
            return Color(.systemGray4)
        case .utility:
            return Color(.systemGray3)
        case .special:
            return Color(.systemBlue).opacity(0.1)
        }
    }
    
    /// 버튼 모서리 반지름
    private var buttonCornerRadius: CGFloat {
        12
    }
}

// MARK: - Preview

#Preview("Calculator Button Types") {
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            CalculatorButtonView(button: .one) {}
                .frame(width: 80, height: 80)
            CalculatorButtonView(button: .add) {}
                .frame(width: 80, height: 80)
            CalculatorButtonView(button: .sin) {}
                .frame(width: 80, height: 80)
        }
        
        HStack(spacing: 12) {
            CalculatorButtonView(button: .pi) {}
                .frame(width: 80, height: 80)
            CalculatorButtonView(button: .clear) {}
                .frame(width: 80, height: 80)
            CalculatorButtonView(button: .history) {}
                .frame(width: 80, height: 80)
        }
    }
    .padding()
}

#Preview("Single Button") {
    CalculatorButtonView(button: .multiply) {
        print("Multiply tapped")
    }
    .frame(width: 80, height: 80)
    .padding()
} 