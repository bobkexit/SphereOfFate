//
//  StoreReviewHelper.swift
//  FortuneApp
//
//  Created by Николай Маторин on 26.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import StoreKit

protocol RateAppService {
    func requestReview()
    func requestReviewIfNeeded()
}

class RateAppHelper: RateAppService {
    
    static let shared = RateAppHelper()

    private let userDefaults = UserDefaults.standard
    
    private init() { }
    
    func requestReviewIfNeeded() {
        incrementLaunchesCount()
        
        let appLaunchesCount = getLaunchesCount()
        
        switch appLaunchesCount {
        case 3,10,50:
            requestReview()
        case _ where appLaunchesCount != 0 && appLaunchesCount%100 == 0:
            requestReview()
        default:
            print("App run count is : \(appLaunchesCount)")
            break;
        }
    }
    
    func requestReview() {
        SKStoreReviewController.requestReview()
    }
    
    private func incrementLaunchesCount() {
         let appLaunchesCount = getLaunchesCount()
         userDefaults.set(appLaunchesCount + 1, forKey: UserDefaults.Keys.appLaunchesCount)
    }
    
    private func getLaunchesCount() -> Int {
        return userDefaults.integer(forKey: UserDefaults.Keys.appLaunchesCount)
    }
}
