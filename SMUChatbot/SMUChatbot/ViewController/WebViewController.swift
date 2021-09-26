import UIKit
import RxSwift
import SnapKit
import WebKit

class WebViewController: BaseViewController {
    struct Dependency {
        let url: String
    }
    
    // MARK: - Properties
    
    let url: String
    let closeButton: UIButton = {
        let uiButton = UIButton()
        uiButton.setImage(UIImage(named: "closeImage"), for: .normal)
        return uiButton
    }()
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.uiDelegate = self
        return webView
    }()
    
    // MARK: - Lifecycles
    
    init(dependency: Dependency, payload: ()) {
        self.url = dependency.url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
    }
    
    // MARK: Configures
    
    override func configureUI() {
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
    
    func configureWebView() {
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    // MARK: - Subscribes
    
    override func subscribe() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension WebViewController: WKUIDelegate {}
