//
//  EventTests.swift
//  GreenChallengeTests
//
//  Created by Matheus Alano on 09/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

@testable import GreenChallenge
import XCTest

class EventTests: XCTestCase {

    var event: GCEvent!

    override func tearDown() {
        event = nil
        super.tearDown()
    }

    func testInitEventFromJSON() {
        guard let jsonURL = Bundle(for: EventTests.self).url(forResource: "EventStub", withExtension: "json") else {
            XCTFail("Missing EventStub json")
            return
        }
        
        var jsonData = Data()
        
        do {
            jsonData = try Data(contentsOf: jsonURL)
        } catch {
            XCTFail("Failed on parsing EventStub json")
        }
        
        do {
            event = try JSONDecoder().decode(GCEvent.self, from: jsonData)
            XCTAssertEqual(event.id, "1")
            XCTAssertEqual(event.people.count, 5)
            XCTAssertEqual(event.latitude, -30.0392981)
            XCTAssertEqual(event.longitude, -51.2146267)
        } catch {
            XCTFail("Failed to initialize Event from Decoder")
        }
    }
}
