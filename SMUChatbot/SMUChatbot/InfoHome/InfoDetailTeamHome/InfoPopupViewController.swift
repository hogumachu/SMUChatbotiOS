import UIKit
import RxSwift
import SnapKit

class InfoPopupViewController: UIViewController {
    struct Dependency {
        let coordinator: Coordinator
    }
    
    
    // MARK: - Properties
    
    private let coordinator: Coordinator
    private let disposeBag = DisposeBag()
    private let popUpView = UIView()
    private let backButton = UIButton()
    private let iOSButton = UIButton()
    private let djangoButton = UIButton()
    private let iOSGitImageView: UIImageView = {
        let uiImageView = UIImageView(image: UIImage(named: "github_logo"))
        return uiImageView
    }()
    private let djangoGitImageView: UIImageView = {
        let uiImageView = UIImageView(image: UIImage(named: "github_logo"))
        return uiImageView
    }()
    private let iOSLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS"
        return label
    }()
    private let djangoLabel: UILabel = {
        let label = UILabel()
        label.text = "Django"
        return label
    }()
    private let documentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50, weight: .heavy)
        label.text = "개발 문서 보기"
        return label
    }()
    
    // MARK: Lifecycle
    
    init(dependency: Dependency) {
        self.coordinator = dependency.coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        subscribe()
    }
    
    // MARK: - Configures
    
    private func configureUI() {
        view.backgroundColor = .init(white: 0, alpha: 0.3)
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
    
    private func subscribe() {
        
        // TODO: - URL 을 따로 빼기 (ViewController 가 갖고 있는 것은 아닌 것 같음
        // vc.dismiss 보다는 coordinator 에게 모든 권한을 위임하자 ->
        // 결국 화면 전환을 Coordinator 에게 맡겼는데 viewController 가 하고 있는 것도 이상함
        iOSButton.rx.tap
            .withUnretained(self)
            .bind(
                onNext: { vc, _ in
                    vc.dismiss(animated: false, completion: nil)
                    vc.coordinator.loadWebViewController("https://github.com/hogumachu/SMUChatbotiOS")
                }
            )
            .disposed(by: disposeBag)

        djangoButton.rx.tap
            .withUnretained(self)
            .bind(
                onNext: { vc, _ in
                    vc.dismiss(animated: false, completion: nil)
                    vc.coordinator.loadWebViewController("https://github.com/hogumachu/SMUChatbot")
                }
            )
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .withUnretained(self)
            .bind(
                onNext: { vc, _ in
                    vc.dismiss(animated: false, completion: nil)
                }
            )
            .disposed(by: disposeBag)
    }
}
