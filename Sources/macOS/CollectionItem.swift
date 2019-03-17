import AppKit
import Charts

class CollectionItem: NSCollectionViewItem {
    
    private let canvas = Canvas()
    
    
    func set(drawables: [Drawable]) {
        canvas.setDrawables(drawables)
    }
    
    override func loadView() {
        self.view = canvas
        self.view.wantsLayer = true
    }
    
}
