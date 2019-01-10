//
//  EventDetailService.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 10/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import Foundation
import RxSwift

protocol EventDetailServiceProtocol {
    func getEvent(by id: String) -> Observable<GCEvent>
    func checkIn(to eventId: String, name: String, email: String) -> Observable<Bool>
}

class EventDetailService: EventDetailServiceProtocol {
    
    private let appService = AppService()
    
    func getEvent(by id: String) -> Observable<GCEvent> {
        return appService.request(path: "events/\(id)/", method: .GET)
    }
    
    func checkIn(to eventId: String, name: String, email: String) -> Observable<Bool> {
        let parameters: [String: Any] = ["eventId": eventId, "name": name, "email": email]
        return appService.requestNoReturn(path: "checkin/", method: .POST, parameters: parameters)
    }
}
