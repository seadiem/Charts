#if os(macOS)
import Foundation
import CoreGraphics
#elseif os(iOS)
import UIKit
#endif

struct Point: Equatable, Hashable, Comparable {
    
    
    static func makeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
    static var formatter = makeFormatter()
    
    let value: Int
    private let date: Date
    let maskDate: Date
    let datelabel: Label
    
    init(value: Int, date: Date) {
        self.value = value
        self.date = date
        let maskdate = calendar.startOfDay(for: date)
        self.maskDate = maskdate
        self.datelabel = Label(date: maskDate)
    }
    
    init?(value: Int, date: String) {
        guard let one = Point.formatter.date(from: date) else { return nil }
        self.value = value
        self.date = one
        let maskdate = calendar.startOfDay(for: one)
        self.maskDate = maskdate
        self.datelabel = Label(date: maskDate)
    }
    
    static func < (lhs: Point, rhs: Point) -> Bool {
        return lhs.maskDate < rhs.maskDate
    }
    
}

extension Point {
    struct Label: Hashable {
        static func makeFormatter() -> DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "MMM dd";
            dateFormatter.locale = Locale.current
            return dateFormatter
        }
        
        static var formatter = makeFormatter()
        
        #if os(macOS)
        static var width: Int = 35
        #elseif os(iOS)
        static var width: Int = 45
        #endif
        
        let label: String
        
        #if os(macOS)
        let back = CGColor(red: 213/255, green: 51/255, blue: 97/255, alpha: 1.0)
        #elseif os(iOS)
        let back = UIColor(red: 213/255, green: 51/255, blue: 97/255, alpha: 1.0).cgColor
        #endif
        
        
        init(date: Date) {
            label = Label.formatter.string(from: date)
        }
        
        func draw(at point: CGPoint, in renderer: Renderer) {
            let size = CGSize(width: Label.width, height: 10)
            let rect = CGRect(origin: point, size: size)
            renderer.draw(color: back, in: rect)
            
            var point = point
            point.y = point.y + 2
            point.x = point.x + 3
            renderer.draw(text: label, at: point)
        }
    }
}
