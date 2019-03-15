#if canImport(Appkit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension CGContext {
    
    func testDraw() {
        #if os(macOS)
        setFillColor(CGColor(red: 183/255, green: 1, blue: 1, alpha: 1.0))
        fill(CGRect(x: 0, y: 0, width: 100, height: 100))
        #elseif os(iOS)
        #endif
    }
    
    func stroke() {
        strokePath()
    }
    func fill() {
        fillPath(using: CGPathFillRule.winding)
    }
    
    func line(to point: CGPoint) {
        print("line to: \(point)")
        addLine(to: point)
    }
    
    func draw(color: CGColor, in rect: CGRect) {
        setFillColor(color)
        fill(rect)
    }
    
    func setWidth(w: Double) {
        setLineWidth(CGFloat(w))
    }
    func setColor(color: CGColor) {
        setStrokeColor(color)
        setFillColor(color)
    }
    func drawPath(points: [CGPoint]) {
        strokeLineSegments(between: points)
    }
    
    func arc(center: CGPoint, from fromangel: Double, to toangel: Double, radius: Double) {
        addArc(center: center, radius: CGFloat(radius), startAngle: CGFloat(fromangel), endAngle: CGFloat(toangel), clockwise: false)
    }
    
    func draw(image: CGImage, in rect: CGRect) {
        draw(image, in: rect)
    }
    
    func draw(text: String, at point: CGPoint) {
        let lineText = NSMutableAttributedString(string: text)
        
        #if os(macOS)
        let demofont = NSFont.init(name: "Georgia-Bold", size: 8)
        let color = CGColor.white
        #elseif os(iOS)
        let demofont = UIFont.init(name: "Georgia-Bold", size: 8)
        let color = UIColor.white.cgColor
        #endif
        
        
        lineText.addAttributes([NSAttributedString.Key.font : demofont!,
                                NSAttributedString.Key.foregroundColor: color],
                               range: NSMakeRange(0,lineText.length))
        let lineToDraw: CTLine = CTLineCreateWithAttributedString(lineText)
        setTextDrawingMode(.fill)
        textPosition = point
        CTLineDraw(lineToDraw, self)
    }
    
    func setBlend(mode: CGBlendMode) {
        setBlendMode(mode)
    }
}

extension CGContext: Renderer {}

