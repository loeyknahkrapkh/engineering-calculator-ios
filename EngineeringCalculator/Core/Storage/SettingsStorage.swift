import Foundation

/// Protocol defining the interface for settings storage operations
public protocol SettingsStorage {
    
    // MARK: - Angle Unit Settings
    
    /// Save the angle unit setting
    /// - Parameter angleUnit: The angle unit to save
    func saveAngleUnit(_ angleUnit: AngleUnit)
    
    /// Load the angle unit setting
    /// - Returns: The saved angle unit, or default value if not set
    func loadAngleUnit() -> AngleUnit
    
    // MARK: - Decimal Places Settings
    
    /// Save the decimal places setting
    /// - Parameter decimalPlaces: The number of decimal places to save (0-10)
    func saveDecimalPlaces(_ decimalPlaces: Int)
    
    /// Load the decimal places setting
    /// - Returns: The saved decimal places, or default value if not set
    func loadDecimalPlaces() -> Int
    
    // MARK: - First Launch Settings
    
    /// Check if this is the first launch of the app
    /// - Returns: true if this is the first launch, false otherwise
    func isFirstLaunch() -> Bool
    
    /// Mark the first launch as completed
    func setFirstLaunchCompleted()
    
    // MARK: - Bulk Operations
    
    /// Save all settings at once
    /// - Parameter settings: The calculator settings to save
    func saveSettings(_ settings: CalculatorSettings)
    
    /// Load all settings at once
    /// - Returns: The calculator settings with all current values
    func loadSettings() -> CalculatorSettings
} 