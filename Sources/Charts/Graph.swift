import Foundation

struct Graph: RandomAccessCollection, Hashable {
    
    let label: String
    private let points: Set<Point>
    private var arranged: [Point]
    private var hashtable: [Date: Point]
    let maxy: Int
    
    init(points: Set<Point>, label: String) {
        self.points = points
        self.label = label
        self.maxy = points.max { $0.value < $1.value }?.value ?? 100
        self.arranged = points.sorted { $0 < $1 }
        var dict = [Date: Point]()
        for point in points { dict[point.maskDate] = point }
        self.hashtable = dict
    }
    
    var startIndex: Date {
        return arranged.first!.maskDate
    }
    
    var endIndex: Date {
        let date = arranged.last!.maskDate
        return date.advanced(by: 1)
    }
    
    subscript(position: Date) -> Point {
        let mask = calendar.startOfDay(for: position)
        guard let point = hashtable[mask] else { fatalError("\(position) is out of bounds in Graph") }
        return point
    }
    
    
}

