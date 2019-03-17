import CoreGraphics

/// Для отрисовки в ячейки коллекции.
/// Нужно обязательно задать set(size: CGSize)
public struct Item: Drawable {
    let name: String
    let select: Select
    let color: CGColor
    var size: CGSize
    
    init(chart: Chart) {
        name = "Chart"
        select = chart.select
        color = CGColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0)
        size = .zero
    }
    
    init(graph: Graph) {
        name = "Graph"
        select = graph.select
        color = CGColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0)
        size = .zero
    }
    /// Задаём в методе дата соурса коллекции,
    /// так как мы знаем размер её лейаута.
    public mutating func set(size: CGSize) { self.size = size }
    
    public func draw(into renderer: Renderer) {
        let rect = CGRect(origin: .zero, size: size)
        renderer.draw(color: color, in: rect)
        renderer.draw(text: name, at: CGPoint.zero)
    }
}
