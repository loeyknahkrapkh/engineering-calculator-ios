import Foundation
import Testing
import SwiftUI
@testable import EngineeringCalculator

/// CalculatorButtonView 테스트
struct CalculatorButtonViewTests {
    
    @Test("버튼 타입별 색상 확인")
    func testButtonColors() {
        let numberButton = CalculatorButton.one
        let operatorButton = CalculatorButton.add
        let functionButton = CalculatorButton.sin
        let constantButton = CalculatorButton.pi
        let utilityButton = CalculatorButton.clear
        let specialButton = CalculatorButton.history
        
        #expect(numberButton.buttonType == .number)
        #expect(operatorButton.buttonType == .operator)
        #expect(functionButton.buttonType == .function)
        #expect(constantButton.buttonType == .constant)
        #expect(utilityButton.buttonType == .utility)
        #expect(specialButton.buttonType == .special)
    }
    
    @Test("버튼 표시 텍스트 확인")
    func testButtonDisplayText() {
        #expect(CalculatorButton.one.displayText == "1")
        #expect(CalculatorButton.add.displayText == "+")
        #expect(CalculatorButton.sin.displayText == "sin")
        #expect(CalculatorButton.pi.displayText == "π")
        #expect(CalculatorButton.clear.displayText == "C")
        #expect(CalculatorButton.history.displayText == "hist")
    }
    
    @Test("계산 문자열 변환 확인")
    func testCalculationString() {
        #expect(CalculatorButton.multiply.calculationString == "*")
        #expect(CalculatorButton.divide.calculationString == "/")
        #expect(CalculatorButton.power.calculationString == "^")
        #expect(CalculatorButton.sqrt.calculationString == "sqrt")
        #expect(CalculatorButton.pi.calculationString == "π")
        #expect(CalculatorButton.e.calculationString == "e")
    }
    
    @Test("모든 버튼 타입이 정의되어 있는지 확인")
    func testAllButtonTypesAreDefined() {
        for button in CalculatorButton.allCases {
            let buttonType = button.buttonType
            let displayText = button.displayText
            let calculationString = button.calculationString
            
            // 모든 버튼이 유효한 타입을 가져야 함
            #expect(!displayText.isEmpty)
            #expect(!calculationString.isEmpty)
            
            // ButtonType이 올바르게 분류되어 있는지 확인
            switch buttonType {
            case .number, .operator, .function, .constant, .utility, .special:
                break // 모든 경우가 정의되어 있음
            }
        }
    }
} 