import SwiftUI

/// 앱 전체 폰트 시스템
struct AppFonts {
    
    // MARK: - 기본 폰트 패밀리
    
    /// SF Pro Display 폰트 (UI 요소용)
    static let display = Font.system(.body, design: .default)
    
    /// SF Mono 폰트 (계산 표시용)
    static let mono = Font.system(.body, design: .monospaced)
    
    // MARK: - 디스플레이 폰트 (계산 결과 표시용)
    
    struct Display {
        /// 큰 결과 표시 (48pt)
        static let large = Font.system(size: 48, weight: .light, design: .monospaced)
        
        /// 중간 결과 표시 (32pt)
        static let medium = Font.system(size: 32, weight: .light, design: .monospaced)
        
        /// 작은 결과 표시 (24pt)
        static let small = Font.system(size: 24, weight: .light, design: .monospaced)
    }
    
    // MARK: - 버튼 폰트
    
    struct Button {
        /// 숫자 버튼 폰트 (28pt)
        static let number = Font.system(size: 28, weight: .medium, design: .default)
        
        /// 연산자 버튼 폰트 (28pt)
        static let `operator` = Font.system(size: 28, weight: .medium, design: .default)
        
        /// 함수 버튼 폰트 (16pt)
        static let function = Font.system(size: 16, weight: .medium, design: .default)
        
        /// 유틸리티 버튼 폰트 (20pt)
        static let utility = Font.system(size: 20, weight: .medium, design: .default)
        
        /// 상수 버튼 폰트 (24pt)
        static let constant = Font.system(size: 24, weight: .medium, design: .default)
        
        /// 특수 기능 버튼 폰트 (20pt)
        static let special = Font.system(size: 20, weight: .medium, design: .default)
    }
    
    // MARK: - 모노스페이스 폰트 (수식 표시용)
    
    struct Mono {
        /// 수식 표시 폰트 (24pt)
        static let expression = Font.system(size: 24, weight: .regular, design: .monospaced)
        
        /// 결과 표시 폰트 (48pt)
        static let result = Font.system(size: 48, weight: .light, design: .monospaced)
        
        /// 작은 모노스페이스 폰트 (16pt)
        static let small = Font.system(size: 16, weight: .regular, design: .monospaced)
        
        /// 중간 모노스페이스 폰트 (20pt)
        static let medium = Font.system(size: 20, weight: .regular, design: .monospaced)
    }
    
    // MARK: - 텍스트 폰트
    
    struct Text {
        /// 제목 폰트 (24pt)
        static let title = Font.system(size: 24, weight: .semibold, design: .default)
        
        /// 부제목 폰트 (20pt)
        static let subtitle = Font.system(size: 20, weight: .medium, design: .default)
        
        /// 본문 폰트 (16pt)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        
        /// 캡션 폰트 (12pt)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        
        /// 작은 텍스트 폰트 (10pt)
        static let small = Font.system(size: 10, weight: .regular, design: .default)
    }
    
    // MARK: - 동적 폰트 크기 조정
    
    /// 텍스트 길이에 따른 폰트 크기 조정
    static func adjustedFont(for text: String, baseSize: CGFloat, maxWidth: CGFloat) -> Font {
        let characterCount = text.count
        var fontSize = baseSize
        
        // 문자 수에 따른 크기 조정
        if characterCount > 15 {
            fontSize = max(baseSize * 0.6, 12)
        } else if characterCount > 10 {
            fontSize = max(baseSize * 0.8, 14)
        } else if characterCount > 8 {
            fontSize = max(baseSize * 0.9, 16)
        }
        
        return Font.system(size: fontSize, weight: .light, design: .monospaced)
    }
}

// MARK: - ButtonType Extension

extension ButtonType {
    
    /// 버튼 타입별 폰트
    var font: Font {
        switch self {
        case .number:
            return AppFonts.Button.number
        case .operator:
            return AppFonts.Button.operator
        case .function:
            return AppFonts.Button.function
        case .constant:
            return AppFonts.Button.constant
        case .utility:
            return AppFonts.Button.utility
        case .special:
            return AppFonts.Button.special
        }
    }
} 