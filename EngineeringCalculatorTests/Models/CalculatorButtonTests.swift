import Testing
@testable import EngineeringCalculator

struct CalculatorButtonTests {
    
    // MARK: - Display Text Tests
    
    @Test("Display text should match raw values")
    func displayText() {
        // 숫자 버튼
        #expect(CalculatorButton.zero.displayText == "0")
        #expect(CalculatorButton.one.displayText == "1")
        #expect(CalculatorButton.nine.displayText == "9")
        
        // 연산자 버튼
        #expect(CalculatorButton.add.displayText == "+")
        #expect(CalculatorButton.subtract.displayText == "-")
        #expect(CalculatorButton.multiply.displayText == "×")
        #expect(CalculatorButton.divide.displayText == "÷")
        
        // 함수 버튼
        #expect(CalculatorButton.sin.displayText == "sin")
        #expect(CalculatorButton.cos.displayText == "cos")
        #expect(CalculatorButton.ln.displayText == "ln")
        
        // 상수 버튼
        #expect(CalculatorButton.pi.displayText == "π")
        #expect(CalculatorButton.e.displayText == "e")
        
        // 특수 버튼
        #expect(CalculatorButton.sqrt.displayText == "√")
        #expect(CalculatorButton.power.displayText == "xʸ")
    }
    
    // MARK: - Button Type Tests
    
    @Test("Number buttons should have correct type")
    func numberButtonTypes() {
        let numberButtons: [CalculatorButton] = [
            .zero, .one, .two, .three, .four,
            .five, .six, .seven, .eight, .nine
        ]
        
        for button in numberButtons {
            #expect(button.buttonType == .number, "Button \(button.rawValue) should be number type")
        }
    }
    
    @Test("Operator buttons should have correct type")
    func operatorButtonTypes() {
        let operatorButtons: [CalculatorButton] = [
            .add, .subtract, .multiply, .divide, .equals
        ]
        
        for button in operatorButtons {
            #expect(button.buttonType == .operator, "Button \(button.rawValue) should be operator type")
        }
    }
    
    @Test("Function buttons should have correct type")
    func functionButtonTypes() {
        let functionButtons: [CalculatorButton] = [
            .sin, .cos, .tan, .asin, .acos, .atan,
            .ln, .log, .log2, .exp, .pow10, .power, .sqrt, .cbrt
        ]
        
        for button in functionButtons {
            #expect(button.buttonType == .function, "Button \(button.rawValue) should be function type")
        }
    }
    
    @Test("Constant buttons should have correct type")
    func constantButtonTypes() {
        let constantButtons: [CalculatorButton] = [.pi, .e]
        
        for button in constantButtons {
            #expect(button.buttonType == .constant, "Button \(button.rawValue) should be constant type")
        }
    }
    
    @Test("Utility buttons should have correct type")
    func utilityButtonTypes() {
        let utilityButtons: [CalculatorButton] = [
            .clear, .plusMinus, .percent, .openParenthesis, 
            .closeParenthesis, .decimal, .backspace
        ]
        
        for button in utilityButtons {
            #expect(button.buttonType == .utility, "Button \(button.rawValue) should be utility type")
        }
    }
    
    @Test("Special buttons should have correct type")
    func specialButtonTypes() {
        let specialButtons: [CalculatorButton] = [
            .angleUnit, .history, .help, .unitConverter
        ]
        
        for button in specialButtons {
            #expect(button.buttonType == .special, "Button \(button.rawValue) should be special type")
        }
    }
    
    // MARK: - Calculation String Tests
    
    @Test("Calculation strings should be correct")
    func calculationString() {
        // 기본적으로 rawValue와 같은 경우
        #expect(CalculatorButton.add.calculationString == "+")
        #expect(CalculatorButton.subtract.calculationString == "-")
        #expect(CalculatorButton.one.calculationString == "1")
        
        // 특별한 변환이 필요한 경우
        #expect(CalculatorButton.multiply.calculationString == "*")
        #expect(CalculatorButton.divide.calculationString == "/")
        #expect(CalculatorButton.pi.calculationString == "π")
        #expect(CalculatorButton.e.calculationString == "e")
        #expect(CalculatorButton.sqrt.calculationString == "sqrt")
        #expect(CalculatorButton.cbrt.calculationString == "cbrt")
        #expect(CalculatorButton.exp.calculationString == "exp")
        #expect(CalculatorButton.pow10.calculationString == "pow10")
        #expect(CalculatorButton.power.calculationString == "^")
        #expect(CalculatorButton.log2.calculationString == "log2")
    }
    
    // MARK: - CaseIterable Tests
    
    @Test("All buttons should be included in allCases")
    func caseIterable() {
        let allButtons = CalculatorButton.allCases
        
        // 모든 버튼이 포함되어 있는지 확인
        #expect(allButtons.count > 30, "Should have more than 30 buttons")
        
        // 중복이 없는지 확인
        let uniqueButtons = Set(allButtons)
        #expect(allButtons.count == uniqueButtons.count, "All buttons should be unique")
        
        // 특정 중요한 버튼들이 포함되어 있는지 확인
        #expect(allButtons.contains(.zero))
        #expect(allButtons.contains(.equals))
        #expect(allButtons.contains(.sin))
        #expect(allButtons.contains(.pi))
        #expect(allButtons.contains(.clear))
    }
    
    // MARK: - Raw Value Tests
    
    @Test("Raw values should be correct")
    func rawValues() {
        // 숫자 버튼의 rawValue가 올바른지 확인
        #expect(CalculatorButton.zero.rawValue == "0")
        #expect(CalculatorButton.one.rawValue == "1")
        #expect(CalculatorButton.five.rawValue == "5")
        #expect(CalculatorButton.nine.rawValue == "9")
        
        // 특수 문자 버튼들
        #expect(CalculatorButton.multiply.rawValue == "×")
        #expect(CalculatorButton.divide.rawValue == "÷")
        #expect(CalculatorButton.plusMinus.rawValue == "±")
        #expect(CalculatorButton.pi.rawValue == "π")
        #expect(CalculatorButton.sqrt.rawValue == "√")
        #expect(CalculatorButton.cbrt.rawValue == "∛")
        #expect(CalculatorButton.backspace.rawValue == "⌫")
    }
    
    // MARK: - Button Type Coverage Tests
    
    @Test("All buttons should have valid types")
    func allButtonsHaveValidType() {
        for button in CalculatorButton.allCases {
            // 모든 버튼이 유효한 타입을 가지는지 확인
            let buttonType = button.buttonType
            let validTypes: [ButtonType] = [.number, .operator, .function, .constant, .utility, .special]
            #expect(validTypes.contains(buttonType), 
                   "Button \(button.rawValue) has invalid type \(buttonType)")
        }
    }
    
    @Test("Display text should equal raw value")
    func displayTextEqualsRawValue() {
        for button in CalculatorButton.allCases {
            // displayText가 rawValue와 같은지 확인 (현재 구현에서는 동일)
            #expect(button.displayText == button.rawValue, 
                   "Button \(button.rawValue) displayText should equal rawValue")
        }
    }
    
    // MARK: - Specific Button Group Tests
    
    @Test("Number buttons should be correctly ordered")
    func numberButtons() {
        let numberButtons: [CalculatorButton] = [
            .zero, .one, .two, .three, .four,
            .five, .six, .seven, .eight, .nine
        ]
        
        #expect(numberButtons.count == 10, "Should have exactly 10 number buttons")
        
        for (index, button) in numberButtons.enumerated() {
            #expect(button.rawValue == "\(index)", "Number button should match its index")
        }
    }
    
    @Test("Trigonometric functions should have correct properties")
    func trigonometricFunctions() {
        let trigButtons: [CalculatorButton] = [.sin, .cos, .tan, .asin, .acos, .atan]
        
        for button in trigButtons {
            #expect(button.buttonType == .function)
            #expect(button.calculationString == button.rawValue)
        }
    }
    
    @Test("Logarithmic functions should have correct properties")
    func logarithmicFunctions() {
        let logButtons: [CalculatorButton] = [.ln, .log, .log2]
        
        for button in logButtons {
            #expect(button.buttonType == .function)
        }
        
        // log2는 특별한 계산 문자열을 가짐
        #expect(CalculatorButton.log2.calculationString == "log2")
        #expect(CalculatorButton.ln.calculationString == "ln")
        #expect(CalculatorButton.log.calculationString == "log")
    }
    
    @Test("Exponential functions should have correct properties")
    func exponentialFunctions() {
        let expButtons: [CalculatorButton] = [.exp, .pow10, .power]
        
        for button in expButtons {
            #expect(button.buttonType == .function)
        }
        
        #expect(CalculatorButton.exp.calculationString == "exp")
        #expect(CalculatorButton.pow10.calculationString == "pow10")
        #expect(CalculatorButton.power.calculationString == "^")
    }
} 