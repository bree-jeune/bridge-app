//
//  Models.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import Foundation
import SwiftUI

/// Represents the distinct list categories defined by the user.
enum Category: String, CaseIterable, Identifiable {
    case care = "Care"
    case order = "Order"
    case move = "Move"
    case housekeep = "Housekeep"
    case administer = "Administer"
    case develop = "Develop"
    case entertain = "Entertain"
    case radar = "Radar"
    
    var id: String { self.rawValue }
    
    /// Returns a color associated with the category (optional visual enhancement)
    var color: Color {
        switch self {
        case .care: return .pink
        case .order: return .blue
        case .move: return .green
        case .housekeep: return .orange
        case .administer: return .purple
        case .develop: return .teal
        case .entertain: return .yellow
        case .radar: return .gray
        }
    }
    
    /// A small icon name (SF Symbols) for UI
    var iconName: String {
        switch self {
        case .care: return "heart.fill"
        case .order: return "tray.full.fill"
        case .move: return "car.fill"
        case .housekeep: return "house.fill"
        case .administer: return "doc.text.fill"
        case .develop: return "book.fill"
        case .entertain: return "tv.fill"
        case .radar: return "antenna.radiowaves.left.and.right"
        }
    }
}

/// The core data structure for the user's input
struct TaskInput {
    var title: String = ""
    var notes: String = ""
    var date: Date = Date()
    var category: Category = .order // Default
    var hasDueDate: Bool = false
}
