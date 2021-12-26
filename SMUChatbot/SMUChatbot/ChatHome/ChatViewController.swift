import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import SnapKit

class ChatViewController: UIViewController {
    // MARK: - Dependency
    
    struct Dependency {
        let viewModel: ChatViewModel
        let coordinator: Coordinator
    }
    
    private let viewModel: ChatViewModel
    private let coordiantor: Coordinator
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let chatTextField = ChatTextField()
    private let sendButton = SendButton()
    private let chatTableView = ChatTableView()
    private let keyboardView = UIView()
    private let backBarButtonItem = BackBarButtonItem()
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.contentMode = .scaleAspectFit
        indicator.frame = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44)).bounds
        indicator.color = .purple
        return indicator
    }()
    
    // MARK: - Lifecycles
    
    init(dependency: Dependency) {
        self.viewModel = dependency.viewModel
        self.coordiantor = dependency.coordinator
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

    override func viewWillDisappear(_ animated: Bool) {
        resignFirstResponder()
        super.viewWillAppear(animated)
    }
    
    // MARK: - Configures
    
    private func configureUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = loadingIndicator
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        chatTableView.register(ChatTableViewSenderCell.self, forCellReuseIdentifier: ChatTableViewSenderCell.identifier)
        chatTableView.register(ChatTableViewReceiverCell.self, forCellReuseIdentifier: ChatTableViewReceiverCell.identifier)
        
        view.initAutoLayout(UIViews: [chatTableView, chatTextField, sendButton, keyboardView])
        
        loadingIndicator.isHidden = true
        
        chatTextField.snp.makeConstraints  {
            $0.leading.equalTo(view.layoutMarginsGuide)
            $0.bottom.height.equalTo(sendButton)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-5)
        }
        
        sendButton.snp.makeConstraints {
            $0.trailing.equalTo(view.layoutMarginsGuide)
            $0.bottom.equalTo(keyboardView.snp.top).offset(-5)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
        
        chatTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view)
            $0.bottom.equalTo(sendButton.snp.top).offset(-5)
        }
        
        keyboardView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
            $0.top.equalTo(keyboardView.snp.bottom)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        viewModel
            .messageRelay
            .bind(to: chatTableView.rx.items) { [weak self] tableViewCell, row, item -> UITableViewCell in
                if let can = self?.viewModel.canScrollBottom(), can {
                    self?.scrollToBottom()
                }
                
                if item.isSender {
                    let cell = tableViewCell.dequeueReusableCell(withIdentifier: ChatTableViewSenderCell.identifier, for: IndexPath.init(row: row, section: 0)) as! ChatTableViewSenderCell
                    cell.set(item: item)
                    return cell
                } else {
                    let cell = tableViewCell.dequeueReusableCell(withIdentifier: ChatTableViewReceiverCell.identifier, for: IndexPath.init(row: row, section: 0)) as! ChatTableViewReceiverCell
                    cell.set(item: item)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .withUnretained(self)
            .bind(
                onNext: { vc, _ in
                    if let text = vc.chatTextField.text, !text.isEmpty {
                        vc.viewModel.chatting(sendText: text)
                        vc.chatTextField.text = ""
                    }
                }
            )
            .disposed(by: disposeBag)
        
        backBarButtonItem.rx.tap
            .withUnretained(self)
            .bind(
                onNext: { vc, _ in
                    vc.navigationController?.navigationBar.isHidden = true
                    vc.navigationController?.popViewController(animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        viewModel
            .loadingRelay
            .asDriver()
            .withUnretained(self)
            .drive(
                onNext: { vc, isLoading in
                    isLoading ? vc.startLoading() : vc.stopLoading()
                }
            )
            .disposed(by: disposeBag)
        
        RxKeyboard
            .instance
            .visibleHeight
            .withUnretained(self)
            .drive(
                onNext: { vc, height in
                    vc.updateKeyboardHeight(height: height)
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper
    
    private func scrollToBottom() {
        guard !viewModel.messages.isEmpty else { return }
        DispatchQueue.main.async {
            self.chatTableView.scrollToRow(at: IndexPath(row: self.viewModel.messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    private func startLoading() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    private func stopLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    
    private func updateKeyboardHeight(height: CGFloat) {
        keyboardView.snp.updateConstraints {
            $0.top.equalTo(keyboardView.snp.bottom).offset(-height + view.safeAreaInsets.bottom)
        }
        view.layoutIfNeeded()
    }
}

extension ChatViewController: UIScrollViewDelegate { }
