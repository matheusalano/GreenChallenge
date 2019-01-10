//
//  EventsListsViewModelTests.swift
//  GreenChallengeTests
//
//  Created by Matheus Alano on 09/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

@testable import GreenChallenge
import XCTest
import RxSwift
import RxTest

class EventsListsViewModelTests: XCTestCase {

    var viewModel: EventsListViewModel!
    var testScheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var service: EventsListServiceMock!
    
    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        service = EventsListServiceMock()
        viewModel = EventsListViewModel(service: service)
    }

    override func tearDown() {
        viewModel = nil
        service = nil
        super.tearDown()
    }

    func testInitViewModel() {
        viewModel = EventsListViewModel(service: service)
        
        testScheduler.createHotObservable([next(300, ())])
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        
        let result = testScheduler.start { self.viewModel.events.map({ $0[0].id }) }
        XCTAssertEqual(result.events, [next(300, "1")])
    }

    func testSelectEvent() {
        let event = service.event!
        
        testScheduler.createHotObservable([next(300, event)])
            .bind(to: viewModel.selectEvent)
            .disposed(by: disposeBag)
        
        let result = testScheduler.start { self.viewModel.openEventDetail }
        XCTAssertEqual(result.events, [next(300, "1")])
    }
}

class EventsListServiceMock: EventsListServiceProtocol {
    
    lazy var event: GCEvent? = {
        guard let jsonURL = Bundle(for: EventsListServiceMock.self).url(forResource: "EventStub", withExtension: "json") else {
            return nil
        }
        
        var jsonData = Data()
        
        do {
            jsonData = try Data(contentsOf: jsonURL)
        } catch {
        }
        
        do {
            let event = try JSONDecoder().decode(GCEvent.self, from: jsonData)
            
            return event
        } catch {
            return nil
        }
    }()
    
    func getEvents() -> Observable<[GCEvent]> {
        if let event = event {
            return Observable.just([event])
        }
        return .empty()
    }
}
