//
//  EventDetailModel.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 10/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import Foundation
import RxDataSources

struct User {
    let name: String
    let email: String
}

enum SectionItem {
    case generalInfo(event: GCEvent)
    case people(people: People)
    case coupons(coupons: Coupon)
}

enum EventDetailSectionModel: SectionModelType {
    case generalInfoSection(items: [SectionItem])
    case peopleSection(items: [SectionItem])
    case couponsSection(items: [SectionItem])
    
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .generalInfoSection(let items):
            return items.map {$0}
        case .peopleSection(let items):
            return items.map {$0}
        case .couponsSection(let items):
            return items.map {$0}
        }
    }
    
    init(original: EventDetailSectionModel, items: [Item]) {
        switch original {
        case .generalInfoSection(let items):
            self = .generalInfoSection(items: items)
        case .peopleSection(let items):
            self = .peopleSection(items: items)
        case .couponsSection(let items):
            self = .couponsSection(items: items)
        }
    }
    
}
