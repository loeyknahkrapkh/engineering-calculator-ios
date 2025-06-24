import SwiftUI

/// 히스토리 목록의 개별 행을 표시하는 뷰
struct HistoryRowView: View {
    // MARK: - Properties
    
    let history: CalculationHistory
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 상단: 계산식과 시간
            HStack {
                Text(history.expression)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Text(history.relativeTimeString)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // 하단: 결과
            HStack {
                Spacer()
                
                Text(history.formattedResult)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(history.hasError ? .red : .primary)
                    .lineLimit(1)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Preview

#Preview("일반 계산") {
    HistoryRowView(
        history: CalculationHistory(expression: "2 + 3 × 4", result: 14.0)
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview("공학 함수") {
    HistoryRowView(
        history: CalculationHistory(expression: "sin(π/2)", result: 1.0)
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview("에러 상태") {
    HistoryRowView(
        history: CalculationHistory(expression: "1/0", error: "Division by zero")
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview("긴 수식") {
    HistoryRowView(
        history: CalculationHistory(
            expression: "sin(cos(tan(π/4))) + log(e^2) - √(16)",
            result: 1.2345
        )
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview("큰 숫자") {
    HistoryRowView(
        history: CalculationHistory(expression: "10^8", result: 100000000.0)
    )
    .padding()
    .background(Color(.systemGroupedBackground))
} 