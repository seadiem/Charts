import Foundation

struct Point: Equatable, Hashable, Comparable {
    
    let value: Int
    private let date: Date
    let maskDate: Date
    
    
    init(value: Int, date: Date) {
        self.value = value
        self.date = date
        self.maskDate = calendar.startOfDay(for: date)
    }
    
    init?(value: Int, date: String) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let one = formatter.date(from: date) else { return nil }
        
        self.value = value
        self.date = one
        self.maskDate = calendar.startOfDay(for: self.date)
    }
    
    static func < (lhs: Point, rhs: Point) -> Bool {
        return lhs.maskDate < rhs.maskDate
    }
    
}
