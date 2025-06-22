import Testing
import Foundation
@testable import EngineeringCalculator

@Suite("Settings Storage Tests")
struct SettingsStorageTests {
    
    // MARK: - Test UserDefaultsSettingsStorage
    
    @Test("UserDefaultsSettingsStorage should save and load angle unit correctly")
    func testAngleUnitStorage() throws {
        // Given
        let testUserDefaults = UserDefaults(suiteName: "test.settings.angleunit")!
        let storage = UserDefaultsSettingsStorage(userDefaults: testUserDefaults)
        let expectedAngleUnit = AngleUnit.radian
        
        // When
        storage.saveAngleUnit(expectedAngleUnit)
        let actualAngleUnit = storage.loadAngleUnit()
        
        // Then
        #expect(actualAngleUnit == expectedAngleUnit)
        
        // Cleanup
        testUserDefaults.removePersistentDomain(forName: "test.settings.angleunit")
    }
    
    @Test("UserDefaultsSettingsStorage should return default angle unit when no value stored")
    func testAngleUnitDefaultValue() throws {
        // Given
        let testUserDefaults = UserDefaults(suiteName: "test.settings.angleunit.default")!
        let storage = UserDefaultsSettingsStorage(userDefaults: testUserDefaults)
        
        // When
        let angleUnit = storage.loadAngleUnit()
        
        // Then
        #expect(angleUnit == AngleUnit.degree) // Default should be degree
        
        // Cleanup
        testUserDefaults.removePersistentDomain(forName: "test.settings.angleunit.default")
    }
    
    @Test("UserDefaultsSettingsStorage should save and load decimal places correctly")
    func testDecimalPlacesStorage() throws {
        // Given
        let testUserDefaults = UserDefaults(suiteName: "test.settings.decimalplaces")!
        let storage = UserDefaultsSettingsStorage(userDefaults: testUserDefaults)
        let expectedDecimalPlaces = 6
        
        // When
        storage.saveDecimalPlaces(expectedDecimalPlaces)
        let actualDecimalPlaces = storage.loadDecimalPlaces()
        
        // Then
        #expect(actualDecimalPlaces == expectedDecimalPlaces)
        
        // Cleanup
        testUserDefaults.removePersistentDomain(forName: "test.settings.decimalplaces")
    }
    
    @Test("UserDefaultsSettingsStorage should return default decimal places when no value stored")
    func testDecimalPlacesDefaultValue() throws {
        // Given
        let testUserDefaults = UserDefaults(suiteName: "test.settings.decimalplaces.default")!
        let storage = UserDefaultsSettingsStorage(userDefaults: testUserDefaults)
        
        // When
        let decimalPlaces = storage.loadDecimalPlaces()
        
        // Then
        #expect(decimalPlaces == 4) // Default should be 4
        
        // Cleanup
        testUserDefaults.removePersistentDomain(forName: "test.settings.decimalplaces.default")
    }
    
    @Test("UserDefaultsSettingsStorage should save and load first launch status correctly")
    func testFirstLaunchStorage() throws {
        // Given
        let testUserDefaults = UserDefaults(suiteName: "test.settings.firstlaunch")!
        let storage = UserDefaultsSettingsStorage(userDefaults: testUserDefaults)
        
        // When - Initially should be first launch
        let initialFirstLaunch = storage.isFirstLaunch()
        
        // Then
        #expect(initialFirstLaunch == true)
        
        // When - Mark as not first launch
        storage.setFirstLaunchCompleted()
        let afterSettingFirstLaunch = storage.isFirstLaunch()
        
        // Then
        #expect(afterSettingFirstLaunch == false)
        
        // Cleanup
        testUserDefaults.removePersistentDomain(forName: "test.settings.firstlaunch")
    }
    
    @Test("UserDefaultsSettingsStorage should handle invalid decimal places values")
    func testInvalidDecimalPlacesHandling() throws {
        // Given
        let testUserDefaults = UserDefaults(suiteName: "test.settings.invalid.decimal")!
        let storage = UserDefaultsSettingsStorage(userDefaults: testUserDefaults)
        
        // When - Try to save invalid values
        storage.saveDecimalPlaces(-1) // Negative value
        let negativeResult = storage.loadDecimalPlaces()
        
        storage.saveDecimalPlaces(15) // Too large value
        let largeResult = storage.loadDecimalPlaces()
        
        // Then - Should clamp to valid range
        #expect(negativeResult == 0) // Minimum value
        #expect(largeResult == 10) // Maximum value
        
        // Cleanup
        testUserDefaults.removePersistentDomain(forName: "test.settings.invalid.decimal")
    }
    
    @Test("UserDefaultsSettingsStorage should save all settings correctly")
    func testSaveAllSettings() throws {
        // Given
        let testUserDefaults = UserDefaults(suiteName: "test.settings.all")!
        let storage = UserDefaultsSettingsStorage(userDefaults: testUserDefaults)
        let settings = CalculatorSettings(
            angleUnit: .radian,
            decimalPlaces: 6,
            isFirstLaunch: false
        )
        
        // When
        storage.saveSettings(settings)
        
        // Then
        let loadedAngleUnit = storage.loadAngleUnit()
        let loadedDecimalPlaces = storage.loadDecimalPlaces()
        let loadedFirstLaunch = storage.isFirstLaunch()
        
        #expect(loadedAngleUnit == settings.angleUnit)
        #expect(loadedDecimalPlaces == settings.decimalPlaces)
        #expect(loadedFirstLaunch == settings.isFirstLaunch)
        
        // Cleanup
        testUserDefaults.removePersistentDomain(forName: "test.settings.all")
    }
    
    @Test("UserDefaultsSettingsStorage should load all settings correctly")
    func testLoadAllSettings() throws {
        // Given
        let testUserDefaults = UserDefaults(suiteName: "test.settings.load.all")!
        let storage = UserDefaultsSettingsStorage(userDefaults: testUserDefaults)
        
        // Setup some values
        storage.saveAngleUnit(.radian)
        storage.saveDecimalPlaces(8)
        storage.setFirstLaunchCompleted()
        
        // When
        let loadedSettings = storage.loadSettings()
        
        // Then
        #expect(loadedSettings.angleUnit == .radian)
        #expect(loadedSettings.decimalPlaces == 8)
        #expect(loadedSettings.isFirstLaunch == false)
        
        // Cleanup
        testUserDefaults.removePersistentDomain(forName: "test.settings.load.all")
    }
} 