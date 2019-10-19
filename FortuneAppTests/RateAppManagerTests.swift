//
//  RateAppManagerTests.swift
//  FortuneAppTests
//
//  Created by Nikolay Matorin on 19.10.2019.
//  Copyright © 2019 Николай Маторин. All rights reserved.
//

import XCTest
@testable import FortuneApp

class RateAppManagerTests: XCTestCase {
    
    var rateAppManagerUnderTheTest: RateAppManager!
    var appLaunchesCount: Int = 0
    
    override func setUp() {
        rateAppManagerUnderTheTest = RateAppController()
        appLaunchesCount = UserDefaults.standard.integer(forKey: UserDefaults.Key.appLaunchesCount)
    }
    
    override func tearDown() {
        rateAppManagerUnderTheTest = nil
        UserDefaults.standard.set(appLaunchesCount, forKey: UserDefaults.Key.appLaunchesCount)
    }
    
    func testRequestReview() {
        XCTAssertFalse(rateAppManagerUnderTheTest.isReviewRequested)
        rateAppManagerUnderTheTest.requestReview()
        XCTAssertTrue(rateAppManagerUnderTheTest.isReviewRequested)
    }
    
    func testRequestReviewIfNeeded_when_appLaunchesCount_equal_1() {
        UserDefaults.standard.set(0, forKey: UserDefaults.Key.appLaunchesCount)
        XCTAssertFalse(rateAppManagerUnderTheTest.isReviewRequested)
        rateAppManagerUnderTheTest.requestReviewIfNeeded()
        XCTAssertFalse(rateAppManagerUnderTheTest.isReviewRequested)
    }
    
    func testRequestReviewIfNeeded_when_appLaunchesCount_equal_3() {
        UserDefaults.standard.set(2, forKey: UserDefaults.Key.appLaunchesCount)
        XCTAssertFalse(rateAppManagerUnderTheTest.isReviewRequested)
        rateAppManagerUnderTheTest.requestReviewIfNeeded()
        XCTAssertTrue(rateAppManagerUnderTheTest.isReviewRequested)
    }
    
    func testRequestReviewIfNeeded_when_appLaunchesCount_equal_200() {
        UserDefaults.standard.set(199, forKey: UserDefaults.Key.appLaunchesCount)
        XCTAssertFalse(rateAppManagerUnderTheTest.isReviewRequested)
        rateAppManagerUnderTheTest.requestReviewIfNeeded()
        XCTAssertTrue(rateAppManagerUnderTheTest.isReviewRequested)
    }
    
    func testPerformanceReviewIfNeeded() {
        // This is an example of a performance test case.
        self.measure {
            rateAppManagerUnderTheTest.requestReviewIfNeeded()
        }
    }
    
}
