//
//  EventDetailViewModel.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 10/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import Foundation
import RxSwift

final class EventDetailViewModel {
    
    // MARK: - Inputs
    let reload: AnyObserver<Void>
    let checkIn: AnyObserver<User>
    
    // MARK: - Outputs
    let event: Observable<GCEvent>
    let didCheckIn: Observable<Bool>
    let alert: Observable<String>
    
    // MARK: - Init
    init(eventId: String, service: EventDetailServiceProtocol = EventDetailService()) {
        let _reload = PublishSubject<Void>()
        reload = _reload.asObserver()
        
        let _alert = PublishSubject<String>()
        alert = _alert.asObserver()
        
        event = _reload.flatMap({_ in
            service.getEvent(by: eventId)
                .catchError({ error in
                    _alert.onNext(error.localizedDescription)
                    return Observable.empty()
                })
        })
        
        let _checkIn = PublishSubject<User>()
        checkIn = _checkIn.asObserver()
        
        didCheckIn = _checkIn.flatMap({ user in
            service.checkIn(to: eventId, name: user.name, email: user.email)
                .catchError({ error in
                    _alert.onNext(error.localizedDescription)
                    return Observable.empty()
                })
        })
    }
}
