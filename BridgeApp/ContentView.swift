//
//  ContentView.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var reminderService = ReminderService()
    @State private var taskInput = TaskInput()
    @State private var showSuccessAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $taskInput.title)
                        .font(.headline)
                    
                    ZStack(alignment: .topLeading) {
                        if taskInput.notes.isEmpty {
                            Text("Notes/Thoughts...")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $taskInput.notes)
                            .frame(minHeight: 100)
                    }
                }
                
                Section(header: Text("Category")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                        ForEach(Category.allCases) {category in
                            VStack {
                                Image(systemName: category.iconName)
                                    .font(.title2)
                                    .padding(10)
                                    .background(taskInput.category == category ? category.color : Color.gray.opacity(0.1))
                                    .foregroundColor(taskInput.category == category ? .white : category.color)
                                    .clipShape(Circle())
                                
                                Text(category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                            .onTapGesture {
                                withAnimation {
                                    taskInput.category = category
                                }
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
                
                Section(header: Text("Timing")) {
                    Toggle("Has Due Date", isOn: $taskInput.hasDueDate)
                    if taskInput.hasDueDate {
                        DatePicker("Due Date", selection: $taskInput.date)
                    }
                }
                
                Section {
                    Button(action: processAction) {
                        HStack {
                            Spacer()
                            Text("Process & Sync")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("Bridge Capture")
            .alert(isPresented: $showSuccessAlert) {
                Alert(title: Text("Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    // Reset on success
                    if alertMessage.contains("Success") {
                        taskInput = TaskInput()
                    }
                })
            }
        }
    }
    
    func processAction() {
        //1. Create Reminder
        reminderService.createReminder(from: taskInput) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    //2. Trigger Note Sharing (Optional: User can choose to skip this if they just wanted a reminder)
                    // For this workflow, open the share sheet automatically for the note part
                    ShareSheetApi.share(items: ["\(taskInput.title)\n\n(taskInput.notes)"])
                    
                    self.alertMessage = "Reminder Saved! Verify Note in Share Sheet."
                    self.showSuccessAlert = true
                    
                case .failure(let error):
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
