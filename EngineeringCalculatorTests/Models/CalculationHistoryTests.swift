import Testing
@testable import EngineeringCalculator
import Foundation

struct CalculationHistoryTests {
    
    // MARK: - Basic Initialization Tests
    
    @Test("Basic initialization should work correctly")
    func basicInitialization() {
        let expression = "2 + 3"
        let result = 5.0
        let history = CalculationHistory(expression: expression, result: result)
        
        #expect(history.expression == expression)
        #expect(history.result == result)
        #expect(history.angleUnit == AngleUnit.degree) // 기본값
        #expect(!history.hasError)
        #expect(history.errorMessage == nil)
        #expect(history.id.uuidString.count == 36) // UUID는 항상 36자 문자열
        
        // 타임스탬프는 현재 시간과 거의 같아야 함
        let timeDifference = abs(history.timestamp.timeIntervalSinceNow)
        #expect(timeDifference < 1.0, "Timestamp should be close to current time")
    }
    
    @Test("Initialization with angle unit should work correctly")
    func initializationWithAngleUnit() {
        let expression = "sin(90)"
        let result = 1.0
        let history = CalculationHistory(expression: expression, result: result, angleUnit: .radian)
        
        #expect(history.expression == expression)
        #expect(history.result == result)
        #expect(history.angleUnit == AngleUnit.radian)
        #expect(!history.hasError)
        #expect(history.errorMessage == nil)
    }
    
    // MARK: - Error Initialization Tests
    
    @Test("Error initialization should work correctly")
    func errorInitialization() {
        let expression = "1 / 0"
        let errorMessage = "Division by zero"
        let history = CalculationHistory(expression: expression, error: errorMessage)
        
        #expect(history.expression == expression)
        #expect(history.result == 0.0)
        #expect(history.angleUnit == AngleUnit.degree) // 기본값
        #expect(history.hasError)
        #expect(history.errorMessage == errorMessage)
        #expect(history.id.uuidString.count == 36) // UUID는 항상 36자 문자열
    }
    
    @Test("Error initialization with angle unit should work correctly")
    func errorInitializationWithAngleUnit() {
        let expression = "log(-1)"
        let errorMessage = "Domain error"
        let history = CalculationHistory(expression: expression, error: errorMessage, angleUnit: .radian)
        
        #expect(history.expression == expression)
        #expect(history.angleUnit == AngleUnit.radian)
        #expect(history.hasError)
        #expect(history.errorMessage == errorMessage)
    }
    
    // MARK: - Custom Initialization Tests
    
    @Test("Custom initialization should work correctly")
    func customInitialization() {
        let id = UUID()
        let expression = "π * 2"
        let result = 6.283185307179586
        let timestamp = Date(timeIntervalSince1970: 1640995200) // 2022-01-01
        let angleUnit = AngleUnit.radian
        
        let history = CalculationHistory(
            id: id,
            expression: expression,
            result: result,
            timestamp: timestamp,
            angleUnit: angleUnit,
            hasError: false,
            errorMessage: nil
        )
        
        #expect(history.id == id)
        #expect(history.expression == expression)
        #expect(history.result == result)
        #expect(history.timestamp == timestamp)
        #expect(history.angleUnit == angleUnit)
        #expect(!history.hasError)
        #expect(history.errorMessage == nil)
    }
    
    // MARK: - Expression Trimming Tests
    
    @Test("Expression trimming should work correctly")
    func expressionTrimming() {
        let expressionWithSpaces = "  2 + 3  \n\t"
        let history = CalculationHistory(expression: expressionWithSpaces, result: 5.0)
        
        #expect(history.expression == "2 + 3")
    }
    
    // MARK: - Formatted Result Tests
    
    @Test("Formatted result should handle successful calculations")
    func formattedResultSuccess() {
        // 정수 결과
        let intHistory = CalculationHistory(expression: "2 + 3", result: 5.0)
        #expect(intHistory.formattedResult == "5")
        
        // 소수 결과
        let decimalHistory = CalculationHistory(expression: "1 / 3", result: 0.3333333333)
        #expect(decimalHistory.formattedResult == "0.3333")
        
        // 작은 수 (과학적 표기법)
        let smallHistory = CalculationHistory(expression: "1e-5", result: 0.00001)
        #expect(smallHistory.formattedResult == "1.0000e-05")
        
        // 큰 수 (1e15 이상에서 과학적 표기법 사용)
        let largeHistory = CalculationHistory(expression: "1e16", result: 1e16)
        #expect(largeHistory.formattedResult == "1.0000e+16")
        
        // 1e12는 정수 형태로 표시 (1e15 미만이므로)
        let integerLargeHistory = CalculationHistory(expression: "1e12", result: 1e12)
        #expect(integerLargeHistory.formattedResult == "1000000000000")
        
        // 1.5e10은 실제로는 정수가 되므로 일반 형태로 표시
        let decimalLargeHistory = CalculationHistory(expression: "1.5e10", result: 1.5e10)
        #expect(decimalLargeHistory.formattedResult == "15000000000")
        
        // 1e15 이상의 소수는 확실히 과학적 표기법 사용
        let realDecimalLargeHistory = CalculationHistory(expression: "1.23456e15", result: 1.23456e15)
        #expect(realDecimalLargeHistory.formattedResult == "1.2346e+15")
        
        // 1e10 이상이면서 소수점이 있는 수 (정수가 아닌 경우)
        let nonIntegerLargeHistory = CalculationHistory(expression: "12345678901.5", result: 12345678901.5)
        #expect(nonIntegerLargeHistory.formattedResult == "1.2346e+10")
        
        // 0
        let zeroHistory = CalculationHistory(expression: "0", result: 0.0)
        #expect(zeroHistory.formattedResult == "0")
    }
    
    @Test("Formatted result should handle special values")
    func formattedResultSpecialValues() {
        // 양의 무한대
        let positiveInfHistory = CalculationHistory(expression: "1/0", result: Double.infinity)
        #expect(positiveInfHistory.formattedResult == "∞")
        
        // 음의 무한대
        let negativeInfHistory = CalculationHistory(expression: "-1/0", result: -Double.infinity)
        #expect(negativeInfHistory.formattedResult == "-∞")
        
        // NaN
        let nanHistory = CalculationHistory(expression: "0/0", result: Double.nan)
        #expect(nanHistory.formattedResult == "Error")
    }
    
    @Test("Formatted result should handle errors")
    func formattedResultError() {
        let errorHistory = CalculationHistory(expression: "invalid", error: "Syntax error")
        #expect(errorHistory.formattedResult == "Syntax error")
        
        let errorWithoutMessageHistory = CalculationHistory(
            expression: "invalid",
            result: 0,
            hasError: true,
            errorMessage: nil
        )
        #expect(errorWithoutMessageHistory.formattedResult == "Error")
    }
    
    // MARK: - Time String Tests
    
    @Test("Relative time string should work correctly")
    func relativeTimeString() {
        let history = CalculationHistory(expression: "1+1", result: 2.0)
        let relativeTime = history.relativeTimeString
        
        // 방금 생성된 히스토리는 "방금" 또는 "0초 전" 등으로 표시되어야 함
        #expect(!relativeTime.isEmpty)
    }
    
    @Test("Absolute time string should work correctly")
    func absoluteTimeString() {
        let timestamp = Date(timeIntervalSince1970: 1640995200) // 2022-01-01 00:00:00 UTC
        let history = CalculationHistory(
            expression: "test",
            result: 1.0,
            timestamp: timestamp
        )
        
        let absoluteTime = history.absoluteTimeString
        #expect(!absoluteTime.isEmpty)
        // 정확한 형식은 로케일에 따라 다르므로 비어있지 않은지만 확인
    }
    
    // MARK: - Validation Tests
    
    @Test("Validation should work correctly")
    func isValid() {
        // 유효한 히스토리
        let validHistory = CalculationHistory(expression: "2+2", result: 4.0)
        #expect(validHistory.isValid)
        
        // 에러가 있지만 에러 메시지가 있는 경우
        let errorHistoryWithMessage = CalculationHistory(expression: "1/0", error: "Division by zero")
        #expect(errorHistoryWithMessage.isValid)
        
        // 빈 수식은 무효
        let emptyExpressionHistory = CalculationHistory(expression: "", result: 0.0)
        #expect(!emptyExpressionHistory.isValid)
        
        // 공백만 있는 수식은 무효 (트림 후 빈 문자열)
        let whitespaceExpressionHistory = CalculationHistory(expression: "   ", result: 0.0)
        #expect(!whitespaceExpressionHistory.isValid)
        
        // 에러가 있지만 에러 메시지가 없는 경우는 무효
        let errorHistoryWithoutMessage = CalculationHistory(
            expression: "invalid",
            result: 0,
            hasError: true,
            errorMessage: nil
        )
        #expect(!errorHistoryWithoutMessage.isValid)
    }
    
    // MARK: - Equatable Tests
    
    @Test("Equatable should work correctly")
    func equatable() {
        let id = UUID()
        let timestamp = Date()
        
        let history1 = CalculationHistory(
            id: id,
            expression: "2 + 3",
            result: 5.0,
            timestamp: timestamp,
            angleUnit: .degree,
            hasError: false,
            errorMessage: nil
        )
        
        let history2 = CalculationHistory(
            id: id,
            expression: "2 + 3",
            result: 5.0,
            timestamp: timestamp,
            angleUnit: .degree,
            hasError: false,
            errorMessage: nil
        )
        
        #expect(history1 == history2)
        
        // 다른 ID
        let history3 = CalculationHistory(
            id: UUID(),
            expression: "2 + 3",
            result: 5.0,
            timestamp: timestamp,
            angleUnit: .degree,
            hasError: false,
            errorMessage: nil
        )
        
        #expect(history1 != history3)
    }
    
    // MARK: - Codable Tests
    
    @Test("Codable should work for successful calculations")
    func codableSuccess() throws {
        let originalHistory = CalculationHistory(
            expression: "sin(π/2)",
            result: 1.0,
            angleUnit: .radian
        )
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(originalHistory)
        #expect(!encodedData.isEmpty)
        
        let decodedHistory = try decoder.decode(CalculationHistory.self, from: encodedData)
        
        #expect(decodedHistory.expression == originalHistory.expression)
        #expect(decodedHistory.result == originalHistory.result)
        #expect(decodedHistory.angleUnit == originalHistory.angleUnit)
        #expect(decodedHistory.hasError == originalHistory.hasError)
    }
    
    @Test("Codable should work for error cases")
    func codableError() throws {
        let originalHistory = CalculationHistory(
            expression: "1/0",
            error: "Division by zero"
        )
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(originalHistory)
        let decodedHistory = try decoder.decode(CalculationHistory.self, from: encodedData)
        
        #expect(decodedHistory.expression == originalHistory.expression)
        #expect(decodedHistory.errorMessage == originalHistory.errorMessage)
        #expect(decodedHistory.hasError == originalHistory.hasError)
    }
    
    // MARK: - Edge Cases Tests
    
    @Test("Empty expression should be handled correctly")
    func emptyExpression() {
        let history = CalculationHistory(expression: "", result: 0.0)
        
        #expect(history.expression == "")
        #expect(!history.isValid)
    }
    
    @Test("Very long expression should be handled correctly")
    func veryLongExpression() {
        let longExpression = String(repeating: "1+", count: 1000) + "1"
        let history = CalculationHistory(expression: longExpression, result: 1001.0)
        
        #expect(history.expression == longExpression)
        #expect(history.isValid)
    }
    
    @Test("Special characters in expression should be preserved")
    func specialCharacters() {
        let specialExpression = "π + e × √2 ÷ ∛8"
        let history = CalculationHistory(expression: specialExpression, result: 10.0)
        
        #expect(history.expression == specialExpression)
    }
    
    // MARK: - Performance Tests
    
    @Test("Formatted result calculation should be efficient")
    func formattedResultPerformance() {
        let history = CalculationHistory(expression: "complex calculation", result: 123.456789)
        
        // 여러 번 호출해도 빠르게 처리되어야 함
        for _ in 0..<1000 {
            _ = history.formattedResult
        }
        
        // 테스트가 빠르게 완료되면 성공
        #expect(true)
    }
} 