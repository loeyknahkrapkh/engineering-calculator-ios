import SwiftUI

/// 팁 목록의 개별 행을 표시하는 뷰
struct TipRowView: View {
    let tip: CalculatorTip
    var showDifficulty: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // 제목
                Text(tip.title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // 난이도 표시 (옵션)
                if showDifficulty {
                    HStack(spacing: 4) {
                        ForEach(1...tip.difficulty.sortOrder, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                        ForEach((tip.difficulty.sortOrder + 1)...3, id: \.self) { _ in
                            Image(systemName: "star")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // 내용
            Text(tip.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            // 하단 정보
            HStack {
                Text(tip.category.displayName)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(4)
                
                if !showDifficulty {
                    Text(tip.difficulty.displayName)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(4)
                }
                
                if tip.isDaily {
                    Text("오늘의 팁")
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.yellow.opacity(0.3))
                        .foregroundColor(.orange)
                        .cornerRadius(4)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Previews

#Preview("기본 팁") {
    TipRowView(
        tip: CalculatorTip(
            title: "삼각함수 계산",
            content: "각도 단위를 확인하세요. 라디안과 도 단위를 구분해서 사용하면 정확한 결과를 얻을 수 있습니다.",
            category: .functions,
            difficulty: .beginner
        )
    )
    .padding()
}

#Preview("오늘의 팁") {
    TipRowView(
        tip: CalculatorTip(
            title: "계산 결과 복사하기",
            content: "계산 결과를 길게 누르면 클립보드에 복사할 수 있습니다.",
            category: .shortcuts,
            difficulty: .intermediate,
            isDaily: true
        ),
        showDifficulty: true
    )
    .padding()
}
