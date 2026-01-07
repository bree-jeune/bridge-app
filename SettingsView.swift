//
//  SettingsView.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var categoryManager: CategoryManager
    
    // Persisted preferences
    @AppStorage("enableHaptics") var enableHaptics = true
    @AppStorage("autoShareNote") var autoShareNote = true
    @AppStorage("logHealth") var logHealth = true
    
    var body: some View {
        Form {
            Section(header: Text("Content")) {
                NavigationLink(destination: CategorySettingsView(categoryManager: categoryManager)) {
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.bridgeBlue)
                        Text("Manage Categories")
                    }
                }
            }
            
            Section(header: Text("Behavior")) {
                Toggle(isOn: $autoShareNote) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.green)
                        Text("Auto-Open Share Sheet")
                    }
                }
                
                Toggle(isOn: $enableHaptics) {
                    HStack {
                        Image(systemName: "hand.tap")
                            .foregroundColor(.orange)
                        Text("Haptic Feedback")
                    }
                }
            }
            
            Section(header: Text("Integrations")) {
                Toggle(isOn: $logHealth) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("Log 'Mindful Minutes'")
                    }
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    Text("Bridge App v1.0")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .navigationTitle("Settings")
    }
}
