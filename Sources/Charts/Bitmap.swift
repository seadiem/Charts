import Foundation

public struct Bitmap: Drawable {
    
    let rectangle: CGRect
    let image: CGImage
    
    public init() throws {
        let url = try File().findFileDummyBitmap() as NSURL
        let cfurl = url as CFURL
        let source = CGImageSourceCreateWithURL(cfurl, nil)!
        let image = CGImageSourceCreateImageAtIndex(source, 0, nil)!
        self.image = image
        self.rectangle = CGRect(x: 0, y: 0, width: 400, height: 50)
    }
    
    
    public init(drawable: Drawable, in size: CGSize) {
        let width = Int(size.width)
        let height = Int(size.height)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * width,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: bitmapInfo.rawValue)
        drawable.draw(into: context!)
        let image = context!.makeImage()!
        self.image = image
        self.rectangle = CGRect(origin: .zero, size: size)
    }
    
    
    public func draw(into renderer: Renderer) {
        renderer.draw(image: image, in: rectangle)
    }
    
}
