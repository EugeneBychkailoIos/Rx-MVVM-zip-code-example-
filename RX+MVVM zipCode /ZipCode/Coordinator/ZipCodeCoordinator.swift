//  ZipCodeCoordinator.swift
//
//  Created by Eugene on 6/3/21.
//  Copyright (c) 2021. All rights reserved.
//


import Foundation

final class ZipCodeCoordinator: BaseCoordinator, ZipCodeCoordinatorOutput {

    // MARK: - ZipCodeCoordinatorOutput
    var finishFlow: (() -> Void)?

    // MARK: - Private properties
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    override func start() {
        showController()
    }
}

// MARK: - Private functions

private extension ZipCodeCoordinator {
    func showController() {
        let viewModel = ZipCodeViewModel()

        viewModel.onEvent.delegate(to: self) {
            (coordonator, event) in
            switch event {
            case .didTapCheckAvaliability:
            debugPrint("zip codes available")
            case .sendCheck:
                coordonator.showNext()
            case .codeNotFounded:
                coordonator.notifyScreenActions()
            case .faqButton:
                coordonator.showFaqScreen()
            }
        }
        
        let controller = ZipCodeViewController(viewModel: viewModel)
        router.push(controller)
    }
    
    func showNext() {
        let controller = SuccessZipCodeViewController()
        
        controller.onEvent.delegate(to: self) { (coordinator, event) in
            switch event {
            case .didTapAccess:
                if let token = ServiceFactory.shared.authStorage().authToken.value, !token.isEmpty {
                    coordinator.finishFlow?()
                    return
                }
                coordinator.showAuthFlow()
            default: break
            }
        }

        debugPrint("success")
        router.setRootModule(controller.toPresent())
    }
    
    func notifyScreenActions() {
        let viewModel = NotifyViewModel()
        
        viewModel.onEvent.delegate(to: self) { (coordinator, event) in
            switch event {
            case .sendNotify:
                coordinator.showFinishView()
            case .faq:
                coordinator.showFaqScreen()
            }
        }
        
        let controller = NotifyViewController(viewModel: viewModel)
        router.push(controller)
    }
    
    func showFinishView() {
        let controller = CongratulationsZipCodeViewController()
        router.setRootModule(controller.toPresent())
    }
    
    func showFaqScreen() {
        let viewModel = AvailableMarketsViewModel()
        let controller = AvailableMarketsViewController(viewModel: viewModel)
        router.push(controller)
    }
    
    func showAuthFlow() {
        let coordinator = AuthorizationCoordinator(router: router)
        addDependency(coordinator)
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.removeDependency(coordinator)
            self?.finishFlow?()
        }
        coordinator.start()
    }
}

