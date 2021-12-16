import UIKit

class Coordinator {
    struct Dependency {
        let mainViewControllerFactory: (MainViewController.Dependency) -> MainViewController
        let chatViewControllerFactory: (ChatViewController.Dependency) -> ChatViewController
        let infoViewControllerFactory: (InfoViewController.Dependency) -> InfoViewController
        let infoDetailTeamViewControllerFactory: (InfoDetailTeamViewController.Dependency) -> InfoDetailTeamViewController
        let infoDetailUseViewControllerFactory: (InfoDetailUseViewController.Dependency) -> InfoDetailUseViewController
        let infoPopupViewControllerFactory: (InfoPopupViewController.Dependency) -> InfoPopupViewController
        let webViewControllerFactory: (WebViewController.Dependency) -> WebViewController
    }
    
    var navigationController: UINavigationController?
    
    let mainViewControllerFactory: (MainViewController.Dependency) -> MainViewController
    let chatViewControllerFactory: (ChatViewController.Dependency) -> ChatViewController
    let infoViewControllerFactory: (InfoViewController.Dependency) -> InfoViewController
    let infoDetailTeamViewControllerFactory: (InfoDetailTeamViewController.Dependency) -> InfoDetailTeamViewController
    let infoDetailUseViewControllerFactory: (InfoDetailUseViewController.Dependency) -> InfoDetailUseViewController
    let infoPopupViewControllerFactory: (InfoPopupViewController.Dependency) -> InfoPopupViewController
    let webViewControllerFactory: (WebViewController.Dependency) -> WebViewController
    
    required init(dependency: Dependency) {
        mainViewControllerFactory = dependency.mainViewControllerFactory
        chatViewControllerFactory = dependency.chatViewControllerFactory
        infoViewControllerFactory = dependency.infoViewControllerFactory
        infoDetailTeamViewControllerFactory = dependency.infoDetailTeamViewControllerFactory
        infoDetailUseViewControllerFactory = dependency.infoDetailUseViewControllerFactory
        infoPopupViewControllerFactory = dependency.infoPopupViewControllerFactory
        webViewControllerFactory = dependency.webViewControllerFactory
    }
    
    func start() {
        let vc = mainViewControllerFactory(.init(viewModel: .init(), coordinator: self))
        navigationController?.navigationBar.isHidden = true
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    func gotoInfoViewController() {
        let vc = infoViewControllerFactory(.init(viewModel: .init(), coordinator: self))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func chatViewBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func pushDetailTeamViewController() {
        let vc = infoDetailTeamViewControllerFactory(.init(viewModel: .init(), coordinator: self))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushDetailUseViewController() {
        let vc = infoDetailUseViewControllerFactory(.init(viewModel: .init(), coordinator: self))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushChatViewController() {
        let vc = chatViewControllerFactory(.init(viewModel: .init(), coordinator: self))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func infoPopup() {
        let vc = infoPopupViewControllerFactory(.init(coordinator: self))
        vc.modalPresentationStyle = .overCurrentContext
        navigationController?.present(vc, animated: false, completion: nil)
    }
    
    func loadWebViewController(_ url: String) {
        let vc = webViewControllerFactory(.init(url: url, coordiantor: self))
        vc.modalPresentationStyle = .overCurrentContext
        navigationController?.present(vc, animated: true, completion: nil)
    }
}
