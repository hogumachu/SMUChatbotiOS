import RxSwift

class MainViewModel {
    // Animation 진행 전에 alpha 를 0 으로 설정해야 정상적으로 동작함
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
}
