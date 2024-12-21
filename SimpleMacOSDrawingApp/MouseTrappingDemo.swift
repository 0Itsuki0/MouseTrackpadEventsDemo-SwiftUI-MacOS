//
//  MouseTrappingDemo.swift
//  SimpleMacOSDrawingApp
//
//  Created by Itsuki on 2024/12/15.
//

import SwiftUI

struct MouseTrappingDemo: View {
    static let identifier = "MouseTrappingDemo"

    private let threshold: CGFloat = 40.0
    @State private var trapping = false
    
    var body: some View {
        VStack {
            Text("✪ Hello From Itsuki ✪")
                .font(.title)

            Toggle(isOn: $trapping, label: {
                Text(trapping ? "Trapping" : "Not Traping")
            })
            .toggleStyle(.switch)
            .keyboardShortcut(.escape)
            
        }
        .padding()
        .frame(width: 600, height: 320)
        .fixedSize()
        .onAppear {
            
            NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                if !trapping {
                    return event
                }
                
                guard let windowFrame = event.window?.frame else {
                    return event
                }
            
                let screenHeight = NSScreen.main?.frame.height ?? 1000
                
                let thresholdFrame = NSRect(x: windowFrame.origin.x + threshold, y: windowFrame.origin.y + threshold, width: windowFrame.width - 2 * threshold, height: windowFrame.height - 2 * threshold)

                guard let pointOnScreen = event.window?.convertPoint(toScreen: event.locationInWindow) else {
                    return event
                }

                if thresholdFrame.contains(pointOnScreen) {
                    print("location in window")
                    return event
                }
                
                var cgPoint: CGPoint
                switch (pointOnScreen.x, pointOnScreen.y) {
                    
                case (0..<thresholdFrame.minX, 0..<thresholdFrame.minY):
                    cgPoint = CGPoint(x: thresholdFrame.minX, y: thresholdFrame.minY)
                    
                case (0..<thresholdFrame.minX, thresholdFrame.minY..<thresholdFrame.maxY):
                    cgPoint = CGPoint(x: thresholdFrame.minX, y: pointOnScreen.y)
                    
                case (0..<thresholdFrame.minX, thresholdFrame.maxY..<CGFloat.infinity):
                    cgPoint = CGPoint(x: thresholdFrame.minX, y: thresholdFrame.maxY)
                    
                case (thresholdFrame.minX..<thresholdFrame.maxX, thresholdFrame.maxY..<CGFloat.infinity):
                    cgPoint = CGPoint(x: pointOnScreen.x, y: thresholdFrame.maxY)
                    
                case (thresholdFrame.maxX..<CGFloat.infinity, thresholdFrame.maxY..<CGFloat.infinity):
                    cgPoint = CGPoint(x: thresholdFrame.maxX, y: thresholdFrame.maxY)
                    
                    
                case (thresholdFrame.maxX..<CGFloat.infinity, thresholdFrame.minY..<thresholdFrame.maxY):
                    cgPoint = CGPoint(x: thresholdFrame.maxX, y: pointOnScreen.y)
                    
                
                case (thresholdFrame.maxX..<CGFloat.infinity, 0..<thresholdFrame.minY):
                    cgPoint = CGPoint(x: thresholdFrame.maxX, y: thresholdFrame.minY)
                    
                    
                case (thresholdFrame.minX..<thresholdFrame.maxX, 0..<thresholdFrame.minY):
                    cgPoint = CGPoint(x: pointOnScreen.x, y: thresholdFrame.minY)

                case (_, _):
                    cgPoint = CGPoint(x: pointOnScreen.x, y: pointOnScreen.y)
                }

                cgPoint.y = screenHeight - cgPoint.y

                CGWarpMouseCursorPosition(cgPoint)
                return event
            }
        }
    }
}



#Preview {
    MouseTrappingDemo()
}
