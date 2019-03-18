import CoreGraphics
import Foundation

struct Color {
    
     func convert(hexString:String) -> (red: CGFloat, green: CGFloat, blue: CGFloat)  {
        
        let s = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        let scanner = Scanner(string: s)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        return (red:red, green:green, blue:blue)
    }
    
    
    #if os(iOS)
    #elseif os(macOS)
    func color(from string: String) -> CGColor {
        let tuple = convert(hexString: string)
        return CGColor(red: tuple.red, green: tuple.green, blue: tuple.blue, alpha: 1.0)
    }
    #endif
}
