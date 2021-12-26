import UIKit
import RxSwift
import SnapKit
import WebKit

class WebViewController: UIViewController {
    struct Dependency {
        let url: String
        let coordiantor: Coordinator
    }
    
    // MARK: - Properties
    
    private let coordinator: Coordinator
    private let disposeBag = DisposeBag()
    private let url: String
    private let closeButton: UIButton = {
        let uiButton = UIButton()
        uiButton.setImage(UIImage(named: "closeImage"), for: .normal)
        return uiButton
    }()
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.uiDelegate = self
        return webView
    }()
    
    // MARK: - Lifecycles
    
    init(dependency: Dependency) {
        self.url = dependency.url
        self.coordinator = dependency.coordiantor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureWebView()
        subscribe()
    }
    
    // MARK: Configures
    
    private func configureUI() {
        view.initAutoLayout(UIViews: [webView, closeButton])
        view.backgroundColor = .white
        
        webView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.width.height.equalTo(70)
        }
    }
    
    private func configureWebView() {
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    // MARK: - Subscribes
    
    private func subscribe() {
        closeButton.rx.tap
            .withUnretained(self)
            .bind(
                onNext: { vc, _ in
                    vc.dismiss(animated: true, completion: nil)
                }
            )
            .disposed(by: disposeBag)
    }
}

extension WebViewController: WKUIDelegate {}
