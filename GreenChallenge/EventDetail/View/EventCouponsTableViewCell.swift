//
//  EventCouponsTableViewCell.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 10/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import UIKit

class EventCouponsTableViewCell: UITableViewCell {

    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(discountLabel)
        discountLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(with coupon: Coupon) {
        discountLabel.text = String.localized(by: "discountOf") + (Double(exactly: coupon.discount)?.toCurrency() ?? "")
    }
}
