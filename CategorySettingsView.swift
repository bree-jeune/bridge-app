//
//  CategorySettingsView.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import SwiftUI

struct CategorySettingsView: View {
    @ObservedObject var categoryManager: CategoryManager
    @State private var showingAddCategory = false
    
    var body: some View {
        List {
            ForEach(categoryManager.categories) { category in
                HStack {
                    Image(systemName: category.iconName)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(category.color)
                        .clipShape(Circle())
                    
                    Text(category.name)
                        .font(.body)
                }
            }
            .onDelete(perform: categoryManager.deleteCategory)
        }
        .navigationTitle("Manage Categories")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddCategory = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView(categoryManager: categoryManager)
        }
    }
}

struct AddCategoryView: View {
    @ObservedObject var categoryManager: CategoryManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedColorHex: String = "#007AFF"
    @State private var selectedIcon: String = "tag.fill"
    
    let availableColors = [
        "#FF2D55", // Pink
        "#007AFF", // Blue
        "#34C759", // Green
        "#FF9500", // Orange
        "#AF52DE", // Purple
        "#30B0C7", // Teal
        "#FFCC00", // Yellow
        "#8E8E93"  // Gray
    ]
    
    let availableIcons = [
        "heart.fill",
        "tray.full.fill",
        "car.fill",
        "house.fill",
        "doc.text.fill",
        "book.fill",
        "tv.fill",
        "antenna.radiowaves.left.and.right",
        "tag.fill",
        "star.fill",
        "flag.fill",
        "location.fill"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Category Name", text: $name)
                }
                
                Section(header: Text("Icon")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 10) {
                        ForEach(availableIcons, id: \.self) { icon in
                            Image(systemName: icon)
                                .font(.title2)
                                .padding(10)
                                .background(selectedIcon == icon ? Color.gray.opacity(0.3) : Color.clear)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedIcon = icon
                                }
                        }
                    }
                    .padding(.vertical, 5)
                }
                
                Section(header: Text("Color")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 10) {
                        ForEach(availableColors, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex) ?? .gray)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: selectedColorHex == hex ? 3 : 0)
                                )
                                .onTapGesture {
                                    selectedColorHex = hex
                                }
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("New Category")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        categoryManager.addCategory(name: name, icon: selectedIcon, colorHex: selectedColorHex)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
