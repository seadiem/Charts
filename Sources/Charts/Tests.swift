import Foundation

struct Testes {
    
    func testMasks() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let first = "1985-06-22"
        let one = formatter.date(from: first)!
        print(one)
        
        var mask = calendar.startOfDay(for: one)
        print(mask)
        
        let today = Date()
        print(today)
        
        mask = calendar.startOfDay(for: today)
        print(mask)
    }
    
    func testInts() {
        print(1.distance(to: 4)) // 3
        print(4.distance(to: 1)) // -3
        
        print(1.advanced(by: 3)) // 4
        print(4.advanced(by: -3)) // 1
        
        
        let x = 4
        let y = 1
        
        let n = x.distance(to: y)
        let r = x.advanced(by: n)
        print(r == y) 
    }
    
    func testDates() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let first = "1985-06-21"
        let second = "1985-06-24"
        
        let one = formatter.date(from: first)!
        let two = formatter.date(from: second)!
        
        var distance = one.distance(to: two)
        print(distance) // 3
        distance = two.distance(to: one)
        print(distance) // -3
        
        var target = one.advanced(by: 3)
        print(target) // 1985-06-25
        
        target = one.advanced(by: -3)
        print(target) // 1985-06-18
        
        let range = one...two
        print(range.count) // 4
        
        for item in range {
            print(item)
            // 21
            // 22
            // 23
            // 24
        }
    }
    

    func testChart() {
        
        var points = Set<Point>()
        
        for index in 10..<20 {
            if let point = Point(value: index, date: "1985-06-\(index)") {
                points.insert(point)
            }
        }
        
        let graph = Graph(points: points, label: "y1")
        
        
        print(graph.count) // 10
//        print(graph.arranged.count) // 10
//        print(graph.points.count) // 10
        
        for point in graph {
            print(point)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let first = "1985-06-11"
        let second = "1985-06-14"
        
        let one = formatter.date(from: first)!
        let two = formatter.date(from: second)!
        
        print("slice")
        
        let slice = graph[one...two]
        
        for point in slice {
            print(point)
            // 11
            // 12
            // 13
            // 14
        }
    }
    
    func testSlider() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let first = "1985-06-11"
        let second = "1985-06-14"
        
        let one = formatter.date(from: first)!
        let two = formatter.date(from: second)!
        
        let slider = Slider(width: 100, height: 50, begin: one, end: two)
        
        let slice = slider[10..<15]
        print(slice.count) // 5
        
        for date in slice {
            print(date)
        }
        
    }
    
    func chartExplore() {
        do {
            let charts = try File().parse()
            _  = charts[0]
        } catch {
        }
    }
    
    func testBitmap() {
        do {
            _ = try Bitmap()
        } catch {
        }
    }
    
}