import Foundation
#if os(macOS)
import CoreGraphics
#elseif os(iOS)
import UIKit
#endif

public struct Chart: Selectable, Equatable, Hashable {

    private var graphs: Array<Graph>
    private var screen = CGSize.zero
    private var selected: Range<Date>?
    private var slider: Slice<Slider>?
    private var maxy: Int
    public var showDates = true
    public var select: Select
    var howMuchDatesWeCanShow: Int
    
    
    public var bounds: (begin: Date, end: Date) {
        guard let graph = graphs.first else { return (Date(), Date()) }
        return (graph.startIndex, graph.endIndex)
    }
    
    public var count: Int { return graphs.count }
    public func itemgraph(at index: Int) -> Item {
        return graphs[index].collectionItem
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
        
        var graphs = Array<Graph>()
        
        for (name, numbers) in values {
            guard dates.indices == numbers.indices else { continue }
            var points = Set<Point>()
            let indicies = dates.indices
            for index in indicies {
                let point = Point(value: numbers[index], date: dates[index])
                points.insert(point)
            }
            let graph = Graph(points: points, label: name, color: autamatic.colors[name])
            graphs.append(graph)
        }
        
        self.graphs = graphs
        
        maxy = graphs.map { $0.maxy }.max() ?? 10
        
        self.select = .free
        self.howMuchDatesWeCanShow = 10
    }
    public var collectionItem: Item { return Item(chart: self) }
    public mutating func set(screen: CGSize) {
        self.screen = screen
        howMuchDatesWeCanShow = Int(screen.width) / Point.Label.width - 1
        if howMuchDatesWeCanShow <= 0 { howMuchDatesWeCanShow = 1 }
    }
    public mutating func set(slider: Slice<Slider>) { self.slider = slider }
    public mutating func select(at index: Int) {
        graphs.selectOnly(at: index)
        reloadMaxY()
    }
    mutating func reloadMaxY() {
        let needsToDraw = graphs.filter { $0.select == .selected }
        maxy = needsToDraw.map { $0.maxy }.max() ?? 10
    }
}

extension Chart {
    public static func == (lhs: Chart, rhs: Chart) -> Bool {
        guard lhs.graphs.isEmpty == false, lhs.graphs.isEmpty == false else { return false }
        return lhs.graphs[0] == rhs.graphs[0]
    }
    
    public func hash(into hasher: inout Hasher) {
        for item in graphs {
            guard item.count > 2 else {
                hasher.combine(maxy)
                return
            }
            let prefix = item.prefix(2)
            for item in prefix {
                hasher.combine(item)
            }
        }
    }
}

extension Chart: Drawable {
    
    public func draw(into renderer: Renderer) {
        
        guard let selected = slider, selected.isEmpty == false else { return }
        
        var drawdates = showDates
        
        #if os(macOS)
        let color = CGColor.black
        let highlight = CGColor(red: 149/255, green: 98/2/255, blue: 57/2/255, alpha: 0.7)
        #elseif os(iOS)
        let color = UIColor.black.cgColor
        let highlight = UIColor(red: 149/255, green: 98/2/255, blue: 57/2/255, alpha: 0.7).cgColor
        #endif
        
        renderer.setColor(color: color)
        renderer.setWidth(w: 1.0)
        
        let needsToDraw = graphs.filter { $0.select == .selected }
        graphsloop: for graph in needsToDraw {

            let slice = graph[selected.first!...selected.last!]
            
            let kx: CGFloat
            kx = screen.width / CGFloat(slice.count)

            let ky: CGFloat
            ky = screen.height / CGFloat(maxy)

            var drawpoints = [CGPoint]()
            var timelabels = [(label: Point.Label, index: Int)]()
            var check = 0
            var quallity: Int
            
            if slice.count < howMuchDatesWeCanShow {
                quallity = 1
            } else {
                quallity = slice.count / howMuchDatesWeCanShow + 1
            }
            
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
            
            if showDates == true {
                renderer.setWidth(w: 2)
                renderer.setColor(color: graph.color)
            }
            else {
                renderer.setColor(color: CGColor.black)
                renderer.setWidth(w: 1)
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
            
            
            guard drawdates == true else { continue graphsloop }
            
            renderer.setColor(color: highlight)
            renderer.setWidth(w: 0.5)
            
            for tuple in timelabels {
                let y: CGFloat = 0
                let x: CGFloat = CGFloat(tuple.index) * kx
                renderer.drawPath(points: [CGPoint(x: x, y: 0), CGPoint(x: x, y: screen.height)])
                tuple.label.draw(at: CGPoint(x: x, y: y), in: renderer)
                renderer.move(to: CGPoint(x: x, y: 0))
            }
            
            let height = screen.height
            let kh = Int(height / 5)
            

            for index in 1...5 {
                renderer.move(to: CGPoint(x: 0, y: kh * index))
                renderer.drawPath(points: [CGPoint(x: 0, y: kh * index), CGPoint(x: Int(screen.width), y: kh * index)])
                let value = maxy / 5 * index
                renderer.draw(text: "\(value)", at: CGPoint(x: 5, y: kh * index - 10))
            }
            
            drawdates = false
           
            
        } // end graphsloop
    }
}
