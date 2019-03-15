import UIKit

class Canvas: UIView {
    
    var mousedrug: ((CGPoint) -> Void)?
    var mouseup: ((CGPoint) -> Void)?
    var mousedown: ((CGPoint) -> Void)?
    
    var drawables: [Drawable] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setDrawables(_ d: [Drawable]) {
        drawables = d
        setNeedsDisplay(CGRect(x: 0, y: 0, width: 500, height: 500))
    }
    


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        guard let window = UIApplication.shared.delegate?.window else { return }
        let location = touch.location(in: window)
        mousedown?(location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        guard let window = UIApplication.shared.delegate?.window else { return }
        let location = touch.location(in: window)
        mousedrug?(location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        guard let window = UIApplication.shared.delegate?.window else { return }
        let location = touch.location(in: window)
        mouseup?(location)
    }
    
    
    
    override public func draw(_ rect: CGRect) {
        
        
        let canvas = rect
        guard let ctx = UIGraphicsGetCurrentContext(), let color = backgroundColor else { return }
        
        ctx.saveGState()
        ctx.setFillColor(color.cgColor)
        ctx.fill(canvas)
        ctx.restoreGState()
        
        for item in drawables {
            ctx.saveGState()
            item.draw(into: ctx)
            ctx.restoreGState()
        }
        
    }
}

