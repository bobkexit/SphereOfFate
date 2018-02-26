//
//  SharePost.swift
//  FortuneApp
//
//  Created by Николай Маторин on 26.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import FBSDKShareKit

class SharePost: NSObject, UIActivityItemSource {
    
    var prediction: String!
    var controller: UIViewController!
    
    init(withPrediction prediction: String, FromController controller: UIViewController) {
        super.init()
        self.prediction = prediction
        self.controller = controller
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType?) -> Any? {
        
        guard let prediction = prediction else {
            return nil
        }
        
        let textToShare = DataService.instance.GetSharingMessage(forPrediction: prediction)
        
        if activityType == .postToFacebook {
            activityViewController.dismiss(animated: true, completion: {
                self.postToFacebook()
            })
            return nil
        }
        
        return textToShare
    }
    
    func postToFacebook() {
        
        guard let prediction = prediction, let controller = controller, let url = URL(string: "https://www.google.com/")
            else { return }
        
        let textToShare = DataService.instance.GetSharingMessage(forPrediction: prediction)
        
        let content = FBSDKShareLinkContent()
        content.contentURL = url
        content.quote = textToShare
        
        let shareDialog = FBSDKShareDialog()
        shareDialog.fromViewController = controller
        shareDialog.shareContent = content
        shareDialog.mode = .shareSheet
        
        if !shareDialog.canShow() {
            // fallback presentation when there is no FB app
            shareDialog.mode = .feedBrowser
        }
        
        shareDialog.show()
    }
}
