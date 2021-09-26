import UIKit

class HeavyTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .left
        font = .systemFont(ofSize: 60, weight: .heavy)
        adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DetailLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .left
        numberOfLines = 0
        textColor = .white
        font = .systemFont(ofSize: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
