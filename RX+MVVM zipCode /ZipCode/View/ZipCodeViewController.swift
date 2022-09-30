//  ZipCodeViewController.swift
//
//  Created by Eugene on 6/3/21.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit

final class ZipCodeViewController: ViewController {
    
    // MARK: - Public
    
    // ZipCodeViewProtocol
    var onEvent = Closure<ZipCodeViewEvent>()
    
    // MARK: - Private properties
    private let viewModel: ZipCodeViewModel
    private let containerView = UIView()
    private let titlelBL = UILabel()
    private let messageLbl = UILabel()
    private let textFieldContainer = UIView()
    private let textFieldTitle = UILabel()
    private let textField = UICustomTextInput()
    private let checkButton = DefaultButton()
    private let questionButton = DefaultButton()
    private let availableButton = DefaultButton()
    private var textView = TextView()
    private let zipCodeMaxCount = 5
    
    // MARK: - Lifecycle
    init(viewModel: ZipCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationBarDecorator(self).decorate(as: .gray, with: nil, animated: false, hideBackButton: true, fontSize: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupBindings()
        viewModel.onViewEvent(.viewDidLoad)
        buttonActions()
        self.hideKeyboardWhenTappedAround()
    }
    
    func openConfirmationAlertController(title: String?, message: String?, handler: @escaping () -> Void) {
        presentAlertController(with: "", message: "", anotherMessage: "") {

        }
    }
    
    private func buttonActions() {
        questionButton.action = {
            debugPrint("questionButton")
        }
        checkButton.action = {
            
            self.viewModel.isValidZipCode == true ? self.viewModel.onViewEvent(.sendCheck) : self.showError(title: "Oops", message: "Invalid Zip Code")

        }
        availableButton.action = {
            self.viewModel.onViewEvent(.faq)
        }
        
        
    }
    private func showError(title: String, message: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        self.showAlertController(title: title, message: message, preferredStyle: .alert, actions: [okAction])
    }
}

// MARK: - Private functions

private extension ZipCodeViewController {
    
    private func setupViews() {
        self.view.addSubview(containerView)
        containerView.backgroundColor = Style.Colors.defaultBackground
        containerView.addSubview(textFieldContainer)
        textFieldContainer.addSubview(textFieldTitle)
        textFieldContainer.addSubview(textField)
        containerView.addSubview(messageLbl)
        containerView.addSubview(titlelBL)
        containerView.addSubview(checkButton)
        containerView.addSubview(questionButton)
        containerView.addSubview(availableButton)
        containerView.addSubview(textView)
        
        textFieldContainer.backgroundColor = Style.Colors.cellBackground
        textFieldContainer.layer.cornerRadius = 10
        
        textFieldTitle.attributedText = "Enter zip code".attributed.alignment(.left).color(Style.Colors.white).font(Style.Font.latoMedium(10))
        
        let textFieldMask = "[\(String(repeating: "0", count: zipCodeMaxCount))]"
        
        textField.setData(text: "".attributed,
                          placeholder: "Zip Code USA",
                          isSecureTextEntry: false,
                          mask: textFieldMask,
                          primaryFormat: textFieldMask,
                          onMaskedTextChangedCallback: { [weak self] textField, value, complete in
                            self?.viewModel.inputZipCode(value)
                        },
                          textFieldDisabled: false,
                          isBlackout: false,
                          textDidChange: nil)
        textField.sampleTextField?.keyboardType = .numberPad
        
        messageLbl.numberOfLines = 0
        messageLbl.attributedText = "Enter zip code to makes sure that Alltenna is available given market".attributed.alignment(.center).color(Style.Colors.titleCellGray).font(Style.Font.latoSemiBold(14))
        titlelBL.attributedText = "Enter your zip code".attributed.alignment(.center).color(Style.Colors.white).font(Style.Font.latoBold(18))
        
        checkButton.gradientStyle = .base
        checkButton.setAttributedTitle("Check Availability".attributed.alignment(.center).color(Style.Colors.white).font(Style.Font.latoSemiBold(14)), for: .normal)
        
        questionButton.gradientStyle = .none
        questionButton.setAttributedTitle("Why we Need your Location?".attributed.alignment(.center).color(Style.Colors.titleCellGray).font(Style.Font.latoMedium(14)), for: .normal)
        
        availableButton.gradientStyle = .empty
        availableButton.setAttributedTitle("What markets available?".attributed.alignment(.center).color(Style.Colors.white).font(Style.Font.latoMedium(14)), for: .normal)
        
        
        let height = NSMutableParagraphStyle()
        height.lineHeightMultiple = 1.25
        
        let attrs1 = [NSAttributedString.Key.font : Style.Font.latoMedium(12), NSAttributedString.Key.foregroundColor : Style.Colors.baseGrey, NSAttributedString.Key.paragraphStyle : height]
        let attrs2 = [NSAttributedString.Key.font : Style.Font.latoMedium(12), NSAttributedString.Key.foregroundColor : Style.Colors.white, NSAttributedString.Key.paragraphStyle : height]
        
        let attributedString1 = NSMutableAttributedString(string:"Use of this site constitutes acceptance of our ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"Terms and Conditions", attributes:attrs2)
        let attributedString3 = NSMutableAttributedString(string:" and ", attributes:attrs1)
        let attributedString4 = NSMutableAttributedString(string:"Privacy Policy", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        attributedString1.append(attributedString4)
        
        textView.setData(text: attributedString1)
        textView.resize(textView: self.textView)
        
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textFieldContainer.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(44)
            make.centerX.equalTo(containerView)

        }
        
        textFieldTitle.snp.makeConstraints { (make) in
            make.left.equalTo(textFieldContainer.snp.left).offset(8)
            make.top.equalTo(textFieldContainer.snp.top).offset(6)
        }
        
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(textFieldContainer.snp.left).offset(8)
            make.bottom.equalTo(textFieldContainer.snp.bottom).offset(-6)
            make.top.equalTo(textFieldTitle.snp.bottom).offset(5)
            make.right.equalTo(textFieldContainer.snp.right).offset(-8)
        }
        
        messageLbl.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.bottom.equalTo(textFieldContainer.snp.top).offset(-16)
        }
        
        titlelBL.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make .bottom.equalTo(messageLbl.snp.top).offset(-8)
        }
        
        checkButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.height.equalTo(44)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(textFieldContainer.snp.bottom).offset(11)
        }
        
        questionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(containerView)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(checkButton.snp.bottom).offset(8)
            make.height.equalTo(44)
        }
        
        availableButton.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(questionButton.snp.bottom).offset(8)
            make.height.equalTo(44)
        }
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-8)
            make.height.equalTo(55)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            
        }
    }
    
    private func setupBindings() {
        viewModel.onUpdate.delegate(to: self) { (view, update) in
            switch update {
            case let .initialSetup(title):
                view.navigationItem.title = title
            case .loading(let isLoading):
             if isLoading {
                 view.view.showActivityIndicator()
             } else {
                 view.view.hideActivityIndicator()
             }
            case .errorReceive:
                self.showError(
                    title: "Oops",
                    message: "Something went wrong, please try again later"
                )
            }
        }
    }
}

