import SwiftUI

/// 계산기 디스플레이 UI 컴포넌트
struct DisplayView: View {
    let expression: String
    let result: String
    let hasError: Bool
    
    @State private var expressionTextSize: CGFloat = 24
    @State private var resultTextSize: CGFloat = 48
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            // 수식 표시 영역
            HStack {
                Spacer()
                Text(expression.isEmpty ? " " : expression)
                    .font(.system(size: expressionTextSize, weight: .regular, design: .monospaced))
                    .foregroundColor(AppColors.Text.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.trailing)
                    .background(
                        // 텍스트 크기 측정을 위한 숨겨진 뷰
                        Text(expression.isEmpty ? " " : expression)
                            .font(.system(size: 24, weight: .regular, design: .monospaced))
                            .opacity(0)
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .onAppear {
                                            adjustExpressionTextSize(for: geometry.size)
                                        }
                                        .onChange(of: expression) { _, _ in
                                            adjustExpressionTextSize(for: geometry.size)
                                        }
                                }
                            )
                    )
            }
            .frame(minHeight: 80)
            
            // 결과 표시 영역
            HStack {
                Spacer()
                Text(result.isEmpty ? "0" : result)
                    .font(.system(size: resultTextSize, weight: .light, design: .monospaced))
                    .foregroundColor(hasError ? AppColors.Text.error : AppColors.Text.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.trailing)
                    .background(
                        // 텍스트 크기 측정을 위한 숨겨진 뷰
                        Text(result.isEmpty ? "0" : result)
                            .font(.system(size: 48, weight: .light, design: .monospaced))
                            .opacity(0)
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .onAppear {
                                            adjustResultTextSize(for: geometry.size)
                                        }
                                        .onChange(of: result) { _, _ in
                                            adjustResultTextSize(for: geometry.size)
                                        }
                                }
                            )
                    )
            }
            .frame(minHeight: 100)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: AppColors.Shadow.light, radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Private Methods
    
    /// 수식 텍스트 크기 자동 조정
    private func adjustExpressionTextSize(for size: CGSize) {
        let text = expression.isEmpty ? " " : expression
        let maxWidth = size.width - 40 // 패딩 고려
        let maxHeight: CGFloat = 80
        
        var fontSize: CGFloat = 24
        
        while fontSize > 12 {
            let font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
            let attributes = [NSAttributedString.Key.font: font]
            let textSize = (text as NSString).boundingRect(
                with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: attributes,
                context: nil
            ).size
            
            if textSize.width <= maxWidth && textSize.height <= maxHeight {
                break
            }
            
            fontSize -= 1
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            expressionTextSize = fontSize
        }
    }
    
    /// 결과 텍스트 크기 자동 조정
    private func adjustResultTextSize(for size: CGSize) {
        let text = result.isEmpty ? "0" : result
        let maxWidth = size.width - 40 // 패딩 고려
        let maxHeight: CGFloat = 100
        
        var fontSize: CGFloat = 48
        
        while fontSize > 20 {
            let font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .light)
            let attributes = [NSAttributedString.Key.font: font]
            let textSize = (text as NSString).boundingRect(
                with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: attributes,
                context: nil
            ).size
            
            if textSize.width <= maxWidth && textSize.height <= maxHeight {
                break
            }
            
            fontSize -= 2
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            resultTextSize = fontSize
        }
    }
}

// MARK: - Preview

#Preview("Display States") {
    VStack(spacing: 20) {
        // 기본 상태
        DisplayView(
            expression: "",
            result: "",
            hasError: false
        )
        .frame(height: 200)
        
        // 계산 중 상태
        DisplayView(
            expression: "sin(30) + cos(45) × 2",
            result: "1.914",
            hasError: false
        )
        .frame(height: 200)
        
        // 긴 수식 상태
        DisplayView(
            expression: "sin(30) + cos(45) × tan(60) + ln(10) / log(100) + sqrt(25)",
            result: "12.345678901234567890",
            hasError: false
        )
        .frame(height: 200)
        
        // 에러 상태
        DisplayView(
            expression: "1 ÷ 0",
            result: "Error: Division by zero",
            hasError: true
        )
        .frame(height: 200)
    }
    .padding()
    .background(Color(.systemGray6))
}

#Preview("Single Display") {
    DisplayView(
        expression: "2 + 3 × 4",
        result: "14",
        hasError: false
    )
    .frame(height: 200)
    .padding()
} 