//
//  HealthKitManager.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    
    // Check if HealthKit is available on this device
    var isHealthDataAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard isHealthDataAvailable else {
            completion(false, NSError(domain: "BridgeApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit not available"]))
            return
        }
        
        guard let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            completion(false, NSError(domain: "BridgeApp", code: 2, userInfo: [NSLocalizedDescriptionKey: "Mindful Session type not found"]))
            return
        }
        
        let typesToShare: Set = [mindfulType]
        let typesToRead: Set = [mindfulType]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            completion(success, error)
        }
    }
    
    func logMindfulMinute(completion: @escaping (Bool, Error?) -> Void) {
        guard isHealthDataAvailable else { return }
        
        guard let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else { return }
        
        // Log 1 minute for "Mindful Capture"
        let startTime = Date().addingTimeInterval(-60) // Started 1 min ago
        let endTime = Date()
        
        let mindfulSample = HKCategorySample(type: mindfulType, value: 0, start: startTime, end: endTime)
        
        healthStore.save(mindfulSample) { success, error in
            print("HealthKit Save Success: \(success)")
            completion(success, error)
        }
    }
}
