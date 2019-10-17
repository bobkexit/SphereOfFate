//
//  SharePost.swift
//  FortuneApp
//
//  Created by Николай Маторин on 26.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class PredictionPost: NSObject, UIActivityItemSource {
    
    weak var viewController: UIViewController?
    let prediction: String
    
    init(prediction: String, viewController: UIViewController) {
        self.prediction = prediction
        self.viewController = viewController
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return post(for: prediction)
    }
 
    fileprivate func post(for prediction: String) -> String {
        
        guard let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return ""
        }
        
        let shareMessage = "\"\(prediction)\" - \(appName) (\(AppSettings.appStoreUrl))"
        
        return shareMessage
    }
}
