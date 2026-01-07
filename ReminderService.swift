//
//  ReminderService.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import Foundation
import EventKit
import UIKit
import SwiftUI

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
        
        let calendars = eventStore.calendars(for: .reminder)
        // Try to find a list with the exact name of the Category
        let targetList = calendars.first(where: { $0.title.lowercased() == input.category.name.lowercased() })
        
        if let list = targetList {
            self.saveReminder(input: input, to: list, completion: completion)
        } else {
            // List doesn't exist, try to create it
            createList(for: input.category) { [weak self] result in
                switch result {
                case .success(let newList):
                    self?.saveReminder(input: input, to: newList, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func createList(for category: CategoryModel, completion: @escaping (Result<EKCalendar, Error>) -> Void) {
        let newList = EKCalendar(for: .reminder, eventStore: eventStore)
        newList.title = category.name
        newList.cgColor = UIColor(category.color).cgColor
        
        // Find the best source (e.g., iCloud or Local)
        // Default to the source of the default calendar, or the first available source
        let defaultCalendar = eventStore.defaultCalendarForNewReminders()
        let source = defaultCalendar?.source ?? eventStore.sources.first(where: { $0.sourceType == .calDAV || $0.sourceType == .local })
        
        guard let targetSource = source else {
            completion(.failure(NSError(domain: "ReminderService", code: 3, userInfo: [NSLocalizedDescriptionKey: "No suitable source found to create list."])))
            return
        }
        
        newList.source = targetSource
        
        do {
            try eventStore.saveCalendar(newList, commit: true)
            completion(.success(newList))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func saveReminder(input: TaskInput, to list: EKCalendar, completion: @escaping (Result<Void, Error>) -> Void) {
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
