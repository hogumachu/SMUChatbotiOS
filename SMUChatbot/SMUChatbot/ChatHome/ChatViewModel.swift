import Foundation
import RxSwift
import RxCocoa

class ChatViewModel {
    private let disposeBag = DisposeBag()
    var messages: [Message] = []
    lazy var messageRelay = BehaviorRelay<[Message]>(value: messages)
    var loadingRelay = BehaviorRelay<Bool>(value: false)
    private var messageCount = 0
    
    func chatting(sendText text: String){
        sendMessage(text)
        
        ChattingImpl.shared.execute(text) { [weak self] (result: Result<Content, Error>) in
            switch result {
            case .success(let content):
                self?.receiveMessage(content.content)
            case .failure(_):
                self?.receiveMessage()
            }
        }
    }
    
    private func sendMessage(_ text: String) {
        messages.append(Message(text: text, isSender: true, dateString: DateGenerator.nowDateString()))
        messageRelay.accept(messages)
        loadingRelay.accept(true)
    }
    
    private func receiveMessage(_ text: String = "챗봇이 작동하지 않고 있습니다.") {
        let message = Message(
            text: text,
            isSender: false,
            dateString: DateGenerator.nowDateString()
        )
        
        messages.append(message)
        messageRelay.accept(messages)
        loadingRelay.accept(false)
    }
    
    func canScrollBottom() -> Bool {
        if messageCount == messages.count {
            return false
        } else {
            messageCount = messages.count
            return true
        }
    }
}
