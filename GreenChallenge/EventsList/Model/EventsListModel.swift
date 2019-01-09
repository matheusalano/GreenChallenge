//
//  EventsListModel.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 09/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import Foundation

struct Event: Decodable {
    let id: String
    let title: String
    let price: Double
    let latitude: Double
    let longitude: Double
    let image: String
    let description: String
    let date: Int
    let people: [People]
    let cupons: [Coupon]
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
