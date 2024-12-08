# Demo for Handling Mouse and Trackpad Events (SwiftUI)

## Mouse Down, Up and Pressure Change

A simple [Drawing View](./SimpleMacOSDrawingApp/MousePressureDemo.swift) for demoing on how to
handle [mouseDown(with:)](https://developer.apple.com/documentation/appkit/nsresponder/mousedown(with:)), [mouseUp(with:)](https://developer.apple.com/documentation/appkit/nsresponder/mouseup(with:)), and [pressureChange(with:)](https://developer.apple.com/documentation/appkit/nsresponder/pressurechange(with:)) events.

![](./ReadmeAssets/mousePressureDemo.gif)

### Additional Notes & Discussion

Pure SwiftUI way for getting notified on Mouse Events can be done by using [addLocalMonitorForEvents(matching:handler:)](https://developer.apple.com/documentation/appkit/nsevent/addlocalmonitorforevents(matching:handler:)).<br>
```swift
.onAppear(perform: {
    NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .leftMouseUp, .pressure]) { event in
        print(event)
        return event
    }
})
```

However, there does not exist a built-in way for converting `CGPoint` in the window to the local view coordinate.<br>
Using `GeometryReaderProxy` like following to convert coordinates will result in a tiny shift in the y-coordinate as shown in the gif below (that may due to the window bar height?).


```swift
extension GeometryProxy {
    func convert(_ point: CGPoint, from coordinateSpace: CoordinateSpace) -> CGPoint {
        let frame = self.frame(in: coordinateSpace)
        let localViewPoint = CGPoint(x: point.x-frame.origin.x, y: point.y-frame.origin.y)
        return localViewPoint
    }
}
```

![](./ReadmeAssets/mouseEventSwiftUIApproach.gif)


For more details, please refer to [SwiftUI/MacOS: Handle Mouse/Trackpad Events (Mouse Up, Mouse Down, Pressure Change)]()

