
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif


struct Fonts {
    
    #if os(macOS)
    static var h2 = NSFont.init(name: "Georgia-Bold", size: 8) ?? NSFont.systemFont(ofSize: 8)
    static var h1 = NSFont.init(name: "Georgia-Bold", size: 16) ?? NSFont.systemFont(ofSize: 16)
    #elseif os(iOS)
    static var h2 = UIFont.init(name: "Georgia-Bold", size: 8) ?? UIFont.systemFont(ofSize: 8)
    static var h1 = UIFont.init(name: "Georgia-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
    #endif
    
}
