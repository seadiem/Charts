import AppKit

class App {
    
    private let app: NSApplication
    private let delegate: AppDelegate
    
    public init() {
        app = NSApplication.shared
        delegate = AppDelegate()
        app.delegate = delegate
        app.setActivationPolicy(.regular)
    }
    
    public func run() {
        app.run()
    }
    
}
