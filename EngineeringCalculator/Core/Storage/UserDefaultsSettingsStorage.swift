import Foundation

/// UserDefaults-based implementation of SettingsStorage
final class UserDefaultsSettingsStorage: SettingsStorage {
    
    // MARK: - Properties
    
    private let userDefaults: UserDefaults
    
    // MARK: - Keys
    
    private enum Keys {
        static let angleUnit = "calculator.settings.angleUnit"
        static let decimalPlaces = "calculator.settings.decimalPlaces"
        static let isFirstLaunch = "calculator.settings.isFirstLaunch"
    }
    
    // MARK: - Constants
    
    private enum Defaults {
        static let angleUnit = AngleUnit.degree
        static let decimalPlaces = 4
        static let minDecimalPlaces = 0
        static let maxDecimalPlaces = 10
    }
    
    // MARK: - Initialization
    
    /// Initialize with custom UserDefaults instance
    /// - Parameter userDefaults: The UserDefaults instance to use for storage
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Angle Unit Settings
    
    func saveAngleUnit(_ angleUnit: AngleUnit) {
        userDefaults.set(angleUnit.rawValue, forKey: Keys.angleUnit)
    }
    
    func loadAngleUnit() -> AngleUnit {
        let rawValue = userDefaults.string(forKey: Keys.angleUnit) ?? Defaults.angleUnit.rawValue
        return AngleUnit(rawValue: rawValue) ?? Defaults.angleUnit
    }
    
    // MARK: - Decimal Places Settings
    
    func saveDecimalPlaces(_ decimalPlaces: Int) {
        let clampedValue = max(Defaults.minDecimalPlaces, min(Defaults.maxDecimalPlaces, decimalPlaces))
        userDefaults.set(clampedValue, forKey: Keys.decimalPlaces)
    }
    
    func loadDecimalPlaces() -> Int {
        guard userDefaults.object(forKey: Keys.decimalPlaces) != nil else {
            return Defaults.decimalPlaces
        }
        
        let value = userDefaults.integer(forKey: Keys.decimalPlaces)
        return max(Defaults.minDecimalPlaces, min(Defaults.maxDecimalPlaces, value))
    }
    
    // MARK: - First Launch Settings
    
    func isFirstLaunch() -> Bool {
        // If the key doesn't exist, it's the first launch
        guard userDefaults.object(forKey: Keys.isFirstLaunch) != nil else {
            return true
        }
        
        return userDefaults.bool(forKey: Keys.isFirstLaunch)
    }
    
    func setFirstLaunchCompleted() {
        userDefaults.set(false, forKey: Keys.isFirstLaunch)
    }
    
    // MARK: - Bulk Operations
    
    func saveSettings(_ settings: CalculatorSettings) {
        saveAngleUnit(settings.angleUnit)
        saveDecimalPlaces(settings.decimalPlaces)
        
        if !settings.isFirstLaunch {
            setFirstLaunchCompleted()
        }
    }
    
    func loadSettings() -> CalculatorSettings {
        return CalculatorSettings(
            angleUnit: loadAngleUnit(),
            decimalPlaces: loadDecimalPlaces(),
            isFirstLaunch: isFirstLaunch()
        )
    }
} 