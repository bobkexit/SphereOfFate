//
//  StoreReviewHelper.swift
//  FortuneApp
//
//  Created by Николай Маторин on 26.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import StoreKit

class RateAppController: RateAppManager {
    
    private(set) var isReviewRequested: Bool = false // For Unit Tests

    func requestReviewIfNeeded() {
        
        isReviewRequested = false
        
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
        isReviewRequested = true
    }
    
    private func incrementLaunchesCount() {
         let appLaunchesCount = getLaunchesCount()
         UserDefaults.standard.set(appLaunchesCount + 1, forKey: UserDefaults.Key.appLaunchesCount)
    }
    
    private func getLaunchesCount() -> Int {
        return UserDefaults.standard.integer(forKey: UserDefaults.Key.appLaunchesCount)
    }
}
