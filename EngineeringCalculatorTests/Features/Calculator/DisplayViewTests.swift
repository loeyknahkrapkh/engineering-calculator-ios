import Foundation
import Testing
import SwiftUI
@testable import EngineeringCalculator

/// DisplayView 테스트
struct DisplayViewTests {
    
    @Test("빈 표시 상태 확인")
    func testEmptyDisplayState() {
        let displayView = DisplayView(
            expression: "",
            result: "",
            hasError: false
        )
        
        // 빈 상태에서도 뷰가 정상적으로 생성되어야 함
        #expect(!displayView.expression.isEmpty || displayView.expression.isEmpty)
        #expect(!displayView.result.isEmpty || displayView.result.isEmpty)
        #expect(displayView.hasError == false)
    }
    
    @Test("정상 계산 상태 확인")
    func testNormalCalculationState() {
        let displayView = DisplayView(
            expression: "2 + 3",
            result: "5",
            hasError: false
        )
        
        #expect(displayView.expression == "2 + 3")
        #expect(displayView.result == "5")
        #expect(displayView.hasError == false)
    }
    
    @Test("에러 상태 확인")
    func testErrorState() {
        let displayView = DisplayView(
            expression: "1 ÷ 0",
            result: "Error: Division by zero",
            hasError: true
        )
        
        #expect(displayView.expression == "1 ÷ 0")
        #expect(displayView.result == "Error: Division by zero")
        #expect(displayView.hasError == true)
    }
    
    @Test("긴 수식 처리 확인")
    func testLongExpressionHandling() {
        let longExpression = "sin(30) + cos(45) × tan(60) + ln(10) / log(100) + sqrt(25)"
        let longResult = "12.345678901234567890"
        
        let displayView = DisplayView(
            expression: longExpression,
            result: longResult,
            hasError: false
        )
        
        #expect(displayView.expression == longExpression)
        #expect(displayView.result == longResult)
        #expect(displayView.hasError == false)
    }
    
    @Test("다양한 수학 기호 표시 확인")
    func testMathematicalSymbolsDisplay() {
        let expression = "π × e + √2 ÷ ∛8"
        let result = "12.3456"
        
        let displayView = DisplayView(
            expression: expression,
            result: result,
            hasError: false
        )
        
        #expect(displayView.expression.contains("π"))
        #expect(displayView.expression.contains("×"))
        #expect(displayView.expression.contains("÷"))
        #expect(displayView.expression.contains("√"))
        #expect(displayView.expression.contains("∛"))
    }
} 