public enum Select {
    case selected
    case free
    
    static prefix func ! (select: inout Select) {
        switch select {
        case .free: select = .selected
        case .selected: select = .free
        }
    }
}

public protocol Selectable {
    var select: Select { get set }
}

public extension Selectable {
    static prefix func ! (item: inout Self) {
        var select = item.select
        !select
        item.select = select
    }
}

public extension MutableCollection where Element: Selectable {
    
    mutating func selectOnly(at index: Index) {
        var item = self[index]
        !item
        self[index] = item
    }
    
    mutating func selectAndResignOthers(at index: Index) {
        var i = startIndex
        while i != endIndex {
            var item = self[i]
            item.select = .free
            self[i] = item
            i = self.index(after: i)
        }
        selectOnly(at: index)
    }
    
    var firstSelected: Element? {
        return self.first{ $0.select == .selected }
    }
}
