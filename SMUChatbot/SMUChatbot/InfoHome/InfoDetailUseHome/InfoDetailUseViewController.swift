import UIKit
import RxSwift
import SnapKit
import Kingfisher

class InfoDetailUseViewController: UIViewController {
    // MARK: - Dependency
    
    struct Dependency {
        let viewModel: InfoDetailUseViewModel
        let coordinator: Coordinator
    }
    
    private let viewModel: InfoDetailUseViewModel
    private let coordinator: Coordinator
    
    // MARK: - Properties
    
    private var currentPage = 0
    private let disposeBag = DisposeBag()
    private let imageView = AnimatedImageView()
    private let previousButton: UIButton = {
        let button = UIButton()
        button.setTitle("  이전  ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 10
        button.backgroundColor = .smu
        return button
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("  다음  ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 10
        button.backgroundColor = .smu
        return button
    }()
    private let descripLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .smu
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycles
    
    init(dependency: Dependency) {
        self.viewModel = dependency.viewModel
        self.coordinator = dependency.coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurePages()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageView.stopAnimating()
    }
    
    // MARK: - Configures
    
    private func configureUI() {
        view.backgroundColor = .white
        view.initAutoLayout(UIViews: [imageView, descripLabel, previousButton, nextButton])
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(descripLabel.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.bottom.equalTo(previousButton.snp.top).offset(-10)
        }
        
        descripLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        previousButton.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(previousButton)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
    }
    
    private func configurePages() {
        imageView.kf.setImage(with: viewModel.downloadImage(urlString: viewModel.info[currentPage].imageUrlString))
        descripLabel.text = viewModel.info[currentPage].description
    }
    
    // MARK: - Bind
    
    private func bind() {
        nextButton.rx.tap
            .withUnretained(self)
            .bind(
                onNext: { vc, _ in
                    vc.nextButtonDidTap()
                }
            )
            .disposed(by: disposeBag)
        
        previousButton.rx.tap
            .withUnretained(self)
            .bind(
                onNext: { vc, _ in
                    vc.previousButtonDidTap()
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - helper
    
    private func nextButtonDidTap() {
        let order = viewModel.changePage(next: currentPage + 1)
        switch order {
        case .inPage:
            currentPage += 1
            configurePages()
        case .popViewController:
            navigationController?.popViewController(animated: true)
        case .chatViewController:
            navigationController?.popViewController(animated: false)
            coordinator.pushChatViewController()
        }
    }
    
    private func previousButtonDidTap() {
        let order = viewModel.changePage(next: currentPage - 1)
        switch order {
        case .inPage:
            currentPage -= 1
            configurePages()
        case .popViewController:
            navigationController?.popViewController(animated: true)
        case .chatViewController:
            navigationController?.popViewController(animated: false)
            coordinator.pushChatViewController()
        }
    }
}
