//  MarketsTableViewCell.swift
//
//  Created by Eugene on 20/08/2021.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit

class MarketsTableViewCell: UITableViewCell, Reusable {
    
    private struct Constants {
        static let titleColor: UIColor = Style.Colors.white
        static let descriptionColor: UIColor = Style.Colors.titleCellGray
        static let viewBGColor: UIColor = Style.Colors.defaultBackground
        static let titleFont: UIFont = Style.Font.buttonFont(value: 14).font
        static let descriptionFont: UIFont = Style.Font.latoRegular(value: 12).font
    }
    
    private var containerView = UIView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
        self.selectionStyle = .default
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = Constants.viewBGColor
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = Constants.titleColor
        descriptionLabel.font = Constants.descriptionFont
        descriptionLabel.textColor = Constants.descriptionColor
    }
     
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.bottom.equalTo(-8)
        }
    }
    
    func configure(with item: DMAResponse.DmaList.DmaData) {
        self.titleLabel.text = item.city
        self.descriptionLabel.text = "DMA \(item.code.description)"
    }
}
