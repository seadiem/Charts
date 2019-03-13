import Foundation

public struct Chart {
    
    private let graphs: Set<Graph>
    private var screen = CGSize.zero
    private var selected: Range<Date>?
    private var slider: Slice<Slider>?
    private var maxy: Int
    
    public var bounds: (begin: Date, end: Date) {
        guard let graph = graphs.first else { return (Date(), Date()) }
        return (graph.startIndex, graph.endIndex)
    }
    
    public init(autamatic: File.WhatICouldDecode, manually: File.WhatIDecodeManually) {
        var xpos = [Int]()
        if let xex = manually.dict["x"] { xpos = xex }
        let dates = xpos.compactMap { Date(timeIntervalSince1970: TimeInterval(exactly: $0 / 1000)!) }
        
        var values = [String: [Int]]() // для графоф
        for key in autamatic.names.keys {
            if let val = manually.dict[key] {
                values[key] = val
            }
        }
        
        var graphs = Set<Graph>()
        
        for (name, numbers) in values {
            guard dates.indices == numbers.indices else { continue }
            var points = Set<Point>()
            let indicies = dates.indices
            for index in indicies {
                let point = Point(value: numbers[index], date: dates[index])
                points.insert(point)
            }
            let graph = Graph(points: points, label: name)
            graphs.insert(graph)
        }
        
        self.graphs = graphs
        
        maxy = graphs.map { $0.maxy }.max() ?? 10
        
    }
    
    public mutating func set(screen: CGSize) { self.screen = screen }
    public mutating func set(slider: Slice<Slider>) { self.slider = slider }

}

extension Chart: Drawable {
    
    public func draw(into renderer: Renderer) {
        

        guard let selected = slider, selected.isEmpty == false else { return }
        
        renderer.setColor(color: CGColor.black)
        renderer.setWidth(w: 1.0)
        
        for graph in self.graphs {

            
            let slice = graph[selected.first!..<selected.last!]
            
            let kx: CGFloat

            if CGFloat(slice.count) >= screen.width {
                kx = CGFloat(slice.count) / screen.width
            } else {
                kx = screen.width / CGFloat(slice.count)
            }

            let workheight = screen.height
            let ky: CGFloat

            if CGFloat(maxy) <= workheight {
                ky =  CGFloat(maxy) / workheight
            } else {
                ky = workheight / CGFloat(maxy)
            }
            
            
            var drawpoints = [CGPoint]()
            for (index, point) in slice.enumerated() {
                let y = CGFloat(point.value) * ky
                let x = CGFloat(index) * kx
                let cgpoint = CGPoint(x: x, y: y)
                drawpoints.append(cgpoint)
            }
            
            guard drawpoints.count > 0 else { continue }
            renderer.move(to: CGPoint.zero)
            var index = 1
            while index < drawpoints.endIndex {
                let first = drawpoints[index - 1]
                let second = drawpoints[index]
                renderer.drawPath(points: [first, second])
                index += 1
            }
        }
    }
}
