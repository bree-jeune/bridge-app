//
//  BridgeAppApp.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import SwiftUI

@main
struct BridgeApp: App {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                OnboardingView()
            } else {
                ContentView()
            }
        }
    }
}
