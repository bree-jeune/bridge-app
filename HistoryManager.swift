//
//  HistoryManager.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import Foundation
import SwiftUI

struct HistoryItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var dateCreated: Date
    var categoryName: String
    var categoryColorHex: String
}

class HistoryManager: ObservableObject {
    @Published var history: [HistoryItem] = []
    private let userDefaultsKey = "savedHistory"
    private let maxHistoryItems = 50
    
    init() {
        loadHistory()
    }
    
    func addEntry(from input: TaskInput) {
        let newItem = HistoryItem(
            title: input.title,
            dateCreated: Date(),
            categoryName: input.category.name,
            categoryColorHex: input.category.colorHex
        )
        
        // Prepend new item
        history.insert(newItem, at: 0)
        
        // Trim if needed
        if history.count > maxHistoryItems {
            history = Array(history.prefix(maxHistoryItems))
        }
        
        saveHistory()
    }
    
    func clearHistory() {
        history.removeAll()
        saveHistory()
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let decoded = try? JSONDecoder().decode([HistoryItem].self, from: data) {
                self.history = decoded
                return
            }
        }
        self.history = []
    }
}
