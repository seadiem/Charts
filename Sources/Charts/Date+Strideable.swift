import Foundation

let calendar = createCalendar()

func createCalendar() -> Calendar {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(abbreviation: "UTC")!
    return cal
}

extension Date: Strideable {
    
    public typealias Stride = Int
    
    public func distance(to other: Date) -> Int {
        let currentmask = calendar.startOfDay(for: self)
        let targetmask = calendar.startOfDay(for: other)
        
        var result = 0
        var curent = currentmask
        
        if self < other {
            while curent < targetmask {
                curent = calendar.date(byAdding: .day, value: 1, to: curent)!
                result += 1
            }
        } else {
            while curent > targetmask {
                curent = calendar.date(byAdding: .day, value: -1, to: curent)!
                result -= 1
            }
        }
        
        
        return result
    }
    
    public func advanced(by n: Int) -> Date {
        let currentmask = calendar.startOfDay(for: self)
        var index = 0
        var current = currentmask
        
        if n > 0 {
            while index < n {
                current = calendar.date(byAdding: .day, value: 1, to: current)!
                index += 1
            }
        } else {
            while index > n {
                current = calendar.date(byAdding: .day, value: -1, to: current)!
                index -= 1
            }
        }
        
        return current
    }
}
