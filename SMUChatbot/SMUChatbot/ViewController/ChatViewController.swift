import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import SnapKit

class ChatViewController: BaseViewController {
    struct Dependency {
        let viewModel: ChatViewModel
    }
    
    // MARK: - Properties
    
    let viewModel: ChatViewModel
    let chatTextField = ChatTextField()
    let sendButton = SendButton()
    let chatTableView = ChatTableView()
    let keyboardView = UIView()
    let backBarButtonItem = BackBarButtonItem()
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.contentMode = .scaleAspectFit
        indicator.frame = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44)).bounds
        indicator.color = .purple
        return indicator
    }()
    
    // MARK: - Lifecycles
    
    init(dependency: Dependency, payload: ()) {
        self.viewModel = dependency.viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillDisappear(_ animated: Bool) {
        resignFirstResponder()
        super.viewWillAppear(animated)
    }
    
    // MARK: - Configures
    
    override func configureUI() {
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.titleView = loadingIndicator
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        
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
    
    // MARK: - Subscribes
    
    override func subscribe() {
        viewModel.messageRelay.bind(to: chatTableView.rx.items) { [weak self] tableViewCell, row, item -> UITableViewCell in
            if let can = self?.viewModel.canScrollBottom() {
                if can {
                    self?.scrollToBottom()
                }
            }
           
            if item.isSender {
                let cell = tableViewCell.dequeueReusableCell(withIdentifier: ChatTableViewSenderCell.identifier, for: IndexPath.init(row: row, section: 0)) as! ChatTableViewSenderCell
                cell.chatLabel.text = item.text
                cell.dateLabel.text = item.dateString
                return cell
            } else {
                let cell = tableViewCell.dequeueReusableCell(withIdentifier: ChatTableViewReceiverCell.identifier, for: IndexPath.init(row: row, section: 0)) as! ChatTableViewReceiverCell
                cell.chatLabel.text = item.text
                cell.dateLabel.text = item.dateString
                return cell
            }
        }.disposed(by: disposeBag)
        
        sendButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                if let text = self.chatTextField.text, text != "" {
                    self.viewModel.chatting(sendText: text)
                    self.chatTextField.text = ""
                }
            }).disposed(by: disposeBag)
        
        backBarButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.navigationController?.navigationBar.isHidden = true
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.loadingRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] isLoading in
            if isLoading {
                loadingIndicator.isHidden = false
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
                loadingIndicator.isHidden = true
            }
        })
        .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardVisibleHeight in
                keyboardView.snp.updateConstraints {
                    $0.top.equalTo(keyboardView.snp.bottom).offset(-keyboardVisibleHeight + view.safeAreaInsets.bottom)
                }
                view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper
    
    func scrollToBottom() {
        guard !viewModel.messages.isEmpty else { return }
        DispatchQueue.main.async {
            self.chatTableView.scrollToRow(at: IndexPath(row: self.viewModel.messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
}

extension ChatViewController: UIScrollViewDelegate { }
