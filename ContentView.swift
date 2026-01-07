//
//  ContentView.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var reminderService = ReminderService()
    @StateObject private var categoryManager = CategoryManager()
    @StateObject private var historyManager = HistoryManager()
    @StateObject private var healthKitManager = HealthKitManager() // New Manager
    @State private var taskInput = TaskInput()
    @State private var showSuccessAlert = false
    @State private var alertMessage = ""
    
    // Preferences
    @AppStorage("enableHaptics") var enableHaptics = true
    @AppStorage("autoShareNote") var autoShareNote = true
    @AppStorage("logHealth") var logHealth = true

    // Greeting based on time of day
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good Morning" }
        if hour < 18 { return "Good Afternoon" }
        return "Good Evening"
    }
    
    private func validateCategory() {
        if !categoryManager.categories.contains(where: { $0.id == taskInput.category.id }) {
            if let first = categoryManager.categories.first {
                taskInput.category = first
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bridgeBackground.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: - Header
                        VStack(alignment: .leading) {
                            Text(greeting)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Capture Thought")
                                .premiumTitle()
                        }
                        .padding(.top, 10)
                        
                        // MARK: - Task Input Card
                        VStack(alignment: .leading, spacing: 12) {
                            TextField("What's on your mind?", text: $taskInput.title)
                                .font(.title3.weight(.medium))
                            
                            Divider()
                            
                            ZStack(alignment: .topLeading) {
                                if taskInput.notes.isEmpty {
                                    Text("Add details, context, or links...")
                                        .foregroundColor(.gray.opacity(0.8))
                                        .padding(.vertical, 8)
                                }
                                TextEditor(text: $taskInput.notes)
                                    .frame(minHeight: 80)
                                    .scrollContentBackground(.hidden) // Remove default gray background
                            }
                        }
                        .glassCard()
                        
                        // MARK: - Categories
                        VStack(alignment: .leading) {
                            Text("CATEGORY")
                                .sectionHeader()
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 15) {
                                ForEach(categoryManager.categories) { category in
                                    let isSelected = taskInput.category.id == category.id
                                    
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .fill(isSelected ? category.color : Color.white)
                                                .shadow(color: category.color.opacity(0.3), radius: isSelected ? 8 : 2)
                                            
                                            Image(systemName: category.iconName)
                                                .font(.system(size: 24))
                                                .foregroundColor(isSelected ? .white : category.color)
                                        }
                                        .frame(width: 60, height: 60)
                                        
                                        Text(category.name)
                                            .font(.caption.weight(.medium))
                                            .foregroundColor(isSelected ? .primary : .secondary)
                                    }
                                    .scaleEffect(isSelected ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.3), value: isSelected)
                                    .onTapGesture {
                                        withAnimation {
                                            taskInput.category = category
                                        }
                                        if enableHaptics {
                                            let generator = UIImpactFeedbackGenerator(style: .light)
                                            generator.impactOccurred()
                                        }
                                    }
                                }
                                
                                // Edit Categories Button - Now links to Settings which links to Edit
                                NavigationLink(destination: SettingsView(categoryManager: categoryManager)) {
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                                                .background(Circle().fill(Color.white))
                                            Image(systemName: "slider.horizontal.3")
                                                .font(.system(size: 20))
                                                .foregroundColor(.gray)
                                        }
                                        .frame(width: 60, height: 60)
                                        
                                        Text("Config")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        
                        // MARK: - Timing
                        VStack(alignment: .leading) {
                            Text("TIMING")
                                .sectionHeader()
                            
                            HStack {
                                Toggle(isOn: $taskInput.hasDueDate) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(.bridgePurple)
                                        Text("Set Due Date")
                                            .fontWeight(.medium)
                                    }
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .bridgePurple))
                            }
                            .glassCard()
                            
                            if taskInput.hasDueDate {
                                DatePicker("Select Date", selection: $taskInput.date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .glassCard()
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        
                        // MARK: - Process Button
                        Button(action: processAction) {
                            HStack {
                                Text("Process & Sync")
                                    .font(.system(size: 18, weight: .bold))
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title3)
                            }
                        }
                        .modifier(NeoButton(color: .bridgeBlue)) // Use NeoButton directly via modifier if extension fails or just simpler
                        .background(Color.premiumGradient.mask(RoundedRectangle(cornerRadius: 12))) // Gradient overlay
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 50)
                    }
                    .padding()
                }
            }
            // Use navigationBarHidden or custom toolbar
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        NavigationLink(destination: HistoryView(historyManager: historyManager)) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        
                        NavigationLink(destination: SettingsView(categoryManager: categoryManager)) {
                            Image(systemName: "gear")
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                    }
                }
            }
            .onAppear {
                validateCategory()
                // Request HealthKit Auth
                healthKitManager.requestAuthorization { success, error in
                    if let error = error {
                        print("HealthKit Auth Error: \(error.localizedDescription)")
                    }
                }
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(title: Text("Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    if alertMessage.contains("Success") {
                        let currentCat = taskInput.category
                        taskInput = TaskInput()
                        taskInput.category = currentCat
                    }
                })
            }
        }
    }
    
    func processAction() {
        if enableHaptics {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        
        reminderService.createReminder(from: taskInput) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    historyManager.addEntry(from: taskInput)
                    
                    // Log Mindful Minute (If enabled)
                    if logHealth {
                        healthKitManager.logMindfulMinute { _, _ in }
                    }
                    
                    if autoShareNote {
                        ShareSheetApi.share(items: ["\(taskInput.title)\n\n\(taskInput.notes)"])
                    }
                    
                    self.alertMessage = "Success! Reminder Saved."
                    self.showSuccessAlert = true
                case .failure(let error):
                    if enableHaptics {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.error)
                    }
                    self.alertMessage = "Error: \(error.localizedDescription)"
                    self.showSuccessAlert = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
