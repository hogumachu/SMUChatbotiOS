import UIKit
import RxSwift
import SnapKit
import Kingfisher

class InfoDetailTeamViewController: BaseViewController {
    struct Dependency {
        let viewModel: InfoDetailTeamViewModel
    }
    
    // MARK: - Properties
    
    let viewModel: InfoDetailTeamViewModel
    let imageView = AnimatedImageView()
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
    let infoButton: UIButton = {
        let button = UIButton()
        button.setTitle("  정보  ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 10
        button.backgroundColor = .smu
        button.isHidden = true
        return button
    }()
    var currentPage = 0
    
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
    
    // MARK: - Configures
    
    override func configureUI() {
        view.backgroundColor = .white
        view.initAutoLayout(UIViews: [imageView, nextButton, infoButton])
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        infoButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
    }
    
    func configurePages() {
        imageView.kf.setImage(with: viewModel.downloadImage(urlString: viewModel.info[currentPage]))
    }
    
    // MARK: - Subscribes
    
    override func subscribe() {
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.nextButtonAction()
            })
            .disposed(by: disposeBag)
        
        infoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.infoButtonAction()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper
    
    func infoButtonAction() {
        coordinator?.infoPopup()
    }
    
    func nextButtonAction() {
        if viewModel.changePage(next: currentPage + 1) {
            currentPage += 1
            configurePages()
            if currentPage == viewModel.info.count - 1 {
                infoButton.isHidden = false
            }
        } else {
            coordinator?.navigationController?.popViewController(animated: true)
        }
    }
}
