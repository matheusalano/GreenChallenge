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
    func getEvents() -> Observable<[GCEvent]>
}

class EventsListService: EventsListServiceProtocol {
    
    private let appService = AppService()
    
    func getEvents() -> Observable<[GCEvent]> {
        return appService.request(path: "events/", method: .GET)
    }
}
