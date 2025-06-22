import Foundation

/// Protocol defining the interface for calculation history storage operations
protocol HistoryStorage {
    
    // MARK: - Save Operations
    
    /// Save a calculation history item
    /// - Parameter history: The calculation history to save
    /// - Throws: Storage error if save operation fails
    func saveHistory(_ history: CalculationHistory) throws
    
    // MARK: - Load Operations
    
    /// Load recent calculation history with a specified limit
    /// - Parameter limit: Maximum number of history items to load
    /// - Returns: Array of calculation history items, ordered by most recent first
    /// - Throws: Storage error if load operation fails
    func loadRecentHistory(limit: Int) throws -> [CalculationHistory]
    
    /// Load all calculation history
    /// - Returns: Array of all calculation history items, ordered by most recent first
    /// - Throws: Storage error if load operation fails
    func loadAllHistory() throws -> [CalculationHistory]
    
    // MARK: - Delete Operations
    
    /// Delete a specific calculation history item
    /// - Parameter history: The calculation history to delete
    /// - Throws: Storage error if delete operation fails
    func deleteHistory(_ history: CalculationHistory) throws
    
    /// Clear all calculation history
    /// - Throws: Storage error if clear operation fails
    func clearAllHistory() throws
} 