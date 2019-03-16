import Foundation
#if os(macOS)
import CoreGraphics
#elseif os(iOS)
import UIKit
#endif

public struct Chart: Selectable {
    
    private let graphs: Set<Graph>
    private var screen = CGSize.zero
    private var selected: Range<Date>?
    private var slider: Slice<Slider>?
    private var maxy: Int
    public var showDates = true
    public var select: Select
    
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
        
        self.select = .free
    }
    
    public mutating func set(screen: CGSize) { self.screen = screen }
    public mutating func set(slider: Slice<Slider>) { self.slider = slider }

}

extension Chart: Drawable {
    
    public func draw(into renderer: Renderer) {
        

        guard let selected = slider, selected.isEmpty == false else { return }
    
        #if os(macOS)
        let color = CGColor.black
        #elseif os(iOS)
        let color = UIColor.black.cgColor
        #endif
        
        renderer.setColor(color: color)
        renderer.setWidth(w: 1.0)
        
        graphsloop: for graph in self.graphs {

            
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
            var timelabels = [(label: Point.Label, index: Int)]()
            var check = 0
            let quallity = 5
            
            for (index, point) in slice.enumerated() {
                let y = CGFloat(point.value) * ky
                let x = CGFloat(index) * kx
                let cgpoint = CGPoint(x: x, y: y)
                drawpoints.append(cgpoint)
                
                if check % quallity == 0 {
                    timelabels.append((point.datelabel, index))
                }
                
                check += 1
            }
            
            guard drawpoints.count > 0 else { continue graphsloop }
            renderer.move(to: CGPoint.zero)
            var index = 1
            while index < drawpoints.endIndex {
                let first = drawpoints[index - 1]
                let second = drawpoints[index]
                renderer.drawPath(points: [first, second])
                index += 1
            }
            
            
            guard showDates == true else { continue graphsloop }
            for tuple in timelabels {
                let y: CGFloat = 0
                let x: CGFloat = CGFloat(tuple.index) * kx
                tuple.label.draw(at: CGPoint(x: x, y: y), in: renderer)
            }
           
            
        } // end graphsloop

    }
}
