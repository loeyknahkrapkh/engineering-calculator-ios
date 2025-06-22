import Testing
import Foundation
@testable import EngineeringCalculator

struct CalculatorSettingsTests {
    
    // MARK: - Default Initialization Tests
    
    @Test("Default initialization should have correct values")
    func defaultInitialization() {
        let settings = CalculatorSettings()
        
        #expect(settings.angleUnit == AngleUnit.degree)
        #expect(settings.decimalPlaces == 4)
        #expect(settings.isFirstLaunch == true)
        #expect(settings.showTips == true)
        #expect(settings.useScientificNotation == false)
        #expect(settings.autoSaveHistory == true)
        #expect(settings.maxHistoryCount == 100)
    }
    
    // MARK: - Custom Initialization Tests
    
    @Test("Custom initialization should set values correctly")
    func customInitialization() {
        let settings = CalculatorSettings(
            angleUnit: AngleUnit.radian,
            decimalPlaces: 6,
            isFirstLaunch: false,
            showTips: false,
            useScientificNotation: true,
            autoSaveHistory: false,
            maxHistoryCount: 200
        )
        
        #expect(settings.angleUnit == AngleUnit.radian)
        #expect(settings.decimalPlaces == 6)
        #expect(settings.isFirstLaunch == false)
        #expect(settings.showTips == false)
        #expect(settings.useScientificNotation == true)
        #expect(settings.autoSaveHistory == false)
        #expect(settings.maxHistoryCount == 200)
    }
    
    // MARK: - Decimal Places Validation Tests
    
    @Test("Decimal places should be validated and clamped")
    func decimalPlacesValidation() {
        // 음수 값은 0으로 제한
        let negativeSettings = CalculatorSettings(decimalPlaces: -5)
        #expect(negativeSettings.decimalPlaces == 0)
        
        // 10 초과 값은 10으로 제한
        let largeSettings = CalculatorSettings(decimalPlaces: 15)
        #expect(largeSettings.decimalPlaces == 10)
        
        // 유효한 범위 내 값
        let validSettings = CalculatorSettings(decimalPlaces: 5)
        #expect(validSettings.decimalPlaces == 5)
        
        // 경계값 테스트
        let minSettings = CalculatorSettings(decimalPlaces: 0)
        #expect(minSettings.decimalPlaces == 0)
        
        let maxSettings = CalculatorSettings(decimalPlaces: 10)
        #expect(maxSettings.decimalPlaces == 10)
    }
    
    // MARK: - Max History Count Validation Tests
    
    @Test("Max history count should be validated and clamped")
    func maxHistoryCountValidation() {
        // 10 미만 값은 10으로 제한
        let smallSettings = CalculatorSettings(maxHistoryCount: 5)
        #expect(smallSettings.maxHistoryCount == 10)
        
        // 1000 초과 값은 1000으로 제한
        let largeSettings = CalculatorSettings(maxHistoryCount: 1500)
        #expect(largeSettings.maxHistoryCount == 1000)
        
        // 유효한 범위 내 값
        let validSettings = CalculatorSettings(maxHistoryCount: 500)
        #expect(validSettings.maxHistoryCount == 500)
        
        // 경계값 테스트
        let minSettings = CalculatorSettings(maxHistoryCount: 10)
        #expect(minSettings.maxHistoryCount == 10)
        
        let maxSettings = CalculatorSettings(maxHistoryCount: 1000)
        #expect(maxSettings.maxHistoryCount == 1000)
    }
    
    // MARK: - Validation Tests
    
    @Test("Settings validation should work correctly")
    func isValid() {
        // 유효한 설정
        let validSettings = CalculatorSettings(
            decimalPlaces: 5,
            maxHistoryCount: 50
        )
        #expect(validSettings.isValid)
        
        // 경계값에서 유효한 설정
        let boundaryValidSettings = CalculatorSettings(
            decimalPlaces: 0,
            maxHistoryCount: 10
        )
        #expect(boundaryValidSettings.isValid)
        
        let upperBoundaryValidSettings = CalculatorSettings(
            decimalPlaces: 10,
            maxHistoryCount: 1000
        )
        #expect(upperBoundaryValidSettings.isValid)
        
        // 기본 설정은 항상 유효
        let defaultSettings = CalculatorSettings()
        #expect(defaultSettings.isValid)
    }
    
    // MARK: - Reset to Defaults Tests
    
    @Test("Reset to defaults should restore all default values")
    func resetToDefaults() {
        var settings = CalculatorSettings(
            angleUnit: AngleUnit.radian,
            decimalPlaces: 8,
            isFirstLaunch: false,
            showTips: false,
            useScientificNotation: true,
            autoSaveHistory: false,
            maxHistoryCount: 500
        )
        
        settings.resetToDefaults()
        
        // 모든 값이 기본값으로 리셋되었는지 확인
        #expect(settings.angleUnit == AngleUnit.degree)
        #expect(settings.decimalPlaces == 4)
        #expect(settings.isFirstLaunch == true)
        #expect(settings.showTips == true)
        #expect(settings.useScientificNotation == false)
        #expect(settings.autoSaveHistory == true)
        #expect(settings.maxHistoryCount == 100)
    }
    
    // MARK: - Toggle Angle Unit Tests
    
    @Test("Toggle angle unit should switch between degree and radian")
    func toggleAngleUnit() {
        var settings = CalculatorSettings()
        
        // 기본값은 degree
        #expect(settings.angleUnit == AngleUnit.degree)
        
        // 토글하면 radian
        settings.toggleAngleUnit()
        #expect(settings.angleUnit == AngleUnit.radian)
        
        // 다시 토글하면 degree
        settings.toggleAngleUnit()
        #expect(settings.angleUnit == AngleUnit.degree)
        
        // radian으로 시작하는 경우
        var radianSettings = CalculatorSettings(angleUnit: AngleUnit.radian)
        #expect(radianSettings.angleUnit == AngleUnit.radian)
        
        radianSettings.toggleAngleUnit()
        #expect(radianSettings.angleUnit == AngleUnit.degree)
    }
    
    // MARK: - Equatable Tests
    
    @Test("Equatable should work correctly")
    func equatable() {
        let settings1 = CalculatorSettings()
        let settings2 = CalculatorSettings()
        
        // 같은 기본 설정
        #expect(settings1 == settings2)
        
        // 다른 설정
        let settings3 = CalculatorSettings(angleUnit: AngleUnit.radian)
        #expect(settings1 != settings3)
        
        // 모든 필드가 같은 경우
        let settings4 = CalculatorSettings(
            angleUnit: AngleUnit.degree,
            decimalPlaces: 4,
            isFirstLaunch: true,
            showTips: true,
            useScientificNotation: false,
            autoSaveHistory: true,
            maxHistoryCount: 100
        )
        #expect(settings1 == settings4)
    }
    
    // MARK: - Codable Tests
    
    @Test("Settings should be encodable and decodable")
    func codable() throws {
        let originalSettings = CalculatorSettings(
            angleUnit: AngleUnit.radian,
            decimalPlaces: 6,
            isFirstLaunch: false,
            showTips: false,
            useScientificNotation: true,
            autoSaveHistory: false,
            maxHistoryCount: 200
        )
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        // 인코딩
        let encodedData = try encoder.encode(originalSettings)
        #expect(!encodedData.isEmpty)
        
        // 디코딩
        let decodedSettings = try decoder.decode(CalculatorSettings.self, from: encodedData)
        
        // 원본과 디코딩된 설정이 같은지 확인
        #expect(originalSettings == decodedSettings)
        #expect(decodedSettings.angleUnit == AngleUnit.radian)
        #expect(decodedSettings.decimalPlaces == 6)
        #expect(decodedSettings.isFirstLaunch == false)
        #expect(decodedSettings.showTips == false)
        #expect(decodedSettings.useScientificNotation == true)
        #expect(decodedSettings.autoSaveHistory == false)
        #expect(decodedSettings.maxHistoryCount == 200)
    }
    
    // MARK: - Edge Case Tests
    
    @Test("Extreme values should be handled correctly")
    func extremeValues() {
        // Int의 최대/최소값으로 테스트
        let extremeSettings = CalculatorSettings(
            decimalPlaces: Int.max,
            maxHistoryCount: Int.min
        )
        
        // 값이 올바르게 제한되는지 확인
        #expect(extremeSettings.decimalPlaces == 10)
        #expect(extremeSettings.maxHistoryCount == 10)
    }
    
    @Test("Settings should be mutable")
    func mutability() {
        var settings = CalculatorSettings()
        
        // 각 필드가 변경 가능한지 확인
        settings.angleUnit = AngleUnit.radian
        settings.decimalPlaces = 8
        settings.isFirstLaunch = false
        settings.showTips = false
        settings.useScientificNotation = true
        settings.autoSaveHistory = false
        settings.maxHistoryCount = 50
        
        #expect(settings.angleUnit == AngleUnit.radian)
        #expect(settings.decimalPlaces == 8)
        #expect(settings.isFirstLaunch == false)
        #expect(settings.showTips == false)
        #expect(settings.useScientificNotation == true)
        #expect(settings.autoSaveHistory == false)
        #expect(settings.maxHistoryCount == 50)
    }
} 