import CoreGraphics

/// Для отрисовки в ячейки коллекции.
/// Нужно обязательно задать set(rect: CGRect)
public struct Item: Drawable {
    let name: String
    let select: Select
    let color: CGColor
    var rect: CGRect
    
    init(chart: Chart) {
        name = "Chart"
        select = chart.select
        color = CGColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0)
        rect = .zero
    }
    
    init(graph: Graph) {
        name = "Graph"
        select = graph.select
        color = CGColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0)
        rect = .zero
    }
    /// Задаём в методе дата соурса коллекции
    /// Так как мы знаем размер её лейаута.
    public mutating func set(rect: CGRect) { self.rect = rect }
    
    public func draw(into renderer: Renderer) {
        renderer.draw(color: color, in: rect)
        renderer.draw(text: name, at: CGPoint.zero)
    }
}
