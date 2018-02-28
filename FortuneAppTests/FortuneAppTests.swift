//
//  FortuneAppTests.swift
//  FortuneAppTests
//
//  Created by Николай Маторин on 28.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import XCTest
@testable import FortuneApp

class FortuneAppTests: XCTestCase {
    
    //var fortuneAppUnderTest: FortuneApp!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMakePrediction() {
        PredictionService.makePrediction { (prediction, error) in
           
            XCTAssertNil(error, error!.localizedDescription)
            
            XCTAssertNotNil(prediction, "prediction is nil")
            
            XCTAssertFalse(prediction!.isEmpty, "prediction is empty string")
        }
    }
    
    func testMakePredictionPerformance() {
        self.measure {
            PredictionService.makePrediction(completion: { (prediction, error) in
                
            })
        }
    }
    
    func testLocalizationHelper() {
        
    }
    
}
