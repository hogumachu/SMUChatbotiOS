import UIKit

struct AppDependency {
    let window: UIWindow
    let coordinator: Coordinator
}

extension AppDependency {
    static func resolve(window: UIWindow) -> AppDependency {
        let navigationController: UINavigationController = {
            return .init(nibName: nil, bundle: nil)
        }()
        
        let mainViewControllerFactory: (MainViewController.Dependency) -> MainViewController = { dependency in
            return .init(dependency: dependency)
        }
        
        let chatViewControllerFactory: (ChatViewController.Dependency) -> ChatViewController = { dependency in
            return .init(dependency: dependency)
        }
        
        
        let infoDetailTeamViewControllerFactory: (InfoDetailTeamViewController.Dependency) -> InfoDetailTeamViewController = { dependency in
            return .init(dependency: dependency)
        }
        
        let infoDetailUseViewControllerFactory: (InfoDetailUseViewController.Dependency) -> InfoDetailUseViewController = { dependency in
            return .init(dependency: dependency)
        }
        
        let infoPopupViewControllerFactory: (InfoPopupViewController.Dependency) -> InfoPopupViewController = { dependency in
            return .init(dependency: dependency)
        }
        
        let webViewControllerFactory: (WebViewController.Dependency) -> WebViewController = { dependency in
            return .init(dependency: dependency)
        }
        
        return .init(
            window: window,
            coordinator: .init(
                dependency: .init(
                    navigationController: navigationController,
                    mainViewControllerFactory: mainViewControllerFactory,
                    chatViewControllerFactory: chatViewControllerFactory,
                    infoDetailTeamViewControllerFactory: infoDetailTeamViewControllerFactory,
                    infoDetailUseViewControllerFactory: infoDetailUseViewControllerFactory,
                    infoPopupViewControllerFactory: infoPopupViewControllerFactory,
                    webViewControllerFactory: webViewControllerFactory
                )
            )
        )
    }
    
    func start() {
        coordinator.start()
        window.rootViewController = coordinator.navigationController
        window.makeKeyAndVisible()
    }
}
