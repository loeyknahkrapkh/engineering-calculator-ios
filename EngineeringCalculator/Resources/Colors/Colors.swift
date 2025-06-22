import SwiftUI

/// 앱 전체 색상 시스템
struct AppColors {
    
    // MARK: - 기본 색상
    
    /// 배경 색상
    static let background = Color(.systemBackground)
    
    /// 표면 색상 (카드, 패널 등)
    static let surface = Color(.secondarySystemBackground)
    
    /// 주요 색상
    static let primary = Color(.label)
    
    /// 보조 색상
    static let secondary = Color(.secondaryLabel)
    
    /// 강조 색상
    static let accent = Color.orange
    
    // MARK: - 버튼 색상
    
    struct Button {
        /// 숫자 버튼 배경색
        static let number = Color(.systemGray5)
        
        /// 연산자 버튼 배경색
        static let `operator` = Color.orange
        
        /// 함수 버튼 배경색
        static let function = Color(.systemGray4)
        
        /// 상수 버튼 배경색
        static let constant = Color(.systemGray4)
        
        /// 유틸리티 버튼 배경색
        static let utility = Color(.systemGray3)
        
        /// 특수 기능 버튼 배경색
        static let special = Color(.systemBlue).opacity(0.1)
    }
    
    // MARK: - 텍스트 색상
    
    struct Text {
        /// 주요 텍스트 색상
        static let primary = Color(.label)
        
        /// 보조 텍스트 색상
        static let secondary = Color(.secondaryLabel)
        
        /// 버튼 위 텍스트 색상
        static let onButton = Color(.label)
        
        /// 에러 텍스트 색상
        static let error = Color.red
        
        /// 연산자 버튼 텍스트 색상
        static let onOperator = Color.white
        
        /// 특수 버튼 텍스트 색상
        static let onSpecial = Color.blue
    }
    
    // MARK: - 상태별 색상
    
    struct State {
        /// 성공 색상
        static let success = Color.green
        
        /// 경고 색상
        static let warning = Color.orange
        
        /// 에러 색상
        static let error = Color.red
        
        /// 정보 색상
        static let info = Color.blue
    }
    
    // MARK: - 그림자 색상
    
    struct Shadow {
        /// 기본 그림자 색상
        static let `default` = Color.black.opacity(0.1)
        
        /// 진한 그림자 색상
        static let dark = Color.black.opacity(0.2)
        
        /// 연한 그림자 색상
        static let light = Color.black.opacity(0.05)
    }
}

// MARK: - ButtonType Extension

extension ButtonType {
    
    /// 버튼 타입별 배경 색상
    var backgroundColor: Color {
        switch self {
        case .number:
            return AppColors.Button.number
        case .operator:
            return AppColors.Button.operator
        case .function:
            return AppColors.Button.function
        case .constant:
            return AppColors.Button.constant
        case .utility:
            return AppColors.Button.utility
        case .special:
            return AppColors.Button.special
        }
    }
    
    /// 버튼 타입별 텍스트 색상
    var textColor: Color {
        switch self {
        case .number, .utility:
            return AppColors.Text.primary
        case .operator:
            return AppColors.Text.onOperator
        case .function, .constant:
            return AppColors.Text.primary
        case .special:
            return AppColors.Text.onSpecial
        }
    }
} 