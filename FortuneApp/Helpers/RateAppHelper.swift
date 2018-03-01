//
//  StoreReviewHelper.swift
//  FortuneApp
//
//  Created by Николай Маторин on 26.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import StoreKit

class RateAppHelper {
    
    public static var shared = RateAppHelper()

    fileprivate let userDefaults = UserDefaults.standard
    
    private init() {
        
    }
    
    // called from appdelegate didfinishLaunchingWithOptions:
    func displayRatingsPromptIfRequired() {
        incrementLaunchesCount()
        
        let appLaunchesCount = getLaunchesCount()
        
        switch appLaunchesCount {
        case 3,10,50:
            RateAppHelper().requestReview()
        case _ where appLaunchesCount != 0 && appLaunchesCount%100 == 0:
            RateAppHelper().requestReview()
        default:
            print("App run count is : \(appLaunchesCount)")
            break;
        }
    }
    
    func rateApp(completion: @escaping (_ hasError: Bool) -> Void) {
        if let url = Bundle.main.url(forResource: "Info", withExtension: "plist"), let dict = NSDictionary(contentsOf: url) as? [String: AnyObject] {
            guard let appId = dict[Config.appId] as? String, !appId.isEmpty else {
                print("Key APP_ID not found in Info.plist ")
                completion(true)
                return
            }
            openUrl("itms-apps://itunes.apple.com/app/\(appId)")
            completion(false)
        }
    }
    
    fileprivate func incrementLaunchesCount() {
         let appLaunchesCount = getLaunchesCount()
         userDefaults.set(appLaunchesCount + 1, forKey: UserDefaultsKeys.appLaunchesCount)
    }
    
    fileprivate func getLaunchesCount() -> Int {
        return userDefaults.integer(forKey: UserDefaultsKeys.appLaunchesCount)
    }
    
    fileprivate func openUrl(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
            // Try any other 3rd party or manual method here.
        }
    }
}
