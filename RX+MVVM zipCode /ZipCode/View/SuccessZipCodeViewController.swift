//  SuccessZipCodeViewController.swift
//
//  Created by Eugene on 04/06/2021.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SuccessZipCodeViewController: ViewController {
    
    // MARK: - Public
    var onEvent = Closure<OnboardingViewEvent>()

    // MARK: - Private properties
    private var disposeBag = DisposeBag()
    private var arrayToPresent: [CongratulationModel] = []
    private var containerView = UIView()
    private var welcomeLbl = UILabel()
    private var welcomeMessage = UILabel()
    private var button = DefaultButton()
    private var titleLbl = UILabel()
    private var messageLbl = UILabel()
    private var image = UIImageView()
    
    private var channelOne = UIImageView()
    private var channelTwo = UIImageView()
    private var channelThree = UIImageView()
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationBarDecorator(self).decorate(as: .hidden, with: "", animated: true, hideBackButton: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        channelOne.layer.cornerRadius = 10
        channelOne.layer.masksToBounds = true
        channelTwo.layer.cornerRadius = 10
        channelTwo.layer.masksToBounds = true
        channelThree.layer.cornerRadius = 10
        channelThree.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        buttonAction()
    }
    
    private func buttonAction() {
        button.action = { [weak self] in
            Permissions.check(.location, displayMessage: true) { [weak self] success in
                self?.onEvent.call(.didTapAccess)
            }
        }
    }
}

// MARK: - Private functions

private extension SuccessZipCodeViewController {
    
    private func setupViews() {
        self.view.addSubview(containerView)
        self.containerView.addSubview(welcomeLbl)
        self.containerView.addSubview(welcomeMessage)
        self.containerView.addSubview(channelOne)
        self.containerView.addSubview(channelTwo)
        self.containerView.addSubview(channelThree)
        self.containerView.addSubview(button)
        self.containerView.addSubview(titleLbl)
        self.containerView.addSubview(messageLbl)
        self.containerView.addSubview(image)

        self.containerView.backgroundColor = Style.Colors.defaultBackground
        
        channelOne.backgroundColor = Style.Colors.imageBackground
        channelTwo.backgroundColor = Style.Colors.imageBackground
        channelThree.backgroundColor = Style.Colors.imageBackground
        
        channelOne.image = R.image.zipCode1()
        channelTwo.image = R.image.zipCode2()
        channelThree.image = R.image.zipCode3()
        
        channelOne.contentMode = .scaleAspectFit
        channelTwo.contentMode = .scaleAspectFit
        channelThree.contentMode = .scaleAspectFit
        
        welcomeLbl.attributedText = "Welcome to Alltenna".attributed
            .alignment(.center)
            .color(Style.Colors.white)
            .font(Style.Font.latoBold(18))
        welcomeMessage.attributedText = "We are glad to see you in our application".attributed
            .alignment(.center)
            .color(Style.Colors.baseGrey)
            .font(Style.Font.latoSemiBold(14))
        welcomeLbl.numberOfLines = 0
        welcomeMessage.numberOfLines = 0
        button.gradientStyle = .base
        button.titleLabel?.font = Style.Font.buttonFont(value: 14).font
        button.setTitleColor(Style.Colors.buttonTitle, for: .normal)
        button.setAttributedTitle("Get started".attributed
                                    .color(Style.Colors.white)
                                    .font(Style.Font.buttonFont(value: 14).font), for: .normal)
        titleLbl.attributedText = "Your zip code is supported".attributed
            .color(Style.Colors.white)
            .font(Style.Font.latoBold(18))
        messageLbl.attributedText = "Now you can login or register and use Alltenna".attributed
            .color(Style.Colors.baseGrey)
            .font(Style.Font.latoSemiBold(14))
        image.image = R.image.zipCodeSupported()
        titleLbl.textAlignment = .center
        messageLbl.textAlignment = .center
        titleLbl.numberOfLines = 0
        messageLbl.numberOfLines = 0
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        welcomeLbl.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.centerX.equalToSuperview()
        }
        
        welcomeMessage.snp.makeConstraints { (make) in
            make.top.equalTo(welcomeLbl.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        channelOne.snp.makeConstraints { (make) in
            make.size.equalTo(50)
            make.trailing.equalTo(channelTwo.snp.leading).offset(-8)
            make.bottom.equalTo(button.snp.top).offset(-35)
        }
        
        channelTwo.snp.makeConstraints { (make) in
            make.size.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(button.snp.top).offset(-35)
        }
        
        channelThree.snp.makeConstraints { (make) in
            make.size.equalTo(50)
            make.leading.equalTo(channelTwo.snp.trailing).offset(8)
            make.bottom.equalTo(button.snp.top).offset(-35)
        }
        
        button.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(44)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
        
        let height = ScreenSizeUtil.width() - 130
        
        image.snp.remakeConstraints { (make) -> Void in
            make.leading.equalTo(containerView.snp.leading).offset(65)
            make.trailing.equalTo(containerView.snp.trailing).offset(-65)
            make.height.width.equalTo(height)
            make.centerY.equalToSuperview().offset(-40)
        }
        
        let titleHeight = titleLbl.height(ScreenSizeUtil.width() - 32)
        
        titleLbl.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(image.snp.bottom).offset(24)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.trailing.equalTo(containerView.snp.trailing).offset(-16)
            make.height.equalTo(titleHeight)
        }
        
        let messageHeight = messageLbl.height(ScreenSizeUtil.width() - 84)
        
        messageLbl.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(titleLbl.snp.bottom).offset(8)
            make.leading.equalTo(containerView.snp.leading).offset(42)
            make.trailing.equalTo(containerView.snp.trailing).offset(-42)
            make.height.equalTo(messageHeight)
        }
    }
}

