//
//  ContentView.swift
//  SimpleMacOSDrawingApp
//
//  Created by Itsuki on 2024/12/07.
//


import SwiftUI

private struct TouchPoint {
    var location: CGPoint
    var pressure: CGFloat
    var isDragging: Bool
}

private extension Path {
    
    func points(start: TouchPoint, end: TouchPoint, maxDisplacement: CGFloat) -> [TouchPoint] {
        let distance = abs(hypot(start.location.x - end.location.x, start.location.y - end.location.y))
        let totalPoints = distance/maxDisplacement
        let pressureInterval = (end.pressure - start.pressure)/totalPoints
        
        if self.description.isEmpty {
            return []
        }
        
        let timeInterval: CGFloat = 1/CGFloat(totalPoints)
        var currentTime: CGFloat = 0
        var currentPressure: CGFloat = start.pressure
        var points: [TouchPoint] = []
        
        while currentTime <= 1 {
            if let currentPoint = self.trimmedPath(from: 0, to: currentTime).currentPoint {
                points.append(TouchPoint(location: currentPoint, pressure: currentPressure, isDragging: true))
            }
            currentTime = currentTime + timeInterval
            currentPressure = currentPressure + pressureInterval
        }
        
        return points
    }
}

private class MouseTrackpadView: NSView {
    @Binding private var touchPoints: [TouchPoint]
    private var isDragging = false

    init(touchPoints: Binding<[TouchPoint]>) {
        self._touchPoints = touchPoints
        super.init(frame: .zero)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func handleEvent(with event: NSEvent) {
        let locationInView = self.convert(event.locationInWindow, from: nil)

        if !self.frame.contains(locationInView) {
            print("out of bound")
            return
        }
        
        let pressure = event.type == .leftMouseDown ? 1.0 : 1.0 + CGFloat(event.pressure)

        self.touchPoints.append(TouchPoint(
            location: CGPoint(x: locationInView.x, y: self.frame.height-locationInView.y),
            pressure: pressure,
            isDragging: isDragging && event.type == .pressure))
    }

    override func mouseDown(with event: NSEvent) {
        isDragging = true
        handleEvent(with: event)
    }
    
    override func pressureChange(with event: NSEvent) {
        if !isDragging {
            return
        }
        handleEvent(with: event)
    }

    
    override func mouseUp(with event: NSEvent) {
        isDragging = false
    }

}


private struct MouseTrackpadViewRepresentable: NSViewRepresentable {
    @Binding private  var touchPoints: [TouchPoint]

    init (touchPoints: Binding<[TouchPoint]>) {
        self._touchPoints = touchPoints
    }

    func updateNSView(_ nsView: MouseTrackpadView, context: Context) {}

    func makeNSView(context: Context) -> MouseTrackpadView {
        let view = MouseTrackpadView(touchPoints: $touchPoints)
        return view
    }
}

struct MousePressureDemo: View {
    static let identifier = "MousePressureDemo"
    
    @State private var touchPoints: [TouchPoint] = []
    
    private let baseSize = CGSize(width: 10, height: 10)
    private let circle = Circle()
    private let maxDisplacement = 0.1
    
    var body: some View {
        ZStack {
            Canvas { context, size in
                context.draw(Image(systemName: "heart.fill"), at: .zero, anchor: .topLeading)
                
                for (index, point) in touchPoints.enumerated() {
                    let rect = CGRect(origin: point.location, size: CGSize(width: baseSize.width * point.pressure, height: baseSize.height * point.pressure))
                    context.fill(circle.path(in: rect), with: .color(.red))
                    if !point.isDragging {
                        continue
                    }
                    if index > 0 {
                        let previousPoint = touchPoints[index-1]
                        let path = Path { path in
                            path.move(to: previousPoint.location)
                            path.addLine(to:point.location)
                        }
                        let points = path.points(start: previousPoint, end: point, maxDisplacement: maxDisplacement)
                        for pointOnPath in points {
                            let newRect = CGRect(origin: pointOnPath.location, size: CGSize(width: baseSize.width * pointOnPath.pressure, height: baseSize.height * pointOnPath.pressure))
                            context.fill(circle.path(in: newRect), with: .color(.red))
                        }
                    }
                }
            }
            MouseTrackpadViewRepresentable(touchPoints: $touchPoints)
                .background(.gray.opacity(0.3))
        }
        .padding()
        .contextMenu(menuItems: {
            Button(action: {
                touchPoints = []
            }, label: {
                Text("Clear Canvas")
            })
        })
        .frame(width: 600, height: 480)
        .fixedSize()

    }
}

#Preview {
    MousePressureDemo()
}
