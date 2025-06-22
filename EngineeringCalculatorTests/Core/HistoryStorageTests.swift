import Testing
import Foundation
@testable import EngineeringCalculator

@Suite("History Storage Tests")
struct HistoryStorageTests {
    
    // MARK: - Test Helper Methods
    
    private func createTestHistoryItem(expression: String = "2 + 3", result: Double = 5.0) -> CalculationHistory {
        return CalculationHistory(
            id: UUID(),
            expression: expression,
            result: result,
            timestamp: Date()
        )
    }
    
    // MARK: - InMemoryHistoryStorage Tests
    
    @Test("InMemoryHistoryStorage should save history item correctly")
    func testSaveHistoryItem() throws {
        // Given
        let storage = InMemoryHistoryStorage()
        let historyItem = createTestHistoryItem()
        
        // When
        try storage.saveHistory(historyItem)
        
        // Then
        let savedItems = try storage.loadRecentHistory(limit: 10)
        #expect(savedItems.count == 1)
        #expect(savedItems.first?.expression == historyItem.expression)
        #expect(savedItems.first?.result == historyItem.result)
    }
    
    @Test("InMemoryHistoryStorage should load recent history with correct limit")
    func testLoadRecentHistoryWithLimit() throws {
        // Given
        let storage = InMemoryHistoryStorage()
        
        // Save 15 history items
        for i in 1...15 {
            let item = createTestHistoryItem(expression: "\(i) + 1", result: Double(i + 1))
            try storage.saveHistory(item)
        }
        
        // When
        let recentItems = try storage.loadRecentHistory(limit: 10)
        
        // Then
        #expect(recentItems.count == 10)
        // Should be ordered by most recent first
        #expect(recentItems.first?.expression == "15 + 1")
        #expect(recentItems.last?.expression == "6 + 1")
    }
    
    @Test("InMemoryHistoryStorage should load all history correctly")
    func testLoadAllHistory() throws {
        // Given
        let storage = InMemoryHistoryStorage()
        
        // Save 5 history items
        for i in 1...5 {
            let item = createTestHistoryItem(expression: "\(i) * 2", result: Double(i * 2))
            try storage.saveHistory(item)
        }
        
        // When
        let allItems = try storage.loadAllHistory()
        
        // Then
        #expect(allItems.count == 5)
        // Should be ordered by most recent first
        #expect(allItems.first?.expression == "5 * 2")
        #expect(allItems.last?.expression == "1 * 2")
    }
    
    @Test("InMemoryHistoryStorage should delete specific history item")
    func testDeleteHistoryItem() throws {
        // Given
        let storage = InMemoryHistoryStorage()
        
        let item1 = createTestHistoryItem(expression: "1 + 1", result: 2.0)
        let item2 = createTestHistoryItem(expression: "2 + 2", result: 4.0)
        let item3 = createTestHistoryItem(expression: "3 + 3", result: 6.0)
        
        try storage.saveHistory(item1)
        try storage.saveHistory(item2)
        try storage.saveHistory(item3)
        
        // When
        try storage.deleteHistory(item2)
        
        // Then
        let remainingItems = try storage.loadAllHistory()
        #expect(remainingItems.count == 2)
        #expect(!remainingItems.contains { $0.id == item2.id })
        #expect(remainingItems.contains { $0.id == item1.id })
        #expect(remainingItems.contains { $0.id == item3.id })
    }
    
    @Test("InMemoryHistoryStorage should clear all history")
    func testClearAllHistory() throws {
        // Given
        let storage = InMemoryHistoryStorage()
        
        // Save multiple history items
        for i in 1...5 {
            let item = createTestHistoryItem(expression: "\(i) + \(i)", result: Double(i + i))
            try storage.saveHistory(item)
        }
        
        // Verify items are saved
        let itemsBeforeClear = try storage.loadAllHistory()
        #expect(itemsBeforeClear.count == 5)
        
        // When
        try storage.clearAllHistory()
        
        // Then
        let itemsAfterClear = try storage.loadAllHistory()
        #expect(itemsAfterClear.isEmpty)
    }
    
    @Test("InMemoryHistoryStorage should handle empty history correctly")
    func testEmptyHistory() throws {
        // Given
        let storage = InMemoryHistoryStorage()
        
        // When
        let recentItems = try storage.loadRecentHistory(limit: 10)
        let allItems = try storage.loadAllHistory()
        
        // Then
        #expect(recentItems.isEmpty)
        #expect(allItems.isEmpty)
    }
    
    @Test("InMemoryHistoryStorage should maintain chronological order")
    func testChronologicalOrder() throws {
        // Given
        let storage = InMemoryHistoryStorage()
        
        let now = Date()
        let item1 = CalculationHistory(id: UUID(), expression: "first", result: 1.0, timestamp: now.addingTimeInterval(-100))
        let item2 = CalculationHistory(id: UUID(), expression: "second", result: 2.0, timestamp: now.addingTimeInterval(-50))
        let item3 = CalculationHistory(id: UUID(), expression: "third", result: 3.0, timestamp: now)
        
        // Save in random order
        try storage.saveHistory(item2)
        try storage.saveHistory(item1)
        try storage.saveHistory(item3)
        
        // When
        let orderedItems = try storage.loadAllHistory()
        
        // Then
        #expect(orderedItems.count == 3)
        #expect(orderedItems[0].expression == "third")  // Most recent first
        #expect(orderedItems[1].expression == "second")
        #expect(orderedItems[2].expression == "first")  // Oldest last
    }
    
    @Test("InMemoryHistoryStorage should handle duplicate expressions")
    func testDuplicateExpressions() throws {
        // Given
        let storage = InMemoryHistoryStorage()
        
        let item1 = createTestHistoryItem(expression: "2 + 2", result: 4.0)
        let item2 = createTestHistoryItem(expression: "2 + 2", result: 4.0)
        
        // When
        try storage.saveHistory(item1)
        try storage.saveHistory(item2)
        
        // Then
        let allItems = try storage.loadAllHistory()
        #expect(allItems.count == 2) // Should allow duplicates
        #expect(allItems.allSatisfy { $0.expression == "2 + 2" })
    }
    
    @Test("InMemoryHistoryStorage should handle very long expressions and results")
    func testLongExpressionsAndResults() throws {
        // Given
        let storage = InMemoryHistoryStorage()
        
        let longExpression = String(repeating: "1234567890", count: 50) // 500 characters
        let longResult = 123456789.0 // Large number
        let item = createTestHistoryItem(expression: longExpression, result: longResult)
        
        // When
        try storage.saveHistory(item)
        
        // Then
        let savedItems = try storage.loadRecentHistory(limit: 1)
        #expect(savedItems.count == 1)
        #expect(savedItems.first?.expression == longExpression)
        #expect(savedItems.first?.result == longResult)
    }
} 