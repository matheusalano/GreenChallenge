//
//  EventGeneralInfoTableViewCell.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 10/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import UIKit
import MapKit
import Nuke

class EventGeneralInfoTableViewCell: UITableViewCell {

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().inset(15)
            $0.height.equalTo(130)
            $0.width.equalTo(130)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.bottom.equalTo(logoImageView)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalTo(dateLabel.snp.top).offset(-5)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView)
            $0.trailing.equalTo((titleLabel))
            $0.top.equalTo(logoImageView.snp.bottom).offset(15)
        }
        
        contentView.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            $0.height.equalTo(150)
        }
    }
    
    func configure(with event: GCEvent) {
        if let url = URL(string: event.image) {
            Nuke.loadImage(with: url, into: logoImageView)
        }
        titleLabel.text = event.title
        priceLabel.text = event.price.toCurrency()
        dateLabel.text = Date(timeIntervalSince1970: TimeInterval(event.date / 1000)).toString(withStyle: .long)
        descriptionLabel.text = event.description
        
        if let lat = event.latitude, let long = event.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: false)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }
}
