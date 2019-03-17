import AppKit

@available(OSX 10.11, *)
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    let windowcontroller = WindowController()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        windowcontroller.window?.delegate = windowcontroller
        windowcontroller.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }
}
