import UIKit
import RxSwift
import SnapKit

class MainViewController: BaseViewController {
    struct Dependency {
        let viewModel: MainViewModel
    }
    
    // MARK: - Properties
    
    let viewModel: MainViewModel
    let smuLabel = HeavyTitleLabel()
    let capstoneLabel = HeavyTitleLabel()
    let teamNameLabel = HeavyTitleLabel()
    
    // MARK: - Lifecycles
    
    init(dependency: Dependency, payload: ()) {
        viewModel = dependency.viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nextViewController()
    }
    
    // MARK: - Configures
    
    override func configureUI() {
        smuLabel.text = "상명대학교"
        smuLabel.textColor = .white
        smuLabel.alpha = 0
        
        capstoneLabel.text = "캡스톤디자인"
        capstoneLabel.textColor = .white
        capstoneLabel.alpha = 0
        
        teamNameLabel.text = "채팅해조"
        teamNameLabel.textColor = .white
        teamNameLabel.alpha = 0
        
        view.backgroundColor = .smu
        view.initAutoLayout(UIViews: [smuLabel, capstoneLabel, teamNameLabel])
        
        smuLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        capstoneLabel.snp.makeConstraints {
            $0.top.equalTo(smuLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(smuLabel)
        }
        
        teamNameLabel.snp.makeConstraints {
            $0.top.equalTo(capstoneLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(capstoneLabel)
        }
    }
    
    // MARK: - Subscribe
    
    func nextViewController() {
        Observable.concat([
            viewModel.appear(smuLabel, duration: 1),
            viewModel.appear(capstoneLabel, duration: 1),
            viewModel.appear(teamNameLabel, duration: 1),
            gotoInfoView()
        ]).subscribe()
        .disposed(by: disposeBag)
    }
    
    func gotoInfoView() -> Observable<Void> {
        return Observable<Void>.create { [unowned self] observer in
            observer.onNext(())
            coordinator?.gotoInfoViewController()
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
