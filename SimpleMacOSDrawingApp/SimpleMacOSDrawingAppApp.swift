//
//  SimpleMacOSDrawingAppApp.swift
//  SimpleMacOSDrawingApp
//
//  Created by Itsuki on 2024/12/07.
//

import SwiftUI

@main
struct SimpleMacOSDrawingAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
        
        WindowGroup(id: MousePressureDemo.identifier) {
            MousePressureDemo()
        }
        .windowResizability(.contentSize)

    }
}
