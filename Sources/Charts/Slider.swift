import Foundation
#if os(macOS)
#elseif os(iOS)
import UIKit
#endif


public struct Slider {
    
    let width: Int
    let height: Int
    var dates: Range<Date>
    var selectX: Range<Int>
    var selectRect: CGRect
    var kx: Double
    
    public init(width: Int, height: Int, begin: Date, end: Date) {
        self.width = width
        self.height = height
        self.dates = begin..<end
        selectX = 0..<width / 2
        selectRect = CGRect(x: selectX.lowerBound, y: 0, width: selectX.count, height: height)
        kx = Double(width) / Double(dates.count)
    }
    
    public var sliceSlider: Slice<Slider> {
        return self[selectX]
    }
    
    
    public mutating func set(bounds: ((begin: Date, end: Date))) {
        self.dates = bounds.begin..<bounds.end
        kx = Double(width) / Double(dates.count)
    }
    
    public mutating func input(x: Int) {
        guard x < width, x > 0 else { return }
        
        let workx = selectX
        
        let divide = Int(Double(selectX.count) / 3)
        let seconfIndex = workx.startIndex + divide
        let thirdindex = seconfIndex + divide
        let two = workx[seconfIndex..<thirdindex]

        let range = selectX
        let middle = (range.upperBound - range.lowerBound) / 2 + range.lowerBound
        if two.contains(x) {
            print("drag")
        } else if x < middle {
            let temp = x..<range.upperBound
            guard temp.count > 20 else { return }
            selectX = temp
        } else {
            let temp = range.lowerBound..<x
            guard temp.count > 20 else { return }
            selectX = temp
        }
        
        selectRect = CGRect(x: selectX.lowerBound, y: 0, width: selectX.count, height: height)
    }
    
    public mutating func reset() {
        selectX = 1..<width-1
        selectRect = CGRect(x: selectX.lowerBound, y: 0, width: selectX.count, height: height)
    }
    
}

extension Slider: RandomAccessCollection {
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return width + 1
    }
    
    public subscript(position: Int) -> Date {
        let map = Double(position) / Double(kx)
        let index = dates.startIndex.advanced(by: Int(map))
        return dates[index]
    }
    
}

extension Slider: Drawable {
    public func draw(into renderer: Renderer) {
        
        #if os(macOS)
        let color = CGColor(red: 149/255, green: 98/2/255, blue: 57/2/255, alpha: 1.0)
        #elseif os(iOS)
        let color = UIColor(red: 149/255, green: 98/2/255, blue: 57/2/255, alpha: 1.0).cgColor
        #endif
        renderer.setBlend(mode: .colorDodge)
        renderer.draw(color: color, in: selectRect)
    }
}
