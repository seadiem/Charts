import CoreGraphics

public protocol Renderer {
    
    func draw(color: CGColor, in rect: CGRect)
    func move(to point: CGPoint)
    func line(to point: CGPoint)
    func setColor(color: CGColor)
    func fill()
    func stroke()
    func setWidth(w: Double)
    func drawPath(points: [CGPoint])
    func draw(image: CGImage, in rect: CGRect)
    func draw(text: String, at point: CGPoint)
    func setBlend(mode: CGBlendMode)
    
//    func setColor(color: CGColor)


}

public protocol Drawable {
    func draw(into renderer: Renderer)
}


