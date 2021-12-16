import UIKit
import RxSwift
import RxCocoa
import SnapKit

class InfoViewController: UIViewController {
    struct Dependency {
        let viewModel: InfoViewModel
        let coordinator: Coordinator
    }
    
    // MARK: - Properties
    
    let viewModel: InfoViewModel
    let coordinator: Coordinator
    private let disposeBag = DisposeBag()
    private let cardStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 30
        return stack
    }()
    private let teamCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .systemGray6
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
        view.layer.masksToBounds = false
        return view
    }()
    private let teamStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .leading
        stack.spacing = 5
        return stack
    }()
    private let teamCardViewWrapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    private let teamTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "About Team"
        label.textColor = .smu
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    private let teamSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅해조 팀이란"
        label.textColor = .smu
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let useCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .systemGray6
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
        view.layer.masksToBounds = false
        return view
    }()
    private let useStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .leading
        stack.spacing = 5
        return stack
    }()
    private let useCardViewWrapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    private let useTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "How To Use"
        label.textColor = .smu
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    private let useSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "챗봇 사용법"
        label.textColor = .smu
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .smu
        button.setTitleColor(.white, for: .normal)
        button.setTitle("챗봇 시작하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 8
        button.layer.cornerCurve = .continuous
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.masksToBounds = false
        return button
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
        bind()
    }
    
    // MARK: - Configures
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(cardStackView)
        view.addSubview(startButton)
        view.addSubview(teamCardViewWrapButton)
        view.addSubview(useCardViewWrapButton)
        
        cardStackView.addArrangedSubview(teamCardView)
        cardStackView.addArrangedSubview(useCardView)
        
        teamCardView.addSubview(teamStackView)
        useCardView.addSubview(useStackView)
        
        teamStackView.addArrangedSubview(teamTitleLabel)
        teamStackView.addArrangedSubview(teamSubTitleLabel)
        
        useStackView.addArrangedSubview(useTitleLabel)
        useStackView.addArrangedSubview(useSubTitleLabel)
        
        teamStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        useStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        cardStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
        }
        
        teamCardViewWrapButton.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(teamStackView)
        }
        
        useCardViewWrapButton.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(useStackView)
        }
        
        startButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        teamCardViewWrapButton.rx.tap
            .withUnretained(coordinator)
            .bind(
                onNext: { coordinator, _ in
                    coordinator.pushDetailTeamViewController()
                }
            )
            .disposed(by: disposeBag)
        
        useCardViewWrapButton.rx.tap
            .withUnretained(coordinator)
            .bind(
                onNext: { coordinator, _ in
                    coordinator.pushDetailUseViewController()
                }
            )
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .withUnretained(coordinator)
            .bind(
                onNext: { coordinator, _ in
                    coordinator.pushChatViewController()
                }
            )
            .disposed(by: disposeBag)
    }
    
}
