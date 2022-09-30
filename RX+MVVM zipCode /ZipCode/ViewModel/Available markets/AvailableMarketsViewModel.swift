//  AvailableMarketsViewModel.swift
//
//  Created by Eugene on 19/08/2021.
//  Copyright (c) 2021. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct AvailableMarketsSection: SectionModelType {
    typealias Item = DMAResponse.DmaList.DmaData
    var items: [Item]

    init(original: AvailableMarketsSection, items: [Item]) {
        self = original
        self.items = items
    }

    init(items: [Item]) {
        self.items = items
    }
}

class AvailableMarketsViewModel: AvailableMarketsModule {
    
    // MARK: - Public properties
    var itemsCount = 0
    let onEvent = Closure<AvailableMarketsModuleEvent>()

    // MARK: - Private properties
    fileprivate var searchQuery: String?
    fileprivate var currentPage: Int = 0
    private var isSorted: Bool = false
    private let disposeBag = DisposeBag()
    private let dmaService = ServiceFactory.shared.dmaService()
    private var isLoadingQuery = false
    private var requestDisposable: Disposable?
    private var itemsSubject = BehaviorRelay<[DMAResponse.DmaList.DmaData]>(value: [])
    private var hasNextPage = true

    // MARK: View bindings
    let isLoading = Closure<Bool>()
    let onError = Closure<Error>()
    let onUpdate = Closure<Update>()

    // MARK: View output

    var dataSource: Driver<[AvailableMarketsSection]> {
        return itemsSubject
            .map({
                    AvailableMarketsSection(items: $0)
            })
            .map({ [ $0 ]})
            .asDriver(onErrorJustReturn: [])
    }

    func loadNextPage(force: Bool = false) {
        if force {
            currentPage = 0
            hasNextPage = true
            itemsSubject.accept([])
            isLoadingQuery = false
        }
        
        guard hasNextPage else {
            return
        }
        guard !isLoadingQuery else {
            return
        }
                
        isLoadingQuery = true
        onUpdate.call(.loading(isLoadingQuery))
    
        currentPage += 1
    
        requestDisposable?.dispose()
        requestDisposable = nil
        requestDisposable = self.dmaService.getDmaList(page: currentPage, limit: 100, q: searchQuery, codes: [])
            .do(onError: { [unowned self] error in
                requestDisposable?.dispose()
                isLoadingQuery = false
                onUpdate.call(.loading(isLoadingQuery))
            })
            .do(onNext: { [unowned self] response in
                let items = response.data?.data ?? []
                hasNextPage = response.data?.hasNextPage ?? false
                var result = itemsSubject.value + items
                if isSorted {
                    hasNextPage = false
                    result.sort(by: { $0.city > $1.city })
                }
                itemsSubject.accept(result)
                requestDisposable?.dispose()
                isLoadingQuery = false
                onUpdate.call(.loading(isLoadingQuery))
            })
            .subscribe()
    }

    func onViewEvent(_ event: AvailableMarketsViewEvent) {
        switch event {
        case .viewDidLoad:
            break
        case .sortButtonAction:
            self.isSorted.toggle()
            loadNextPage(force: true)
        }
    }
}

// MARK: - Private extensions
private extension AvailableMarketsViewModel {}

extension AvailableMarketsViewModel: ReactiveCompatible {}

extension Reactive where Base: AvailableMarketsViewModel {
    var query: Binder<String?> {
        return Binder<String?>(self.base) { base, value in
            base.searchQuery = value
            base.loadNextPage(force: true)
        }
    }
}
