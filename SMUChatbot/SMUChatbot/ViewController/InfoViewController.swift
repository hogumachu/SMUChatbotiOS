import UIKit
import RxSwift
import RxCocoa
import SnapKit

class InfoViewController: BaseViewController {
    struct Dependency {
        let viewModel: InfoViewModel
    }
    
    // MARK: - Properties
    
    let viewModel: InfoViewModel
    lazy var collectionObservable = Observable.of(viewModel.info)
    let listCollectionView = ListCollectionView()
    
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
    }
    
    // MARK: - Configures
    
    override func configureUI() {
        listCollectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)
        view.initAutoLayout(UIViews: [listCollectionView])
        view.backgroundColor = .white
        
        listCollectionView.isPagingEnabled = false
        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalTo(view)
        }
    }
    
    // MARK: - Subscribes
    
    override func subscribe() {
        collectionObservable.bind(to: listCollectionView.rx.items(cellIdentifier: InfoCollectionViewCell.identifier, cellType: InfoCollectionViewCell.self)) { index, item, cell in
            cell.titleLabel.text = item.title
            cell.detailLabel.text = item.detailInfo
            cell.imageView.backgroundColor = item.color
            cell.imageTitleLabel.text = item.title
        }
        .disposed(by: disposeBag)

        listCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Extensions

extension InfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        flowLayout.minimumLineSpacing = 20
        collectionView.collectionViewLayout = flowLayout
        
        let width = collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * 2)
        let height = collectionView.frame.height - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * 2)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.infoDetailViewSelected(cellNumber: indexPath.row)
    }
}
