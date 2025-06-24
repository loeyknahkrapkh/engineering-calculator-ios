import SwiftUI

/// 함수 도움말 팝업 뷰
struct FunctionHelpPopup: View {
    let functionDescription: FunctionDescription
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 함수 제목
            HStack {
                Text(functionDescription.symbol)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(functionDescription.category.displayName)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
            
            // 함수 설명
            Text(functionDescription.description)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            // 사용 예시
            if !functionDescription.example.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("사용 예시:")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    Text(functionDescription.example)
                        .font(.system(.body, design: .monospaced))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .frame(maxWidth: 280)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        FunctionHelpPopup(
            functionDescription: FunctionDescription(
                functionName: "사인 함수",
                symbol: "sin",
                description: "사인 함수입니다. 주어진 각도의 사인 값을 계산합니다.",
                usage: "sin(30) = 0.5",
                example: "sin(30°) = 0.5\nsin(π/6) = 0.5",
                category: .trigonometric
            )
        )
        
        FunctionHelpPopup(
            functionDescription: FunctionDescription(
                functionName: "자연로그",
                symbol: "ln",
                description: "자연로그 함수입니다. 밑이 e인 로그값을 계산합니다.",
                usage: "ln(e) = 1",
                example: "ln(e) = 1\nln(1) = 0",
                category: .logarithmic
            )
        )
    }
    .padding()
    .background(Color(.systemGray5))
} 