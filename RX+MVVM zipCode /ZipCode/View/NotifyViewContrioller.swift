//  NotifyViewContrioller.swift
//
//  Created by Eugene on 04/06/2021.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit

final class NotifyViewController: ViewController {
    
    // MARK: - Public
    var onEvent = Closure<NotifyViewEvent>()
    
    // MARK: - Private properties
    private let viewModel: NotifyViewModel
    private let containerView = UIView()
    private let titlelBL = UILabel()
    private let messageLbl = UILabel()
    private let zipCodeTextFieldContainer = UIView()
    private let zipCodeTextFieldTitle = UILabel()
    private let zipCodeTextField = UICustomTextInput()
    
    private let emailTextFieldContainer = UIView()
    private let emailTextFieldTitle = UILabel()
    private let emailTextField = UICustomTextInput()
    
    private let button = DefaultButton()
    private let availableButton = DefaultButton()
    private var textView = TextView()
    private let zipCodeMaxCount = 5
    
    // MARK: - Lifecycle
    init(viewModel: NotifyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationBarDecorator(self).decorate(as: .gray, with: "", animated: true, hideBackButton: false, fontSize: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupBindings()
        buttonActions()
    }
    
    func openConfirmationAlertController(title: String?, message: String?, handler: @escaping () -> Void) {
        presentAlertController(with: "", message: "", anotherMessage: "") {
            
        }
    }
    
    private func buttonActions() {
        button.action = {
            self.viewModel.isValidEmail == true ? self.viewModel.onViewEvent(.sendNotify) : self.showError(title: "Oops", message: "Invalid email")
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

private extension NotifyViewController {
    
    private func setupViews() {
        self.view.addSubview(containerView)
        containerView.backgroundColor = Style.Colors.defaultBackground
        
        containerView.addSubview(emailTextFieldContainer)
        containerView.addSubview(zipCodeTextFieldContainer)
        
        zipCodeTextFieldContainer.addSubview(zipCodeTextFieldTitle)
        zipCodeTextFieldContainer.addSubview(zipCodeTextField)
        
        emailTextFieldContainer.addSubview(emailTextFieldTitle)
        emailTextFieldContainer.addSubview(emailTextField)
        
        containerView.addSubview(messageLbl)
        containerView.addSubview(titlelBL)
        containerView.addSubview(button)
        containerView.addSubview(availableButton)
        
        zipCodeTextFieldContainer.backgroundColor = Style.Colors.cellBackground
        zipCodeTextFieldContainer.layer.cornerRadius = 10
        
        zipCodeTextFieldTitle.attributedText = "Enter zip code".attributed
            .alignment(.left)
            .color(Style.Colors.white)
            .font(Style.Font.latoMedium(10)
            )
        
        let textFieldMask = "[\(String(repeating: "0", count: zipCodeMaxCount))]"
        
        zipCodeTextField
            .setData(
                text: "".attributed,
                placeholder: "Zip Code USA",
                isSecureTextEntry: false,
                mask: textFieldMask,
                primaryFormat: textFieldMask,
                onMaskedTextChangedCallback: { [weak self] textField, value, complete in
                    self?.viewModel.inputZipCode(value)
                },
                textFieldDisabled: false,
                isBlackout: false,
                textDidChange: nil
            )
        
        zipCodeTextField.sampleTextField?.keyboardType = .numberPad
        
        emailTextFieldContainer.backgroundColor = Style.Colors.cellBackground
        emailTextFieldContainer.layer.cornerRadius = 10
        
        emailTextFieldTitle.attributedText = "Email address".attributed
            .alignment(.left)
            .color(Style.Colors.white)
            .font(Style.Font.latoMedium(10))
        
        emailTextField
            .setData(
                text: "".attributed,
                placeholder: "Enter your email",
                isSecureTextEntry: false,
                mask: nil,
                primaryFormat: nil,
                onMaskedTextChangedCallback: nil,
                textFieldDisabled: false,
                isBlackout: false,
                textDidChange: ({ [weak self] text in
                    self?.viewModel.inputEmail(text)
                })
            )
        
        emailTextField.sampleTextField?.keyboardType = .default
        
        messageLbl.numberOfLines = 0
        messageLbl.attributedText = "Sorry, we're not in your area right now but we're expanding to new areas all the time. Let us know where you are to get notified!".attributed
            .alignment(.center)
            .color(Style.Colors.titleCellGray)
            .font(Style.Font.latoSemiBold(14))
        titlelBL.attributedText = "Notify Me".attributed
            .alignment(.center)
            .color(Style.Colors.white)
            .font(Style.Font.latoBold(18))
        
        button.gradientStyle = .base
        button.setAttributedTitle("Send".attributed
                                    .alignment(.center)
                                    .color(Style.Colors.white)
                                    .font(Style.Font.latoSemiBold(14)), for: .normal)
        availableButton.gradientStyle = .empty
        availableButton.setAttributedTitle("What markets available?".attributed
                                            .alignment(.center)
                                            .color(Style.Colors.white)
                                            .font(Style.Font.latoMedium(14)), for: .normal)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emailTextFieldContainer.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(44)
            make.centerX.equalTo(containerView)
            make.centerY.equalTo(containerView)
        }
        
        emailTextFieldTitle.snp.makeConstraints { (make) in
            make.left.equalTo(emailTextFieldContainer.snp.left).offset(8)
            make.top.equalTo(emailTextFieldContainer.snp.top).offset(6)
        }
        
        emailTextField.snp.makeConstraints { (make) in
            make.left.equalTo(emailTextFieldContainer.snp.left).offset(8)
            make.bottom.equalTo(emailTextFieldContainer.snp.bottom).offset(-6)
            make.top.equalTo(emailTextFieldTitle.snp.bottom).offset(5)
            make.right.equalTo(emailTextFieldContainer.snp.right).offset(-8)
        }
        
        zipCodeTextFieldContainer.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(44)
            make.centerX.equalTo(containerView)
            make.top.equalTo(emailTextFieldContainer.snp.bottom).offset(8)
        }
        
        zipCodeTextFieldTitle.snp.makeConstraints { (make) in
            make.left.equalTo(zipCodeTextFieldContainer.snp.left).offset(8)
            make.top.equalTo(zipCodeTextFieldContainer.snp.top).offset(6)
        }
        
        zipCodeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(zipCodeTextFieldContainer.snp.left).offset(8)
            make.bottom.equalTo(zipCodeTextFieldContainer.snp.bottom).offset(-6)
            make.top.equalTo(zipCodeTextFieldTitle.snp.bottom).offset(5)
            make.right.equalTo(zipCodeTextFieldContainer.snp.right).offset(-8)
        }
        
        messageLbl.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.bottom.equalTo(emailTextFieldContainer.snp.top).offset(-16)
        }
        
        titlelBL.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make .bottom.equalTo(messageLbl.snp.top).offset(-8)
        }
        
        button.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(zipCodeTextFieldContainer.snp.bottom).offset(11)
        }
        
        availableButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(button.snp.bottom).offset(8)
        }
    }
    
    private func setupBindings() {
        viewModel.onUpdate.delegate(to: self) { (view, update) in
            switch update {
            case .errorReceive:
                self.showError(title: "Oops", message: "Something went wrong, please try again later")
            case .loading(let isLoading):
                if isLoading {
                    view.view.showActivityIndicator()
                } else {
                    view.view.hideActivityIndicator()
                }
            }
        }
    }
}
