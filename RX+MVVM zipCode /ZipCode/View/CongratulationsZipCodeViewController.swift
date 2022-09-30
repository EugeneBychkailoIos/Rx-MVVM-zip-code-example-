//  CongratulationsZipCodeViewController.swift
//
//  Created by Eugene on 04/06/2021.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CongratulationsZipCodeViewController: ViewController {
    
    // MARK: - Public
    var onEvent = Closure<OnboardingViewEvent>()
    
    // MARK: - Private properties
    private var disposeBag = DisposeBag()
    private var arrayToPresent: [CongratulationModel] = []
    private var containerView = UIView()
    private var titleLbl = UILabel()
    private var messageLbl = UILabel()
    private var image = UIImageView()
    
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - Private functions

private extension CongratulationsZipCodeViewController {
    
    private func setupViews() {
        self.view.addSubview(containerView)
        self.containerView.addSubview(titleLbl)
        self.containerView.addSubview(messageLbl)
        self.containerView.addSubview(image)
        
        self.containerView.backgroundColor = Style.Colors.defaultBackground
        
        titleLbl.attributedText = "Congratulations!".attributed
            .color(Style.Colors.white)
            .font(Style.Font.latoBold(14))
        messageLbl.attributedText = "We will notify you when Alltenna appears in your zone".attributed
            .color(Style.Colors.baseGrey)
            .font(Style.Font.blackCustom(value: 14).font)
        image.image = R.image.congratulationsNotify()
        titleLbl.textAlignment = .center
        messageLbl.textAlignment = .center
        titleLbl.numberOfLines = 0
        messageLbl.numberOfLines = 0
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
