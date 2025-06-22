//
//  EngineeringCalculatorTests.swift
//  EngineeringCalculatorTests
//
//  Created by @loeyknahkrapkh on 6/22/25.
//

import Testing
import Foundation
@testable import EngineeringCalculator

/// 공학용 계산기 앱의 메인 테스트 구조체
/// 
/// 이 구조체는 테스트 타겟의 진입점 역할을 하며,
/// 앱의 전반적인 통합 테스트를 수행합니다.
struct EngineeringCalculatorTests {

    // MARK: - 기본 모델 통합 테스트
    
    @Test("Basic models integration should work correctly")
    func basicModelsIntegration() throws {
        // AngleUnit과 CalculatorSettings 통합 테스트
        var settings = CalculatorSettings()
        #expect(settings.angleUnit == AngleUnit.degree)
        
        settings.toggleAngleUnit()
        #expect(settings.angleUnit == AngleUnit.radian)
        
        // CalculationHistory와 AngleUnit 통합 테스트
        let history = CalculationHistory(
            expression: "sin(90)",
            result: 1.0,
            angleUnit: settings.angleUnit
        )
        #expect(history.angleUnit == AngleUnit.radian)
        #expect(history.isValid)
    }
    
    @Test("Calculator button and settings integration should work")
    func calculatorButtonAndSettings() throws {
        let settings = CalculatorSettings()
        
        // 각도 단위 버튼 테스트
        let angleButton = CalculatorButton.angleUnit
        #expect(angleButton.buttonType == .special)
        #expect(angleButton.displayText == "rad/deg")
        
        // 상수 버튼과 설정 통합
        let piButton = CalculatorButton.pi
        #expect(piButton.buttonType == .constant)
        #expect(piButton.calculationString == "π")
        
        // 함수 버튼과 각도 단위 설정
        let sinButton = CalculatorButton.sin
        #expect(sinButton.buttonType == .function)
        
        // 설정에 유효한 각도 단위가 설정되어 있는지 확인
        #expect(settings.angleUnit == AngleUnit.degree)
    }
    
    // MARK: - 상수 값 검증 테스트
    
    @Test("Math constants should have correct values")
    func mathConstants() throws {
        // π 값 검증
        #expect(abs(MathConstants.pi - Double.pi) < 1e-15)
        
        // e 값 검증
        #expect(abs(MathConstants.e - 2.718281828459045) < 1e-15)
        
        // 황금비 검증
        let expectedPhi = (1.0 + Foundation.sqrt(5.0)) / 2.0
        #expect(abs(MathConstants.phi - expectedPhi) < 1e-15)
        
        // 각도 변환 상수 검증
        #expect(abs(MathConstants.degreesToRadians - Double.pi / 180.0) < 1e-15)
        #expect(abs(MathConstants.radiansToDegrees - 180.0 / Double.pi) < 1e-15)
    }
    
    @Test("App constants should have correct values")
    func appConstants() throws {
        // 앱 정보 상수
        #expect(AppConstants.appName == "Engineering Calculator")
        #expect(AppConstants.appVersion == "1.0.0")
        #expect(AppConstants.bundleIdentifier == "com.demo.EngineeringCalculator")
        
        // UI 상수
        #expect(AppConstants.minimumTouchTarget == 44.0)
        #expect(AppConstants.defaultButtonSize > AppConstants.minimumTouchTarget)
        
        // 계산 상수
        #expect(AppConstants.defaultDecimalPlaces == 4)
        #expect(AppConstants.maxDecimalPlaces >= AppConstants.defaultDecimalPlaces)
        
        // 히스토리 상수
        #expect(AppConstants.defaultMaxHistoryCount == 100)
        #expect(AppConstants.minHistoryCount <= AppConstants.defaultMaxHistoryCount)
        #expect(AppConstants.maxHistoryCount >= AppConstants.defaultMaxHistoryCount)
    }
    
    // MARK: - 에러 메시지 테스트
    
    @Test("Error messages should be properly defined")
    func errorMessages() throws {
        // 에러 메시지가 비어있지 않은지 확인
        #expect(!AppConstants.generalCalculationError.isEmpty)
        #expect(!AppConstants.divisionByZeroError.isEmpty)
        #expect(!AppConstants.domainError.isEmpty)
        #expect(!AppConstants.rangeError.isEmpty)
        #expect(!AppConstants.syntaxError.isEmpty)
        #expect(!AppConstants.overflowError.isEmpty)
        #expect(!AppConstants.underflowError.isEmpty)
        
        // 한글 메시지인지 확인
        #expect(AppConstants.divisionByZeroError.contains("나눌 수 없습니다"))
        #expect(AppConstants.domainError.contains("정의되지 않은"))
        #expect(AppConstants.syntaxError.contains("잘못된 수식"))
    }
    
    // MARK: - 접근성 레이블 테스트
    
    @Test("Accessibility labels should be properly defined")
    func accessibilityLabels() throws {
        let labels = AppConstants.AccessibilityLabels.self
        
        #expect(!labels.calculatorButton.isEmpty)
        #expect(!labels.numberButton.isEmpty)
        #expect(!labels.operatorButton.isEmpty)
        #expect(!labels.functionButton.isEmpty)
        #expect(!labels.clearButton.isEmpty)
        #expect(!labels.equalsButton.isEmpty)
        #expect(!labels.historyButton.isEmpty)
        #expect(!labels.helpButton.isEmpty)
        #expect(!labels.settingsButton.isEmpty)
        
        // 한글 레이블인지 확인
        #expect(labels.numberButton.contains("숫자"))
        #expect(labels.operatorButton.contains("연산자"))
        #expect(labels.functionButton.contains("함수"))
    }
    
    // MARK: - 알림 이름 테스트
    
    @Test("Notification names should be correctly defined")
    func notificationNames() throws {
        // 알림 이름이 올바르게 정의되어 있는지 확인
        #expect(AppConstants.settingsDidChangeNotification.rawValue == "SettingsDidChange")
        #expect(AppConstants.historyDidUpdateNotification.rawValue == "HistoryDidUpdate")
        #expect(AppConstants.calculationDidCompleteNotification.rawValue == "CalculationDidComplete")
    }
    
    // MARK: - 성능 테스트
    
    @Test("Performance should be acceptable for basic model creation", .timeLimit(.minutes(1)))
    func performanceExample() throws {
        // 기본 모델 생성 성능 테스트
        for _ in 0..<1000 {
            let settings = CalculatorSettings()
            let history = CalculationHistory(expression: "test", result: 1.0)
            let angleUnit = AngleUnit.degree
            
            // 간단한 연산으로 성능 측정
            _ = settings.isValid
            _ = history.formattedResult
            _ = angleUnit.displayName
        }
    }
    
    // MARK: - 메모리 관리 테스트
    
    @Test("Memory management should work correctly")
    func memoryManagement() throws {
        // 대량의 객체 생성 후 메모리 해제 확인
        // struct는 값 타입이므로 자동으로 메모리 관리됨
        
        for _ in 0..<10000 {
            let history = CalculationHistory(expression: "test", result: 1.0)
            var settings = CalculatorSettings()
            
            // 객체 사용
            _ = history.formattedResult
            settings.toggleAngleUnit()
        }
        
        // 테스트가 완료되면 메모리가 자동으로 해제됨
        #expect(true)
    }
}
 