import Foundation
import Testing
import SwiftUI
@testable import EngineeringCalculator

/// 폰트 시스템 테스트
struct FontsTests {
    
    @Test("기본 폰트가 정의되어 있는지 확인")
    func testBasicFontsAreDefined() {
        // 기본 폰트들이 정의되어 있어야 함
        // 폰트가 정상적으로 접근 가능한지 확인 (크래시 없이 접근)
        let _ = AppFonts.display
        let _ = AppFonts.mono
        
        // 테스트가 여기까지 도달하면 모든 폰트가 정상적으로 정의됨
        #expect(true)
    }
    
    @Test("디스플레이 폰트 크기가 정의되어 있는지 확인")
    func testDisplayFontSizesAreDefined() {
        // 디스플레이 폰트 크기들이 정의되어 있어야 함
        // 폰트가 정상적으로 접근 가능한지 확인 (크래시 없이 접근)
        let _ = AppFonts.Display.large
        let _ = AppFonts.Display.medium
        let _ = AppFonts.Display.small
        
        // 테스트가 여기까지 도달하면 모든 디스플레이 폰트가 정상적으로 정의됨
        #expect(true)
    }
    
    @Test("버튼 폰트 크기가 정의되어 있는지 확인")
    func testButtonFontSizesAreDefined() {
        // 버튼 폰트 크기들이 정의되어 있어야 함
        // 폰트가 정상적으로 접근 가능한지 확인 (크래시 없이 접근)
        let _ = AppFonts.Button.number
        let _ = AppFonts.Button.operator
        let _ = AppFonts.Button.function
        let _ = AppFonts.Button.utility
        
        // 테스트가 여기까지 도달하면 모든 버튼 폰트가 정상적으로 정의됨
        #expect(true)
    }
    
    @Test("모노스페이스 폰트 크기가 정의되어 있는지 확인")
    func testMonospaceFontSizesAreDefined() {
        // 모노스페이스 폰트 크기들이 정의되어 있어야 함
        // 폰트가 정상적으로 접근 가능한지 확인 (크래시 없이 접근)
        let _ = AppFonts.Mono.expression
        let _ = AppFonts.Mono.result
        let _ = AppFonts.Mono.small
        
        // 테스트가 여기까지 도달하면 모든 모노스페이스 폰트가 정상적으로 정의됨
        #expect(true)
    }
    
    @Test("버튼 타입별 폰트 매핑 확인")
    func testButtonTypeFontMapping() {
        // 각 버튼 타입이 올바른 폰트를 반환하는지 확인
        let buttonTypes: [ButtonType] = [.number, .operator, .function, .constant, .utility, .special]
        
        for buttonType in buttonTypes {
            // 폰트가 정상적으로 접근 가능한지 확인 (크래시 없이 접근)
            let _ = buttonType.font
        }
        
        // 특정 버튼 타입의 폰트가 예상과 일치하는지 확인
        #expect(ButtonType.number.font == AppFonts.Button.number)
        #expect(ButtonType.operator.font == AppFonts.Button.operator)
        #expect(ButtonType.function.font == AppFonts.Button.function)
        #expect(ButtonType.constant.font == AppFonts.Button.constant)
        #expect(ButtonType.utility.font == AppFonts.Button.utility)
        #expect(ButtonType.special.font == AppFonts.Button.special)
    }
} 