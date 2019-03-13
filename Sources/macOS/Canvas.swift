import AppKit
import Charts

class Canvas: NSView {
    
    var mousedrug: ((CGPoint) -> Void)?
    var mouseup: ((CGPoint) -> Void)?
    var mousedown: ((CGPoint) -> Void)?
    
    private var color: CGColor = CGColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0)
    
    var drawables: [Drawable] = []
    
    func setDrawables(_ d: [Drawable]) {
        drawables = d
        setNeedsDisplay(CGRect(x: 0, y: 0, width: 500, height: 500))
    }
    
    func setBack(color: CGColor) {
        self.color = color
    }
    
    override func mouseDragged(with event: NSEvent) {
        let location = event.locationInWindow
        mousedrug?(location)
    }
    
    override func mouseUp(with event: NSEvent) {
        let location = event.locationInWindow
        mouseup?(location)
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.locationInWindow
        mousedown?(location)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        draw(canvas: dirtyRect)
    }
    
    func draw(canvas: CGRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }
        
        ctx.saveGState()
        ctx.setFillColor(color)
        ctx.fill(canvas)
        ctx.restoreGState()
        
        for item in drawables {
            ctx.saveGState()
            item.draw(into: ctx)
            ctx.restoreGState()
        }
    
    }
}
