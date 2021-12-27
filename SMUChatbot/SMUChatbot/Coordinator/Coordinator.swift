import UIKit

class Coordinator {
    struct Dependency {
        let navigationController: UINavigationController
        let mainViewControllerFactory: (MainViewController.Dependency) -> MainViewController
        let chatViewControllerFactory: (ChatViewController.Dependency) -> ChatViewController
        let infoDetailTeamViewControllerFactory: (InfoDetailTeamViewController.Dependency) -> InfoDetailTeamViewController
        let infoDetailUseViewControllerFactory: (InfoDetailUseViewController.Dependency) -> InfoDetailUseViewController
        let infoPopupViewControllerFactory: (InfoPopupViewController.Dependency) -> InfoPopupViewController
        let webViewControllerFactory: (WebViewController.Dependency) -> WebViewController
    }
    
    let navigationController: UINavigationController
    private let mainViewControllerFactory: (MainViewController.Dependency) -> MainViewController
    private let chatViewControllerFactory: (ChatViewController.Dependency) -> ChatViewController
    private let infoDetailTeamViewControllerFactory: (InfoDetailTeamViewController.Dependency) -> InfoDetailTeamViewController
    private let infoDetailUseViewControllerFactory: (InfoDetailUseViewController.Dependency) -> InfoDetailUseViewController
    private let infoPopupViewControllerFactory: (InfoPopupViewController.Dependency) -> InfoPopupViewController
    private let webViewControllerFactory: (WebViewController.Dependency) -> WebViewController
    
    required init(dependency: Dependency) {
        navigationController = dependency.navigationController
        mainViewControllerFactory = dependency.mainViewControllerFactory
        chatViewControllerFactory = dependency.chatViewControllerFactory
        infoDetailTeamViewControllerFactory = dependency.infoDetailTeamViewControllerFactory
        infoDetailUseViewControllerFactory = dependency.infoDetailUseViewControllerFactory
        infoPopupViewControllerFactory = dependency.infoPopupViewControllerFactory
        webViewControllerFactory = dependency.webViewControllerFactory
    }
    
    func start() {
        let vc = mainViewControllerFactory(.init(coordinator: self))
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func chatViewBackButtonTapped() {
        navigationController.popViewController(animated: true)
    }
    
    func pushDetailTeamViewController() {
        let vc = infoDetailTeamViewControllerFactory(.init(viewModel: .init(), coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushDetailUseViewController() {
        let vc = infoDetailUseViewControllerFactory(.init(viewModel: .init(), coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushChatViewController() {
        let vc = chatViewControllerFactory(.init(viewModel: .init(), coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func infoPopup() {
        let vc = infoPopupViewControllerFactory(.init(coordinator: self))
        vc.modalPresentationStyle = .overCurrentContext
        navigationController.present(vc, animated: false, completion: nil)
    }
    
    func loadWebViewController(_ viewController: UIViewController? = nil, type: WebViewURLType) {
        viewController?.dismiss(animated: false, completion: nil)
        let vc = webViewControllerFactory(.init(url: type.rawValue, coordiantor: self))
        vc.modalPresentationStyle = .overCurrentContext
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    enum WebViewURLType: String {
        case iOS = "https://github.com/hogumachu/SMUChatbotiOS"
        case django = "https://github.com/hogumachu/SMUChatbot"
    }
}
