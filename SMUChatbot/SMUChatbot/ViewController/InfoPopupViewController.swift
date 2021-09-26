import UIKit
import RxSwift
import SnapKit

class InfoPopupViewController: BaseViewController {
    
    // MARK: - Properties
    
    let popUpView = UIView()
    let backButton = UIButton()
    let iOSButton = UIButton()
    let djangoButton = UIButton()
    let iOSGitImageView: UIImageView = {
        let uiImageView = UIImageView(image: UIImage(named: "github_logo"))
        return uiImageView
    }()
    let djangoGitImageView: UIImageView = {
        let uiImageView = UIImageView(image: UIImage(named: "github_logo"))
        return uiImageView
    }()
    let iOSLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS"
        return label
    }()
    let djangoLabel: UILabel = {
        let label = UILabel()
        label.text = "Django"
        return label
    }()
    let documentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50, weight: .heavy)
        label.text = "개발 문서 보기"
        return label
    }()
    
    // MARK: - Configures
    
    override func configureUI() {
        view.backgroundColor = .init(white: 0, alpha: 0.3)
        // view에 넣는 순서 중요
        view.initAutoLayout(UIViews: [backButton, popUpView])
        popUpView.layer.cornerRadius = 20
        popUpView.backgroundColor = .white
        
        popUpView.initAutoLayout(UIViews: [documentLabel, iOSGitImageView, iOSLabel, djangoGitImageView, djangoLabel, iOSButton, djangoButton])
        
        backButton.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        popUpView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(documentLabel.snp.width).offset(10)
            $0.height.equalTo(documentLabel.snp.height).offset(120)
        }
        
        iOSButton.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(iOSGitImageView)
            $0.trailing.equalTo(iOSLabel)
        }
        djangoButton.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(djangoGitImageView)
            $0.trailing.equalTo(djangoLabel)
        }
        documentLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(5)
        }

        iOSGitImageView.snp.makeConstraints {
            $0.top.equalTo(documentLabel.snp.bottom).offset(10)
            $0.leading.equalTo(documentLabel)
            $0.width.height.equalTo(40)
        }

        iOSLabel.snp.makeConstraints {
            $0.centerY.equalTo(iOSGitImageView)
            $0.leading.equalTo(iOSGitImageView.snp.trailing).offset(10)
        }

        djangoGitImageView.snp.makeConstraints {
            $0.top.equalTo(iOSGitImageView.snp.bottom).offset(10)
            $0.leading.equalTo(iOSGitImageView)
            $0.width.height.equalTo(40)
        }

        djangoLabel.snp.makeConstraints {
            $0.centerY.equalTo(djangoGitImageView)
            $0.leading.equalTo(djangoGitImageView.snp.trailing).offset(10)
        }
    }
    
    // MARK: - Subscribes
    
    override func subscribe() {
        iOSButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
                self?.coordinator?.loadWebViewController("https://github.com/hogumachu/ToyProjects")
            })
            .disposed(by: disposeBag)

        djangoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
                self?.coordinator?.loadWebViewController("https://github.com/hogumachu/SMUChatbot")
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
