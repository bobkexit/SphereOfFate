//
//  PredictionControllerTests.swift
//  FortuneAppTests
//
//  Created by Nikolay Matorin on 19.10.2019.
//  Copyright © 2019 Николай Маторин. All rights reserved.
//

import XCTest
@testable import FortuneApp

class PredictionManagerTests: XCTestCase {

    var predictionManagerUnderTheTest: PredictionManager!
    
    override func setUp() {
        predictionManagerUnderTheTest = PredictionController()
    }

    override func tearDown() {
        predictionManagerUnderTheTest = nil
    }

    func testRandomPrediction() {
        
        let prediction1 = predictionManagerUnderTheTest.randomPrediction()
        let prediction2 = predictionManagerUnderTheTest.randomPrediction()
        
        XCTAssertNotNil(prediction1)
        XCTAssertNotNil(prediction2)
        XCTAssertFalse(prediction1!.isEmpty)
        XCTAssertFalse(prediction2!.isEmpty)
        XCTAssertNotEqual(prediction1, prediction2)
    }

    func testPerformanceRandomPrediction() {
        self.measure {
            let _ = predictionManagerUnderTheTest.randomPrediction()
        }
    }

}
