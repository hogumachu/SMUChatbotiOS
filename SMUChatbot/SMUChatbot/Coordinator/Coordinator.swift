import UIKit

class Coordinator {
    struct Dependency {
        let mainViewControllerFactory: () -> MainViewController
        let chatViewControllerFactory: () -> ChatViewController
        let infoViewControllerFactory: () -> InfoViewController
        let infoDetailTeamViewControllerFactory: () -> InfoDetailTeamViewController
        let infoDetailUseViewControllerFactory: () -> InfoDetailUseViewController
        let infoPopupViewControllerFactory: () -> InfoPopupViewController
        let webViewControllerFactory: (_ url: String) -> WebViewController
    }
    
    var navigationController: UINavigationController?
    
    let rootViewController: MainViewController
    let chatViewControllerFactory: () -> ChatViewController
    let infoViewControllerFactory: () -> InfoViewController
    let infoDetailTeamViewControllerFactory: () -> InfoDetailTeamViewController
    let infoDetailUseViewControllerFactory: () -> InfoDetailUseViewController
    let infoPopupViewControllerFactory: () -> InfoPopupViewController
    let webViewControllerFactory: (_ url: String) -> WebViewController
    
    required init(dependency: Dependency, payload: ()) {
        rootViewController = dependency.mainViewControllerFactory()
        chatViewControllerFactory = dependency.chatViewControllerFactory
        infoViewControllerFactory = dependency.infoViewControllerFactory
        infoDetailTeamViewControllerFactory = dependency.infoDetailTeamViewControllerFactory
        infoDetailUseViewControllerFactory = dependency.infoDetailUseViewControllerFactory
        infoPopupViewControllerFactory = dependency.infoPopupViewControllerFactory
        webViewControllerFactory = dependency.webViewControllerFactory
    }
    
    func start() {
        rootViewController.coordinator = self
        navigationController?.navigationBar.isHidden = true
        navigationController?.setViewControllers([rootViewController], animated: false)
    }
    
    func gotoInfoViewController() {
        let vc = infoViewControllerFactory()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func chatViewBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func infoDetailViewSelected(cellNumber: Int) {
        switch cellNumber {
        case 0:
            let vc = infoDetailTeamViewControllerFactory()
            vc.coordinator = self
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = infoDetailUseViewControllerFactory()
            vc.coordinator = self
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = chatViewControllerFactory()
            vc.coordinator = self
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("Cell Select Error", #function)
        }
    }
    
    func infoPopup() {
        let vc = infoPopupViewControllerFactory()
        vc.coordinator = self
        vc.modalPresentationStyle = .overCurrentContext
        navigationController?.present(vc, animated: false, completion: nil)
    }
    
    func loadWebViewController(_ url: String) {
        let vc = webViewControllerFactory(url)
        vc.coordinator = self
        vc.modalPresentationStyle = .overCurrentContext
        navigationController?.present(vc, animated: true, completion: nil)
    }
}
