//
//  SharePost.swift
//  FortuneApp
//
//  Created by Николай Маторин on 26.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import FBSDKShareKit

class UIActivityService: NSObject, UIActivityItemSource {
    
    let prediction: String
    unowned let controller: UIViewController
    
    init(with prediction: String, from controller: UIViewController) {
        self.prediction = prediction
        self.controller = controller
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == .postToFacebook {
            activityViewController.dismiss(animated: true, completion: {
                self.postToFacebook()
            })
            return nil
        }
        
        return GetShareMessage(forPrediction: prediction)
    }
    
    fileprivate func postToFacebook() {
        
        guard let url = URL(string: Config.appStoreUrl) else { return }
        
        let textToShare = GetShareMessage(forPrediction: prediction)
        
        let content = ShareLinkContent()
        content.contentURL = url
        content.quote = textToShare
        
        let shareDialog = ShareDialog()
        shareDialog.fromViewController = controller
        shareDialog.shareContent = content
        shareDialog.mode = .shareSheet
        
        if !shareDialog.canShow {
            // fallback presentation when there is no FB app
            shareDialog.mode = .feedBrowser
        }
        
        shareDialog.show()
    }
    
    fileprivate func GetShareMessage(forPrediction prediction: String) -> String {
        
        guard let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return ""
        }
        
        let shareMessage = "\"\(prediction)\" - \(appName)"
        
        return shareMessage
    }
}
