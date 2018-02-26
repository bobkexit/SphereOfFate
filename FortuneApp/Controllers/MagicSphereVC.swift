//
//  ViewController.swift
//  FortuneApp
//
//  Created by Николай Маторин on 21.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import RQShineLabel
import FBSDKShareKit

class MagicSphereVC: UIViewController {
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var predictionLabel: RQShineLabel!
    @IBOutlet weak var sphereImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIDefaults()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            predictionLabel.fadeOut(1, delay: 0, completion: {_ in })
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if event?.subtype == .motionShake {
            sphereImageView.shake()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.updatePredictionLabel()
                self.updateShareButton()
                
                self.perform(#selector(self.fadeOutPrediction), with: nil, afterDelay: 5)
                
               
            })
        }
    }
    
    @objc func fadeOutPrediction() {
        predictionLabel.fadeOut(3, delay: 0, completion: {_ in })
        shareButton.fadeOut(3, delay: 0, completion: {_ in})
        StoreReviewHelper.checkAndAskForReview()
    }
    
    func updatePredictionLabel() {
        
        predictionLabel.alpha = 1
        
        DataService.instance.makePrediction { (prediction, error) in
            
            if error != nil && prediction == nil {
                self.predictionLabel.text = DataService.instance.getUIMessage(for: Config.keyForUIErrorMsg)
            } else {
                self.predictionLabel.text = prediction!
            }
            
            if let emptyString = self.predictionLabel.text?.isEmpty, !emptyString {
                self.predictionLabel.shine()
            }
        }
        
    }
    
    func updateShareButton() {
        if let emptyText = predictionLabel.text?.isEmpty, !emptyText {
            shareButton.isHidden = false
            shareButton.fadeIn(2.0, delay: 0, completion: {_ in })
        } else {
            shareButton.isHidden = true
            shareButton.alpha = 0
        }
    }
    
    func configureUIDefaults() {
        
        predictionLabel.text = ""
        predictionLabel.textColor = #colorLiteral(red: 0.4507009983, green: 0.5201236606, blue: 0.5908517241, alpha: 1)
        
        shareButton.isHidden = true
        shareButton.alpha = 0
        
        
        guard let hintText = DataService.instance.getUIMessage(for: Config.keyForUIHintMsg) else {
            return
        }
        
        hintLabel.alpha = 0
        hintLabel.text = hintText
        hintLabel.fadeIn(2.0, delay: 0, completion: {_ in })
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        guard let prediction = predictionLabel.text else {
            return
        }
        
        let sharePost = SharePost(withPrediction: prediction, FromController: self)
        
        let activityVC = UIActivityViewController(activityItems: [sharePost], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.excludedActivityTypes = [.airDrop, .postToFlickr, .postToVimeo, .saveToCameraRoll]
        
        self.present(activityVC, animated: true, completion: nil)
    }
}


