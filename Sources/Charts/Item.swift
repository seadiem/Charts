

#if os(macOS)
import CoreGraphics
#elseif os(iOS)
import UIKit
#endif

/// Для отрисовки в ячейки коллекции.
/// Нужно обязательно задать set(size: CGSize)
public struct Item: Drawable {
    let name: String
    let select: Select
    let color: CGColor
    let marker: CGColor
    var size: CGSize
    var iSgraph: Bool
    
    init(chart: Chart) {
        name = "Chart"
        select = chart.select
        
        #if os(macOS)
        color = CGColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0)
        marker = CGColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0)
        #elseif os(iOS)
        color = UIColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0).cgColor
        marker = UIColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0).cgColor
        #endif
        
        iSgraph = false
        size = .zero
    }
    
    init(graph: Graph) {
        name = graph.label
        select = graph.select
        
        #if os(macOS)
        color = CGColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0)
        #elseif os(iOS)
        color = UIColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0).cgColor
        #endif
        marker = graph.color
        size = .zero
        iSgraph = true
    }
    /// Задаём в методе дата соурса коллекции,
    /// так как мы знаем размер её лейаута.
    public mutating func set(size: CGSize) { self.size = size }
    
    public func draw(into renderer: Renderer) {
        let rect = CGRect(origin: .zero, size: size)
        renderer.draw(color: color, in: rect)
        if select == .selected {
            
            #if os(macOS)
            let highlight = CGColor(red: 149/255, green: 98/2/255, blue: 57/2/255, alpha: 1.0)
            #elseif os(iOS)
            let highlight = UIColor(red: 149/255, green: 98/2/255, blue: 57/2/255, alpha: 1.0).cgColor
            #endif
            
            renderer.setBlend(mode: .colorDodge)
            renderer.draw(color: highlight, in: rect)
        }
        renderer.setBlend(mode: .normal)
        
        if iSgraph {
            let markerrect = CGRect(x: 0, y: 0, width: size.width, height: 7)
            renderer.draw(color: marker, in: markerrect)
        }

        renderer.draw(text: name, at: CGPoint(x: 5, y: 2))
    }
}

