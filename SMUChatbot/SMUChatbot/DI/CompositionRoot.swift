struct AppDependency {
    let coordinator: Coordinator
}

extension AppDependency {
    static func resolve() -> AppDependency {
        let mainViewControllerFactory: (MainViewController.Dependency) -> MainViewController = { dependency in
            return .init(dependency: dependency)
        }
        
        let chatViewControllerFactory: (ChatViewController.Dependency) -> ChatViewController = { dependency in
            return .init(dependency: dependency)
        }
        
        let infoViewControllerFactory: (InfoViewController.Dependency) -> InfoViewController = { dependency in
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
        
        return .init(coordinator: .init(dependency: .init(
            mainViewControllerFactory: mainViewControllerFactory,
            chatViewControllerFactory: chatViewControllerFactory,
            infoViewControllerFactory: infoViewControllerFactory,
            infoDetailTeamViewControllerFactory: infoDetailTeamViewControllerFactory,
            infoDetailUseViewControllerFactory: infoDetailUseViewControllerFactory,
            infoPopupViewControllerFactory: infoPopupViewControllerFactory,
            webViewControllerFactory: webViewControllerFactory
        )))
    }
}
