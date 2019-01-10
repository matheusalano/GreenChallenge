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

class EventsListsViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class EventsListServiceMock: EventsListServiceProtocol {
    
    func getEvents() -> Observable<[Event]> {
        guard let jsonURL = Bundle(for: EventsListServiceMock.self).url(forResource: "EventStub", withExtension: "json") else {
            return
        }
        
        var jsonData = Data()
        
        do {
            jsonData = try Data(contentsOf: jsonURL)
        } catch {
        }
        
        do {
            let event = try JSONDecoder().decode(Event.self, from: jsonData)
            
            return Observable.just([event])
        } catch {
            
        }
    }
}
