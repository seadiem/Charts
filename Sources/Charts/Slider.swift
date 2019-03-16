import Foundation
#if os(macOS)
#elseif os(iOS)
import UIKit
#endif


public struct Slider {
    
    enum Movement {
        case zero
        case drug(priorx: Int)
        case left
        case right
    }
    
    let width: Int
    let height: Int
    var dates: Range<Date>
    var selectX: Range<Int>
    var selectRect: CGRect
    var kx: Double
    var movement: Movement
    
    public init(width: Int, height: Int, begin: Date, end: Date) {
        self.width = width
        self.height = height
        self.dates = begin..<end
        selectX = 0..<width / 2
        selectRect = CGRect(x: selectX.lowerBound, y: 0, width: selectX.count, height: height)
        kx = Double(width) / Double(dates.count)
        movement = .zero
    }
    
    public var sliceSlider: Slice<Slider> {
        return self[selectX]
    }
    
    public mutating func set(bounds: ((begin: Date, end: Date))) {
        self.dates = bounds.begin..<bounds.end
        kx = Double(width) / Double(dates.count)
    }
    
    public mutating func touch(x: Int) {
        guard x < width, x > 0 else { return }
        
        let workx = selectX
    
        let seconfIndex = workx.startIndex.advanced(by: 10)
        let thirdindex = workx.endIndex.advanced(by: -10)
        let middleslice = workx[seconfIndex..<thirdindex]
        let middle = (workx.upperBound - workx.lowerBound) / 2 + workx.lowerBound
        
        switch x {
        case let x where middleslice.contains(x): movement = .drug(priorx: x)
        case let x where (...middle).contains(x): movement = .left
        case let x where (middle...).contains(x): movement = .right
        default: break
        }
        
    }
    
    public mutating func input(x: Int) {
        guard x < width, x > 0 else { return }
        let range = selectX
        
        switch movement {
        case .drug(priorx: let priorx):
            movement = .drug(priorx: x)
            let delta = x - priorx
            let temp = (range.lowerBound + delta)..<(range.upperBound + delta)
            guard temp.lowerBound > 0, temp.upperBound < width else { break }
            selectX = temp
        case .left:
            guard x < range.upperBound else { break }
            let temp = x..<range.upperBound
            guard temp.count > 20 else { break }
            guard temp.lowerBound > 0, temp.upperBound < width else { break }
            selectX = temp
        case .right:
            guard x > range.lowerBound else { break }
            let temp = range.lowerBound..<x
            guard temp.count > 20 else { break }
            guard temp.lowerBound > 0, temp.upperBound < width else { break }
            selectX = temp
        case .zero: break
        }
        
        selectRect = CGRect(x: selectX.lowerBound, y: 0, width: selectX.count, height: height)
    }
    
    public mutating func up() {
        movement = .zero
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
