//  NotifyViewModel.swift
//
//  Created by Eugene on 6/3/21.
//  Copyright (c) 2021. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NotifyViewModel: NotifyModule {

    // MARK: - Public
    let dmaService = ServiceFactory.shared.dmaService()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private var inputEmail = ""
    private var inputZipCode = ""
    
    // MARK: NotifyeModule
    let onEvent = Closure<NotifyModuleEvent>()

    // MARK: View bindings
    let isLoading = Closure<Bool>()
    let onError = Closure<Error>()
    let onUpdate = Closure<Update>()

    // MARK: View output
    var isValidEmail: Bool {
        return inputEmail.isValidEmail
    }
    
    func onViewEvent(_ event: NotifyViewEvent) {
        switch event {
        case .sendNotify:
            debugPrint("Send did pressed")
            sendRequest()
        case .faq:
            debugPrint("Faq did pressed")
            onEvent.call(.faq)
        }
    }
    
    func inputEmail(_ email: String) {
        self.inputEmail = email
    }
    
    func inputZipCode(_ zipCode: String) {
        self.inputZipCode = zipCode
    }
}

// MARK: - Private extensions
private extension NotifyViewModel {
    
    func sendRequest() {
        onUpdate.call(.loading(true))
        dmaService.postDmaNotify(email: self.inputEmail, zipCode: self.inputZipCode)
            .subscribe { [weak self] response in
                self?.onUpdate.call(.loading(false))
                self?.onEvent.call(.sendNotify)
            } onError: { [weak self] error in
                self?.onEvent.call(.sendNotify)
            }
            .disposed(by: disposeBag)
    }
}
