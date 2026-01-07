//
//  Models.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import Foundation
import SwiftUI

import Foundation
import SwiftUI

/// Represents a user-definable category.
struct CategoryModel: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var iconName: String
    var colorHex: String
    
    // Helper to get Color from hex
    var color: Color {
        Color(hex: colorHex) ?? .gray
    }
    
    // Default categories for fresh install
    static var defaults: [CategoryModel] {
        [
            CategoryModel(name: "Care", iconName: "heart.fill", colorHex: "#FF2D55"),      // Pink
            CategoryModel(name: "Order", iconName: "tray.full.fill", colorHex: "#007AFF"), // Blue
            CategoryModel(name: "Move", iconName: "archivebox.fill", colorHex: "#34C759"), // Green
            CategoryModel(name: "Housekeeping", iconName: "house.fill", colorHex: "#FF9500"), // Orange
            CategoryModel(name: "Admin", iconName: "doc.text.fill", colorHex: "#AF52DE"),  // Purple
            CategoryModel(name: "Develop", iconName: "book.fill", colorHex: "#30B0C7"),    // Teal
            CategoryModel(name: "Entertainment", iconName: "tv.fill", colorHex: "#FFCC00"), // Yellow
            CategoryModel(name: "Radar", iconName: "antenna.radiowaves.left.and.right", colorHex: "#8E8E93"), // Gray
            
            // New Categories
            CategoryModel(name: "Groceries", iconName: "cart.fill", colorHex: "#4CAF50"),  // Green
            CategoryModel(name: "Medications", iconName: "pills.fill", colorHex: "#F44336"), // Red
            CategoryModel(name: "Personal", iconName: "person.fill", colorHex: "#2196F3"), // Blue
            CategoryModel(name: "Appointments", iconName: "calendar", colorHex: "#9C27B0"), // Purple
            CategoryModel(name: "Meetings", iconName: "person.3.fill", colorHex: "#3F51B5") // Dark Blue
        ]
    }
}

/// The core data structure for the user's input
struct TaskInput {
    var title: String = ""
    var notes: String = ""
    var date: Date = Date()
    var category: CategoryModel = CategoryModel.defaults[1] // Default to "Order"
    var hasDueDate: Bool = false
}

// Helper extension for Hex Color
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    func toHex() -> String? {
        // Simple implementation for saving colors back if needed later
        // For now, we rely on the pre-defined hexes in the struct
        return nil
    }
}
