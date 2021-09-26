import UIKit
import RxSwift
import SnapKit
import Kingfisher

class InfoDetailUseViewController: BaseViewController {
    struct Dependency {
        let viewModel: InfoDetailUseViewModel
    }
    
    // MARK: - Properties
    
    let viewModel: InfoDetailUseViewModel
    let imageView = AnimatedImageView()
    let previousButton: UIButton = {
        let button = UIButton()
        button.setTitle("  이전  ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 10
        button.backgroundColor = .smu
        return button
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("  다음  ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 10
        button.backgroundColor = .smu
        return button
    }()
    var currentPage = 0
    let descripLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .smu
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycles
    
    init(dependency: Dependency, payload: ()) {
        self.viewModel = dependency.viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageView.stopAnimating()
    }
    
    // MARK: - Configures
    
    override func configureUI() {
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
    
    func configurePages() {
        imageView.kf.setImage(with: viewModel.downloadImage(urlString: viewModel.info[currentPage].imageUrlString))
        descripLabel.text = viewModel.info[currentPage].description
    }
    
    // MARK: - Subscribes
    
    override func subscribe() {
        nextButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                buttonAction(1)
            })
            .disposed(by: disposeBag)
        
        previousButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                buttonAction(-1)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - helper
    
    func buttonAction(_ num: Int) {
        let order = viewModel.changePage(next: currentPage + num)
        switch order {
        case .inPage:
            currentPage += num
            configurePages()
        case .popViewController:
            navigationController?.popViewController(animated: true)
        case .chatViewController:
            navigationController?.popViewController(animated: false)
            coordinator?.infoDetailViewSelected(cellNumber: 2)
        }
    }
}
