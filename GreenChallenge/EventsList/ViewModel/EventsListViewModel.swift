//
//  EventsListViewModel.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 09/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import Foundation
import RxSwift

final class EventsListViewModel {
    
    let selectEvent: AnyObserver<Event>
    let reload: AnyObserver<Void>
    
    let openEventDetail: Observable<String>
    let events: Observable<[Event]>
    let alert: Observable<String>
    
    init(service: EventsListServiceProtocol = EventsListService()) {
        
        let _reload = PublishSubject<Void>()
        reload = _reload.asObserver()
        
        let _alert = PublishSubject<String>()
        alert = _alert.asObservable()
        
        events = _reload.flatMap({_ in
            service.getEvents()
                .catchError({ error in
                    _alert.onNext(error.localizedDescription)
                    return Observable.empty()
                })
        })
        
        let _selectEvent = PublishSubject<Event>()
        selectEvent = _selectEvent.asObserver()
        openEventDetail = _selectEvent.asObservable().map({ $0.id })
    }
}
