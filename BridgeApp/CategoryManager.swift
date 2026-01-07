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
                return
            }
        }
        // Fallback to defaults if nothing saved
        self.categories = CategoryModel.defaults
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
