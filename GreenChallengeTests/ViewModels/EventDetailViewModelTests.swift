//
//  EventDetailViewModelTests.swift
//  GreenChallengeTests
//
//  Created by Matheus Alano on 10/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

@testable import GreenChallenge
import XCTest
import RxSwift
import RxTest

class EventDetailViewModelTests: XCTestCase {

    var viewModel: EventDetailViewModel!
    var testScheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var service: EventDetailServiceMock!
    
    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        service = EventDetailServiceMock()
        viewModel = EventDetailViewModel(eventId: "", service: service)
    }

    override func tearDown() {
        viewModel = nil
        service = nil
        super.tearDown()
    }
    
    func testInitViewModel() {
        testScheduler.createHotObservable([next(300, ())])
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        
        let result = testScheduler.start { self.viewModel.event.map({ $0.id }) }
        XCTAssertEqual(result.events, [next(300, "1")])
    }
    
    func testCheckIn() {
        let user = User(name: "Matheus", email: "matheus@mail.com")
        
        testScheduler.createHotObservable([next(300, user)])
            .bind(to: viewModel.checkIn)
            .disposed(by: disposeBag)
        
        let result = testScheduler.start { self.viewModel.didCheckIn }
        XCTAssertEqual(result.events, [next(300, true)])
    }
}

class EventDetailServiceMock: EventDetailServiceProtocol {
    
    lazy var event: GCEvent? = {
        guard let jsonURL = Bundle(for: EventDetailServiceMock.self).url(forResource: "EventStub", withExtension: "json") else {
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
    
    func getEvent(by id: String) -> Observable<GCEvent> {
        if let event = event {
            return Observable.just(event)
        }
        return .empty()
    }
    
    func checkIn(to eventId: String, name: String, email: String) -> Observable<Bool> {
        return Observable.just(true)
    }
}
