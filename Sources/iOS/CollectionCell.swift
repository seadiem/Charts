import UIKit

class CollectionCell: UICollectionViewCell {
    
    let canvas = Canvas()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(canvas)
    }
    
    func set(drawables: [Drawable]) {
        canvas.setDrawables(drawables)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        canvas.frame = contentView.bounds
    }
    
}
