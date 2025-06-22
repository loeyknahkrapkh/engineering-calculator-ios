import Foundation

/// In-memory implementation of HistoryStorage for development and testing
final class InMemoryHistoryStorage: HistoryStorage {
    
    // MARK: - Properties
    
    private var historyItems: [CalculationHistory] = []
    private let queue = DispatchQueue(label: "com.engineeringcalculator.history", attributes: .concurrent)
    
    // MARK: - Save Operations
    
    func saveHistory(_ history: CalculationHistory) throws {
        queue.sync(flags: .barrier) {
            self.historyItems.append(history)
            // Keep items sorted by timestamp (most recent first)
            self.historyItems.sort { $0.timestamp > $1.timestamp }
        }
    }
    
    // MARK: - Load Operations
    
    func loadRecentHistory(limit: Int) throws -> [CalculationHistory] {
        return queue.sync {
            return Array(historyItems.prefix(limit))
        }
    }
    
    func loadAllHistory() throws -> [CalculationHistory] {
        return queue.sync {
            return historyItems
        }
    }
    
    // MARK: - Delete Operations
    
    func deleteHistory(_ history: CalculationHistory) throws {
        queue.sync(flags: .barrier) {
            self.historyItems.removeAll { $0.id == history.id }
        }
    }
    
    func clearAllHistory() throws {
        queue.sync(flags: .barrier) {
            self.historyItems.removeAll()
        }
    }
} 