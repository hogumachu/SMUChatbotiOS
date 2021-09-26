import UIKit

class ChatTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeholder = "  메시지를 입력하세요"
        layer.borderColor = UIColor.smu.cgColor
        layer.cornerRadius = 10
        layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SendButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle(" Send ", for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.font = .systemFont(ofSize: 20)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
        backgroundColor = .smu
        setTitleColor(.gray, for: .highlighted)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.2)
        separatorStyle = .none
        allowsSelection = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BackBarButtonItem: UIBarButtonItem {
    override init() {
        super.init()
        // MARK: - TODO
        // image 설정할 때 가운데 타이틀 위치로 옮겨지는 거 변경하기
//        image = UIImage(named: "backImage")
        
        title = "Back"
        style = .done
        target = self
        action = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


