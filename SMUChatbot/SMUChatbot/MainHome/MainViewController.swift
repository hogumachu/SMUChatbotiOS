import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController {
    // MARK: - Dependency
    
    struct Dependency {
        let coordinator: Coordinator
    }
    
    private let coordinator: Coordinator
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let cardStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    private let teamStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    private let teamTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "About Team"
        return label
    }()
    private let teamCardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("채팅해조 팀이란", for: .normal)
        button.setTitleColor(.smu, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.masksToBounds = false
        return button
    }()
    private let useStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    private let useTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "How To Use"
        return label
    }()
    private let useCardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("챗봇 사용법", for: .normal)
        button.setTitleColor(.smu, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.masksToBounds = false
        return button
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
        view.backgroundColor = .systemGray4
        view.addSubview(cardStackView)
        view.addSubview(startButton)
        
        cardStackView.addArrangedSubview(teamStackView)
        cardStackView.addArrangedSubview(useStackView)
        
        teamStackView.addArrangedSubview(teamTitleLabel)
        teamStackView.addArrangedSubview(teamCardButton)
        
        useStackView.addArrangedSubview(useTitleLabel)
        useStackView.addArrangedSubview(useCardButton)
        
        teamTitleLabel.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        useTitleLabel.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        cardStackView.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(startButton.snp.top).offset(-20)
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
        teamCardButton.rx.tap
            .withUnretained(coordinator)
            .bind(
                onNext: { coordinator, _ in
                    coordinator.pushDetailTeamViewController()
                }
            )
            .disposed(by: disposeBag)
        
        useCardButton.rx.tap
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
