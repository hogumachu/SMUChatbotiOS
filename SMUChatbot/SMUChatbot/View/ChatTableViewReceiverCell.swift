import UIKit
import SnapKit
import RxSwift

class ChatTableViewReceiverCell: UITableViewCell {
    static let identifier = "ChatTableViewReceiverCell"
    
    let disposeBag = DisposeBag()
    let chatLabel = DetailLabel()
    let chatBubbleView: UIView = {
        let uiView = UIView()
        uiView.layer.masksToBounds = true
        uiView.layer.cornerRadius = 8
        return uiView
    }()
    let characterImageView: UIImageView = {
        let uiImageView = UIImageView(image: UIImage(named: "smuImage"))
        uiImageView.clipsToBounds = true
        return uiImageView
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        chatLabel.font = .systemFont(ofSize: 15)
        chatLabel.textColor = .black
        chatLabel.numberOfLines = 0
        chatLabel.lineBreakMode = .byWordWrapping
        chatLabel.backgroundColor = .clear
        chatBubbleView.backgroundColor = .white
        
        backgroundColor = .clear
        contentView.initAutoLayout(UIViews: [chatBubbleView, characterImageView, chatLabel, dateLabel])
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(chatBubbleView).offset(40)
        }
        
        chatBubbleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalTo(chatLabel.snp.bottom).offset(5)
            $0.leading.equalTo(characterImageView.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualTo(snp.trailing).offset(-100)
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(chatBubbleView)
            $0.leading.equalTo(snp.leading).offset(10)
            $0.width.height.equalTo(50)
        }
        
        chatLabel.snp.makeConstraints {
            $0.top.equalTo(chatBubbleView).offset(5)
            $0.leading.equalTo(chatBubbleView).offset(8)
            $0.trailing.equalTo(chatBubbleView).offset(-8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.height.equalTo(10)
            $0.leading.equalTo(chatBubbleView.snp.trailing).offset(10)
            $0.bottom.equalTo(chatBubbleView.snp.bottom).offset(-5)
        }
        
    }
}
