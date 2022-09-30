//  ZipCodeViewModel.swift
//
//  Created by Eugene on 6/3/21.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ZipCodeViewModel: ZipCodeModule {

    // MARK: - Public
    let onEvent = Closure<ZipCodeModuleEvent>()
    let dmaService = ServiceFactory.shared.dmaService()

    // MARK: - Private properties
    private let disposeBag = DisposeBag()
   
    // MARK: View bindings
    let isLoading = Closure<Bool>()
    let onError = Closure<Error>()
    let onUpdate = Closure<Update>()
    
    private var inputZipCode = ""

    // MARK: View output
    func onViewEvent(_ event: ZipCodeViewEvent) {
        switch event {
        case .viewDidLoad:
            onUpdate.call(.initialSetup(title: ""))
        case .didTapCheckAvaliability:
            onEvent.call(.didTapCheckAvaliability)
        case .sendCheck:
            sendRequest()
        case .faq:
            onEvent.call(.faqButton)
        }
    }
    
    var isValidZipCode: Bool {
        return inputZipCode.isValidZipCode
    }
    
    func inputZipCode(_ zipCode: String) {
        self.inputZipCode = zipCode
    }
}

// MARK: - Private extensions
private extension ZipCodeViewModel {
    
    func sendRequest() {
        onUpdate.call(.loading(true))
        dmaService.checkDma(zipCode: self.inputZipCode)
            .subscribe { [weak self] response in
                self?.onUpdate.call(.loading(false))
                self?.onEvent.call(.sendCheck)
            } onError: { [weak self] error in
                self?.onUpdate.call(.loading(false))
                let error = error as NSError
                if error.code == 404 {
                    self?.onEvent.call(.codeNotFounded)
                }
                self?.onEvent.call(.codeNotFounded)
            }
            .disposed(by: disposeBag)
    }
    
}
