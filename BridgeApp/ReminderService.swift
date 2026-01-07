//
//  ReminderService.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import Foundation
import EventKit

class ReminderService: ObservableObject {
    private let eventStore = EKEventStore()
    
    @Published var isAuthorized: Bool = false
    @Published var errorMessage: String?
    
    init() {
        requestAccess()
    }
    
    func requestAccess() {
        eventStore.requestFullAccessToReminders { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Creates a reminder in the specific list matching the Category
    func createReminder(from input: TaskInput, completion: @escaping (Result<Void, Error>) -> Void) {
        guard isAuthorized else {
            completion(.failure(NSError(domain: "ReminderService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Not authorized"])))
            return
        }
        
        // Find or create the list (Calendar)
        let calendars = eventStore.calendars(for: .reminder)
        
        // Try to find a list with the exact name of the Category
        let targetList = calendars.first(where: { $0.title.lowercased() == input.category.rawValue.lowercased() })
        
        guard let list = targetList else {
            // Optional: Auto-create the list if it doesn't exist?
            // For now, we fail if the list doesn't exist to encourage setup, or we fall back to default.
            // Let's fall back to default for safety, but log it.
            let defaultList = eventStore.defaultCalendarForNewReminders()
             completion(.failure(NSError(domain: "ReminderService", code: 2, userInfo: [NSLocalizedDescriptionKey: "List '\(input.category.rawValue)' not found. Please create it in Reminders app."])))
            return
        }
        
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = input.title
        reminder.notes = input.notes
        reminder.calendar = list
        
        if input.hasDueDate {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: input.date)
            reminder.dueDateComponents = components
            reminder.addAlarm(EKAlarm(absoluteDate: input.date))
        }
        
        do {
            try eventStore.save(reminder, commit: true)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
