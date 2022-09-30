//  AvailableMarketsViewController.swift
//
//  Created by Eugene on 19/08/2021.
//  Copyright (c) 2021. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources
import RxSwift

final class AvailableMarketsViewController: ViewController {
    
    private struct Constants {
        static let navBarTitle: String = "Available Markets"
        
        // TODO: - Добавить картинку, пока что строка
        static let filterButtonImage: String = "AZ"
        static let filterButtonHeight = 44
        static let filterButtonWidth = 44
        static let searchBarHeight = 44
    }
    
    // MARK: - Public
    var onEvent = Closure<NotifyViewEvent>()
    let disposeBag = DisposeBag()
    
    // MARK: - Private properties
    private let viewModel: AvailableMarketsViewModel
    private var containerView = UIView()
    private var searchBar = CustomSearchBar()
    private var filterButton = DefaultButton()
    private var tableView = UITableView()
    private var searchIcon = UIImageView()
    private var section: [AvailableMarketsSection] = []
    private let dmaService = ServiceFactory.shared.dmaService()
    
    // MARK: - Lifecycle
    init(viewModel: AvailableMarketsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: Constants.navBarTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        buttonActions()
        setupBindings()
        viewModel.onViewEvent(.viewDidLoad)
        self.hideKeyboardWhenTappedAround()
    }
}

// MARK: - Private functions
private extension AvailableMarketsViewController {
    
    private func showError(title: String, message: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        self.showAlertController(title: title, message: message, preferredStyle: .alert, actions: [okAction])
    }
    
    private func setupNavigationBar(title: String) {
        NavigationBarDecorator(self).decorate(as: .gray, with: "", animated: true, hideBackButton: false, fontSize: 20)
        self.title = title
    }
    
    private func setupView() {
        self.view.addSubview(containerView)
        containerView.addSubview(searchBar)
        containerView.addSubview(filterButton)
        containerView.addSubview(tableView)
        searchBar.addSubview(searchIcon)
        
        setupContainer()
        setupSearchSection()
        setupTableView()
        setupContainer()
        
        containerView.backgroundColor = Style.Colors.defaultBackground
    }
    
    private func setupContainer() {
        containerView.backgroundColor = Style.Colors.defaultBackground
    }
    
    private func setupSearchSection() {
        searchBar.configure()
        searchBar.layer.cornerRadius = 10.0
        searchBar.layer.masksToBounds = true
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.borderColor = Style.Colors.lowOpacityGray.cgColor
        searchIcon.image = R.image.search()
        searchIcon.contentMode = .scaleAspectFit
      
        filterButton
            .setAttributedTitle(Constants.filterButtonImage.attributed.alignment(.center).color(Style.Colors.white).font(Style.Font.latoSemiBold(14)), for: .normal)
        filterButton.gradientStyle = .empty
    }
    
    private func setupTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.backgroundColor = Style.Colors.defaultBackground
        tableView.register(MarketsTableViewCell.self)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        searchBar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(safeAreaTopInset).offset(16)
            $0.height.equalTo(Constants.searchBarHeight)
        }
        
        filterButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaTopInset).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.leading.equalTo(searchBar.snp.trailing).offset(8)
            $0.height.equalTo(Constants.filterButtonHeight)
            $0.width.equalTo(Constants.filterButtonWidth)
        }

        searchIcon.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.top).offset(14)
            $0.trailing.equalTo(searchBar.snp.trailing).offset(-18)
            $0.bottom.equalTo(searchBar.snp.bottom).offset(-14)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.leading.equalTo(containerView.snp.leading).offset(16)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-16)
            $0.bottom.equalTo(containerView.snp.bottom)
        }
    }
    
    private func setupBindings() {
        viewModel.onUpdate.delegate(to: self) { (view, update) in
            switch update {
            case .loading(let isLoading):
                if isLoading {
                    view.view.showActivityIndicator()
                } else {
                    view.view.hideActivityIndicator()
                }
            case .errorReceive:
                self.showError(title: "Oops", message: "Something went wrong, please try again later")
            }
        }
        
        self.viewModel.dataSource
            .do(onNext: { [weak self] (section) in
                self?.section = section
            })
            .drive(self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        self.tableView
            .rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        searchBar.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.rx.query)
            .disposed(by: disposeBag)
    }
    
    private func buttonActions() {
        filterButton.action = {
            self.viewModel.onViewEvent(.sortButtonAction)
        }
    }
}

extension AvailableMarketsViewController {
    
    var dataSource: RxTableViewSectionedReloadDataSource<AvailableMarketsSection> {
        let dataSource: RxTableViewSectionedReloadDataSource<AvailableMarketsSection> = .init { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MarketsTableViewCell.identifier, for: indexPath) as? MarketsTableViewCell else { return UITableViewCell()}
            cell.configure(with: item)
            return cell
        }
        return dataSource
    }
}

extension AvailableMarketsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == tableView.numberOfRows(inSection: indexPath.section) else {
            return
        }
            viewModel.loadNextPage()
    }
}

