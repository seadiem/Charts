import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    let windowcontroller = WindowController()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        windowcontroller.window?.delegate = windowcontroller
        windowcontroller.showWindow(self)
    }
}
