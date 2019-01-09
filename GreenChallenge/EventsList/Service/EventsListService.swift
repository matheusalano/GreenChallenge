//
//  EventsListService.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 09/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import Foundation
import RxSwift

protocol EventsListServiceProtocol {
    func getEvents() -> Observable<[Event]>
}

class EventsListService: EventsListServiceProtocol {
    
    private let appService = AppService()
    
    func getEvents() -> Observable<[Event]> {
        return appService.request(path: "events/", method: .GET)
    }
}
