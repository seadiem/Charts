import AppKit
import Charts

class CollectionItem: NSCollectionViewItem {
    
    private let canvas: Canvas
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        canvas = Canvas()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.addSubview(canvas)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        canvas.frame = view.bounds
    }
    
    func set(drawables: [Drawable]) {
        canvas.setDrawables(drawables)
    }
    
    
}
