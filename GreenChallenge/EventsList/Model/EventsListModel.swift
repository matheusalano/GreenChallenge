//
//  EventsListModel.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 09/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import Foundation

struct GCEvent: Decodable {
    let id: String
    let title: String
    let price: Double
    let latitude: Double?
    let longitude: Double?
    let image: String
    let description: String
    let date: Int
    let people: [People]
    let cupons: [Coupon]
    
    private enum CodingKeys: String, CodingKey {
        case id, title, price, latitude, longitude, image, description, date, people, cupons
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        price = try container.decode(Double.self, forKey: .price)
        image = try container.decode(String.self, forKey: .image)
        description = try container.decode(String.self, forKey: .description)
        date = try container.decode(Int.self, forKey: .date)
        people = try container.decode([People].self, forKey: .people)
        cupons = try container.decode([Coupon].self, forKey: .cupons)
        
        if let value = try? container.decode(String.self, forKey: .latitude) {
            latitude = Double(value)
        } else {
            latitude = try container.decode(Double.self, forKey: .latitude)
        }
        
        if let value = try? container.decode(String.self, forKey: .longitude) {
            longitude = Double(value)
        } else {
            longitude = try container.decode(Double.self, forKey: .longitude)
        }
    }
}

struct People: Decodable {
    let id: String
    let eventId: String
    let name: String
    let picture: String
}

struct Coupon: Decodable {
    let id: String
    let eventId: String
    let discount: Int
}
