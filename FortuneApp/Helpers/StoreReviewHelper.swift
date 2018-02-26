//
//  StoreReviewHelper.swift
//  FortuneApp
//
//  Created by Николай Маторин on 26.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import StoreKit

struct StoreReviewHelper {
    
    static let defaults = UserDefaults.standard
    
    static func incrementAppOpenedCount() { // called from appdelegate didfinishLaunchingWithOptions:
        var appOpenCount = defaults.integer(forKey: UserDefaultsKeys.appOpenedCount)
        appOpenCount += 1
        defaults.set(appOpenCount, forKey: UserDefaultsKeys.appOpenedCount)
        defaults.set(false, forKey: UserDefaultsKeys.wasReviewRequestInCurrentSession)
    }
    static func checkAndAskForReview() { // call this whenever appropriate
        // this will not be shown everytime. Apple has some internal logic on how to show this.
        
        guard let appOpenCount = defaults.value(forKey: UserDefaultsKeys.appOpenedCount) as? Int else {
            defaults.set(1, forKey: UserDefaultsKeys.appOpenedCount)
            return
        }
        
        switch appOpenCount {
        case 10,50:
            StoreReviewHelper().requestReview()
        case _ where appOpenCount%100 == 0 :
            StoreReviewHelper().requestReview()
        default:
            print("App run count is : \(appOpenCount)")
            break;
        }
        
    }
    fileprivate func requestReview() {
        
        let wasReviewRequest = StoreReviewHelper.defaults.bool(forKey: UserDefaultsKeys.wasReviewRequestInCurrentSession)
        
        if wasReviewRequest {
           return
        }
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
            // Try any other 3rd party or manual method here.
        }
        
        StoreReviewHelper.defaults.set(true, forKey: UserDefaultsKeys.wasReviewRequestInCurrentSession)
    }
}
