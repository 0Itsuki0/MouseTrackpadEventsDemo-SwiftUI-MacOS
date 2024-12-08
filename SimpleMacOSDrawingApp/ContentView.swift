//
//  ContentView.swift
//  SimpleMacOSDrawingApp
//
//  Created by Itsuki on 2024/12/08.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Button(action: {
                    openWindow(id: MousePressureDemo.identifier)
                }, label: {
                    Text("Drawing View")
                })
                .font(.title3)
                
                Text("Demo for handling mouseDown, mouseUp, and pressureChange")
                    .font(.caption)

            }
        }
        .padding()
        .frame(width: 320, height: 240)
        .fixedSize()

    }
}

#Preview {
    ContentView()
}
