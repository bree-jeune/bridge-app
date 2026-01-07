//
//  CategoryManager.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import Foundation
import Combine

class CategoryManager: ObservableObject {
    @Published var categories: [CategoryModel] = []
    
    private let userDefaultsKey = "savedCategories"
    
    init() {
        loadCategories()
    }
    
    func loadCategories() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let decoded = try? JSONDecoder().decode([CategoryModel].self, from: data) {
                self.categories = decoded
                migrateLegacyCategories() // Check for updates
                return
            }
        }
        // Fallback to defaults if nothing saved
        self.categories = CategoryModel.defaults
    }
    
    private func migrateLegacyCategories() {
        var hasChanges = false
        
        // 1. Rename: Housekeep -> Housekeeping
        if let idx = categories.firstIndex(where: { $0.name == "Housekeep" }) {
            categories[idx].name = "Housekeeping"
            hasChanges = true
        }
        
        // 2. Rename: Administer -> Admin
        if let idx = categories.firstIndex(where: { $0.name == "Administer" }) {
            categories[idx].name = "Admin"
            hasChanges = true
        }
        
        // 3. Rename: Entertain -> Entertainment
        if let idx = categories.firstIndex(where: { $0.name == "Entertain" }) {
            categories[idx].name = "Entertainment"
            hasChanges = true
        }
        
        // 4. Update Icon: Move (car.fill -> archivebox.fill)
        if let idx = categories.firstIndex(where: { $0.name == "Move" && $0.iconName == "car.fill" }) {
            categories[idx].iconName = "archivebox.fill"
            hasChanges = true
        }
        
        // 5. Add Missing Categories (Groceries, Medications, Personal, Appointments, Meetings)
        let targets = ["Groceries", "Medications", "Personal", "Appointments", "Meetings"]
        for target in targets {
            if !categories.contains(where: { $0.name == target }) {
                // Find the default for this target
                if let defaultCat = CategoryModel.defaults.first(where: { $0.name == target }) {
                    categories.append(defaultCat)
                    hasChanges = true
                }
            }
        }
        
        if hasChanges {
            saveCategories()
        }
    }
    
    func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func addCategory(name: String, icon: String, colorHex: String) {
        let newCategory = CategoryModel(name: name, iconName: icon, colorHex: colorHex)
        categories.append(newCategory)
        saveCategories()
    }
    
    func deleteCategory(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
        saveCategories()
        
        // Ensure we don't end up with empty list?
        if categories.isEmpty {
            categories = CategoryModel.defaults
            saveCategories()
        }
    }
}
