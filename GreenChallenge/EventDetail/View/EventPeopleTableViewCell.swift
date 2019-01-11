//
//  EventPeopleTableViewCell.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 10/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import UIKit
import Nuke

class EventPeopleTableViewCell: UITableViewCell {

    private lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.numberOfLines = 2
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
        contentView.addSubview(pictureImageView)
        pictureImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
            $0.width.equalTo(50)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(pictureImageView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with people: People) {
        if let url = URL(string: people.picture) {
            Nuke.loadImage(with: url, into: pictureImageView)
        }
        nameLabel.text = people.name
    }
}
