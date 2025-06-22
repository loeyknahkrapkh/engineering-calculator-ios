import Foundation
import Testing
import SwiftUI
@testable import EngineeringCalculator

/// 색상 시스템 테스트
struct ColorsTests {
    
    @Test("기본 색상이 정의되어 있는지 확인")
    func testBasicColorsAreDefined() {
        // 기본 색상들이 정의되어 있어야 함
        // 색상이 정상적으로 접근 가능한지 확인 (크래시 없이 접근)
        let _ = AppColors.background
        let _ = AppColors.surface
        let _ = AppColors.primary
        let _ = AppColors.secondary
        let _ = AppColors.accent
        
        // 테스트가 여기까지 도달하면 모든 색상이 정상적으로 정의됨
        #expect(true)
    }
    
    @Test("버튼 색상이 정의되어 있는지 확인")
    func testButtonColorsAreDefined() {
        // 버튼별 색상이 정의되어 있어야 함
        // 색상이 정상적으로 접근 가능한지 확인 (크래시 없이 접근)
        let _ = AppColors.Button.number
        let _ = AppColors.Button.operator
        let _ = AppColors.Button.function
        let _ = AppColors.Button.constant
        let _ = AppColors.Button.utility
        let _ = AppColors.Button.special
        
        // 테스트가 여기까지 도달하면 모든 버튼 색상이 정상적으로 정의됨
        #expect(true)
    }
    
    @Test("텍스트 색상이 정의되어 있는지 확인")
    func testTextColorsAreDefined() {
        // 텍스트 색상이 정의되어 있어야 함
        // 색상이 정상적으로 접근 가능한지 확인 (크래시 없이 접근)
        let _ = AppColors.Text.primary
        let _ = AppColors.Text.secondary
        let _ = AppColors.Text.onButton
        let _ = AppColors.Text.error
        
        // 테스트가 여기까지 도달하면 모든 텍스트 색상이 정상적으로 정의됨
        #expect(true)
    }
    
    @Test("버튼 타입별 색상 매핑 확인")
    func testButtonTypeColorMapping() {
        // 각 버튼 타입이 올바른 색상을 반환하는지 확인
        let buttonTypes: [ButtonType] = [.number, .operator, .function, .constant, .utility, .special]
        
        for buttonType in buttonTypes {
            // 색상이 정상적으로 접근 가능한지 확인 (크래시 없이 접근)
            let _ = buttonType.backgroundColor
            let _ = buttonType.textColor
        }
        
        // 특정 버튼 타입의 색상이 예상과 일치하는지 확인
        #expect(ButtonType.number.backgroundColor == AppColors.Button.number)
        #expect(ButtonType.operator.backgroundColor == AppColors.Button.operator)
        #expect(ButtonType.function.backgroundColor == AppColors.Button.function)
        #expect(ButtonType.constant.backgroundColor == AppColors.Button.constant)
        #expect(ButtonType.utility.backgroundColor == AppColors.Button.utility)
        #expect(ButtonType.special.backgroundColor == AppColors.Button.special)
    }
} 