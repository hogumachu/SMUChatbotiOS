# SMUChatbot 
* [Project History](https://github.com/hogumachu/ToyProjects/projects/1)

## MainViewController
<img src = "https://user-images.githubusercontent.com/74225754/133364878-2038145c-4110-418b-b003-9e0491ff8786.gif" width="30%" height="30%"> 

* 순차적으로 애니메이션을 줘서 시작화면을 구성하였음

```swift
// MainViewController
func nextViewController() {
    Observable.concat([
        viewModel.appear(smuLabel, duration: 1),
        viewModel.appear(capstoneLabel, duration: 1),
        viewModel.appear(teamNameLabel, duration: 1),
        gotoInfoView()
    ]).subscribe()
    .disposed(by: disposeBag)
}
```
* `MainViewController` 에 `nextViewController` 에 `concat` 으로 `viewModel` 에 있는 `appear` 를 진행 후 `gotoInfoView` 함수 실행
*  `gotoInfoView` 는 단순하게 `coordinator` 에 있는 `gotoInfoViewController` 를 호출하는 함수

```swift
// MainViewModel
func appear(_ label: UILabel, duration: TimeInterval) -> Observable<Void> {
    return Observable.create { observer -> Disposable in
        UIView.animate(withDuration: duration, animations: {
            label.alpha = 1
        }, completion: { _ in
            observer.onNext(())
            observer.onCompleted()
        })
        return Disposables.create()
    }
}
```
* `MainViewModel` 에 있는 `appear`
* `label` 과 `duration` 을 받고 해당 시간 동안 alpha 값을 1로 변경함
* Animation 이 진행하기 전에 alpha 가 0 으로 설정해야 정상적으로 동작 (alpha 0 -> 1 로 가는 animation 이므로)


## InfoViewController

<img src = "https://user-images.githubusercontent.com/74225754/133364875-b18ca2e5-85da-479d-856c-e008440e82bf.gif" width="30%" height="30%"> 

* `CollectionView` 로 구성
* 우측으로 페이지를 넘길 수 있다는 것을 인지시키기 위해 cell 너비를 작게함 (다음 cell 이 어느 정도 보이도록)
* 가장 상단에 `titleLabel` 과 하단에 `detailLabel` 그리고 `titleLabel` 의 `text` 를 동일하게 받는 `imageView` 를 구성
* `imageView`는 그림자로 입체감을 주었음
* cell 의 가장 우측에는 챗봇을 시작할 수 있는 cell 로 설정


## ChatViewController

<img src = "https://user-images.githubusercontent.com/74225754/133364871-6711d6dd-aa79-4996-b74a-6b1cc5dc4196.gif" width="30%" height="30%"> 

* 일반 채팅 어플과 비슷한 느낌으로 구성함
* 텍스트, 말풍선, 타임스탬프로 구성
* `navigationItem` 에는 데이터를 가져오는 중이라고 알리기 위해 가운데에 `loadingIndicator` 를 넣었음
* `loadingIndicator` 에 대한 동작은 viewModel 에 있는 `loadingRelay` 를 `viewController` 가 subscribe 함


```swift
// ChatViewModel
func chatting(sendText text: String){
    // 사용자의 메시지를 저장함
    messages.append(Message(text: text, isSender: true, dateString: nowDateString()))
    messageRelay.accept(messages)

    // 그 후 loadingRelay 에 true 를 줘서 ViewController 에게 로딩을 시작하라고 알림
    loadingRelay.accept(true)

    // 메시지 요청
    let urlRequest = URLRequest(url: URL(string: baseUrl + "/get_info/?data=\(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)

    URLSession.shared.rx.data(request: urlRequest)
        .subscribe(onNext: { [unowned self] data in
            // 메시지를 정상적으로 가져오면
            let text = decodeData(data: data)
            // 메시지를 추가하고
            messages.append(Message(text: text, isSender: false, dateString: nowDateString()))
            messageRelay.accept(messages)
            // 로딩이 끝났다고 알림
            loadingRelay.accept(false)
        }, onError: { [unowned self] _ in
            // 에러가 나면 에러 메시지를 추가하고
            messages.append(Message(text: "챗봇이 작동하지 않고 있습니다.", isSender: false, dateString: nowDateString()))
            messageRelay.accept(messages)
            // 로딩이 끝났다고 알림
            loadingRelay.accept(false)
        }
        ).disposed(by: disposeBag)
}
```

<img src = "https://user-images.githubusercontent.com/74225754/133364850-0b4c48df-1e37-4d8b-af03-61adee69a626.gif" width="30%" height="30%"> 

* 메시지가 새로 추가되면 cell 의 가장 하단 (최신 메시지) 으로 자동으로 스크롤

```swift
// ChatViewController
func scrollToBottom() {
    guard !viewModel.messages.isEmpty else { return }
    DispatchQueue.main.async {
        self.chatTableView.scrollToRow(at: IndexPath(row: self.viewModel.messages.count - 1, section: 0), at: .bottom, animated: true)
    }
}
```

```swift
viewModel.messageRelay.bind(to: chatTableView.rx.items) { [weak self] tableViewCell, row, item -> UITableViewCell in
      if let can = self?.viewModel.canScrollBottom() {
          // viewModel 에 있는 canScrollBottom 이 true 이면 scrollToBottom 함수를 호출함
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
```
