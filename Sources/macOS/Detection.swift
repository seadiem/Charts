import AppKit

class Detect: NSView {
    var handler: ((Int) -> ())?
    override func mouseDown(with event: NSEvent) {
        let location = event.locationInWindow
        let x = Int(location.x)
        handler?(x)
    }
}
