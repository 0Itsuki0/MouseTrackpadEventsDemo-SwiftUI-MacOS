//
//  TrackpadMappingDemo.swift
//  SimpleMacOSDrawingApp
//
//  Created by Itsuki on 2024/12/08.
//

import SwiftUI


private class TrackpadMappingView: NSView {
    @Binding private var normalizedPoints: [CGPoint]

    init(normalizedPoints: Binding<[CGPoint]>) {
        self._normalizedPoints = normalizedPoints
        super.init(frame: .zero)
        allowedTouchTypes = [.indirect]
        wantsRestingTouches = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func handleTouches(with event: NSEvent) {
        let touches = event.touches(matching: .touching, in: self)
        self.normalizedPoints = touches.map({$0.normalizedPosition})
    }

    override func touchesBegan(with event: NSEvent) {
        handleTouches(with: event)
    }

    override func touchesMoved(with event: NSEvent) {
        handleTouches(with: event)
    }
}


private struct TrackpadMappingRepresentable: NSViewRepresentable {
    @Binding private  var normalizedPoints: [CGPoint]

    init (normalizedPoints: Binding<[CGPoint]>) {
        self._normalizedPoints = normalizedPoints
    }
    func updateNSView(_ nsView: TrackpadMappingView, context: Context) {}
    func makeNSView(context: Context) -> TrackpadMappingView {
        let view = TrackpadMappingView(normalizedPoints: $normalizedPoints)
        return view
    }
}

struct TrackpadMappingNSViewDemo: View {
    @State private var normalizedPoints: [CGPoint] = []
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ForEach(0..<normalizedPoints.count, id: \.self) { index in
                    let touchPoint = normalizedPoints[index]
                    Circle()
                        .foregroundColor(Color.red)
                        .frame(width: 10, height: 10)
                        .position(CGPoint(x: proxy.size.width * touchPoint.x, y: proxy.size.height * (1-touchPoint.y)))
                }
                
                TrackpadMappingRepresentable(normalizedPoints: $normalizedPoints)
                    .background(.gray.opacity(0.3))

            }
            
        }
        .padding()
        .frame(width: 600, height: 320)
        .fixedSize()
        
    }
}

#Preview {
    TrackpadMappingNSViewDemo()
}
