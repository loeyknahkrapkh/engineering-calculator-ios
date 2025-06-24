import SwiftUI

/// 일일 팁 배너 뷰
struct DailyTipBanner: View {
    let tip: CalculatorTip
    let onDismiss: () -> Void
    let onOpenHelp: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.orange)
                
                Text("오늘의 팁")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(tip.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text(tip.content)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Text(tip.category.displayName)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(tip.difficulty.color.opacity(0.2))
                    .foregroundColor(tip.difficulty.color)
                    .cornerRadius(4)
                
                Spacer()
                
                Button("더보기") {
                    onOpenHelp()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Helper Extensions

extension TipDifficulty {
    var color: Color {
        switch self {
        case .beginner:
            return .green
        case .intermediate:
            return .orange
        case .advanced:
            return .red
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        DailyTipBanner(
            tip: CalculatorTip(
                title: "각도 단위 변환",
                content: "삼각함수를 사용할 때는 각도 단위(도/라디안)를 확인하세요. 설정에서 변경할 수 있습니다.",
                category: .functions,
                difficulty: .beginner,
                isDaily: true
            ),
            onDismiss: { },
            onOpenHelp: { }
        )
        
        DailyTipBanner(
            tip: CalculatorTip(
                title: "메모리 기능 활용",
                content: "M+ 버튼으로 계산 결과를 메모리에 저장하고, MR로 불러올 수 있습니다.",
                category: .calculation,
                difficulty: .intermediate,
                isDaily: true
            ),
            onDismiss: { },
            onOpenHelp: { }
        )
    }
    .padding()
    .background(Color(.systemGray6))
} 