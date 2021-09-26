import Foundation
import RxSwift
import RxCocoa

struct Message {
    let text: String
    let isSender: Bool
    let dateString: String
}

class ChatViewModel {
    let disposeBag = DisposeBag()
    var messages: [Message] = []
    lazy var messageRelay = BehaviorRelay<[Message]>(value: messages)
    var loadingRelay = BehaviorRelay<Bool>(value: false)
    var messageCount = 0
    // TODO: - 추후 로컬이 아닌 서버로 돌리기
    let baseUrl = "http://127.0.0.1:8000"
    
    func chatting(sendText text: String){
        messages.append(Message(text: text, isSender: true, dateString: nowDateString()))
        messageRelay.accept(messages)
        
        loadingRelay.accept(true)
        
        let urlRequest = URLRequest(url: URL(string: baseUrl + "/get_info/?data=\(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        
        URLSession.shared.rx.data(request: urlRequest)
            .subscribe(onNext: { [unowned self] data in
                let text = decodeData(data: data)
                messages.append(Message(text: text, isSender: false, dateString: nowDateString()))
                messageRelay.accept(messages)
                loadingRelay.accept(false)
            }, onError: { [unowned self] _ in
                messages.append(Message(text: "챗봇이 작동하지 않고 있습니다.", isSender: false, dateString: nowDateString()))
                messageRelay.accept(messages)
                loadingRelay.accept(false)
            }
            ).disposed(by: disposeBag)
    }
    
    private func nowDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let dateString = dateFormatter.string(from: Date())
        
        return dateString
    }
    
    private func decodeData(data: Data) -> String {
        do {
            let decoder = JSONDecoder()
            let dataString = try decoder.decode(content.self, from: data)
            return dataString.content
        } catch {
            print(error)
            return "decodeData Error"
        }
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
