struct AppDependency {
    let coordinator: Coordinator
}

extension AppDependency {
    static func resolve() -> AppDependency {
        let mainViewControllerFactory: () -> MainViewController = {
            return .init(dependency: .init(viewModel: .init()), payload: ())
        }
        
        let chatViewControllerFactory: () -> ChatViewController = {
            return .init(dependency: .init(viewModel: .init()), payload: ())
        }
        
        let infoViewControllerFactory: () -> InfoViewController = {
            return .init(dependency: .init(viewModel: .init()), payload: ())
        }
        
        let infoDetailTeamViewControllerFactory: () -> InfoDetailTeamViewController = {
            return .init(dependency: .init(viewModel: .init()), payload: ())
        }
        
        let infoDetailUseViewControllerFactory: () -> InfoDetailUseViewController = {
            return .init(dependency: .init(viewModel: .init()), payload: ())
        }
        
        let infoPopupViewControllerFactory: () -> InfoPopupViewController = {
            return .init(nibName: nil, bundle: nil)
        }
        
        let webViewControllerFactory: (_ url: String) -> WebViewController = {url in
            return .init(dependency: .init(url: url), payload: ())
        }
        
        let coordinator = Coordinator.init(dependency:
                                            .init(mainViewControllerFactory: mainViewControllerFactory,
                                                  chatViewControllerFactory: chatViewControllerFactory,
                                                  infoViewControllerFactory: infoViewControllerFactory,
                                                  infoDetailTeamViewControllerFactory : infoDetailTeamViewControllerFactory,
                                                  infoDetailUseViewControllerFactory: infoDetailUseViewControllerFactory,
                                                  infoPopupViewControllerFactory: infoPopupViewControllerFactory,
                                                  webViewControllerFactory: webViewControllerFactory
                                            ),
                                           payload: ())
        
        return .init(coordinator: coordinator)
    }
}
