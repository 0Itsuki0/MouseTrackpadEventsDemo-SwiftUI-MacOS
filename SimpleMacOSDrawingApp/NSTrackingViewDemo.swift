//
//  NSTrackingViewDemo.swift
//  SimpleMacOSDrawingApp
//
//  Created by Itsuki on 2024/12/21.
//


import SwiftUI


private class TrackingView: NSView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        let label = NSTextField()
        label.frame = CGRect(origin: .zero, size: .zero)
        label.stringValue = "NS View"
        label.isBezeled = false
        label.isEditable = false
        label.sizeToFit()
        self.addSubview(label)
        
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        self.addTrackingArea(NSTrackingArea(
            rect: self.bounds,
            options: [.mouseEnteredAndExited, .activeInKeyWindow],
            owner: self, userInfo: nil)
        )
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseEntered(with event: NSEvent) {
        let locationInView = self.convert(event.locationInWindow, from: nil)
        showIndicator(at: locationInView, with: NSColor.blue.cgColor)
    }
    
    override func mouseExited(with event: NSEvent) {
        let locationInView = self.convert(event.locationInWindow, from: nil)
        showIndicator(at: locationInView, with: NSColor.green.cgColor)

    }

    
    private func showIndicator(at location: NSPoint, with color: CGColor) {
        let circleView = NSView()
        circleView.wantsLayer = true
        circleView.frame = CGRect(origin: CGPoint(x: location.x - 10, y: location.y - 10), size: CGSize(width: 20, height: 20))
        circleView.layer?.cornerRadius = 10
        circleView.layer?.backgroundColor = color
        circleView.layer?.borderColor = NSColor.white.cgColor
        self.addSubview(circleView)

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1;
            circleView.animator().alphaValue = 0;
        }, completionHandler: {
            circleView.removeFromSuperview()
        })
    }
}


private struct TrackingAreaViewRepresentable: NSViewRepresentable {

    func updateNSView(_ nsView: TrackingView, context: Context) {}

    func makeNSView(context: Context) -> TrackingView {
        let view = TrackingView()
        return view
    }
}

struct NSTrackingViewDemo: View {
    static let identifier = "NSTrackingViewDemo"

    
    var body: some View {
        VStack {
            TrackingAreaViewRepresentable()
                .background(RoundedRectangle(cornerRadius: 8).fill(.red))
                .frame(width: 300, height: 200)
        }
        .padding()
        .frame(width: 400, height: 280)
        .fixedSize()
    }
}

#Preview {
    NSTrackingViewDemo()
}
