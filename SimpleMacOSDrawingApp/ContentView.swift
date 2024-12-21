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
                    Text("Mouse Event")
                })
                .font(.title3)
                
                Text("Demo for handling mouseDown, mouseUp, and pressureChange")
                    .font(.caption)
            }
            
            VStack(spacing: 8) {
                
                Button(action: {
                    openWindow(id: TrackpadMappingNSViewDemo.identifier)
                }, label: {
                    Text("Trackpad Mapping")
                })
                .font(.title3)
                
                Text("Demo for mapping trackpad position to view")
                    .font(.caption)
                
            }
            

            VStack(spacing: 8) {
                
                Button(action: {
                    openWindow(id: MouseTrappingDemo.identifier)
                }, label: {
                    Text("Mouse/ Cursor Trapping")
                })
                .font(.title3)
                
                Text("Demo for trapping mouse / cursor position within the window")
                    .font(.caption)

            }


        }
        .padding()
        .frame(width: 400, height: 240)
        .fixedSize()

    }
}

#Preview {
    ContentView()
}
