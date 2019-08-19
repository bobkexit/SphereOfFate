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
    
    //MARK: - Outlets
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var predictionLabel: RQShineLabel!
    @IBOutlet weak var sphereImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var rateAppButton: UIButton!
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - View Actions
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            predictionLabel.fadeOut(1, delay: 0, completion: {_ in })
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            sphereImageView.shake()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.updateView()
                self.perform(#selector(self.fadeOutUIElements), with: nil, afterDelay: 5)
            })
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        guard let prediction = predictionLabel.text else {
            return
        }
        
        let sharePost = UIActivityService(with: prediction, from: self)
        
        let activityVC = UIActivityViewController(activityItems: [sharePost], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.excludedActivityTypes = [.airDrop, .postToFlickr, .postToVimeo, .saveToCameraRoll]
    
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func rateAppButtonPressed(_ sender: Any) {
        RateAppHelper.shared.requestReview()
    }
    
    //MARK: View Methods
   
    fileprivate func setupView() {
        predictionLabel.text = ""
        predictionLabel.textColor = Colors.predictionTextColor
        
        shareButton.isHidden = true
        shareButton.alpha = 0
        
        rateAppButton.isHidden = true
        rateAppButton.alpha = 0
        
        hintLabel.alpha = 0
        hintLabel.fadeIn(2.0, delay: 0, completion: {_ in })
    }
    
    fileprivate func updateView() {
        updatePredictionLabel()
        updateButtons()
    }
    
    //MARK: Controller Methods
    
    @objc func fadeOutUIElements() {
        predictionLabel.fadeOut(3, delay: 0, completion: {_ in })
        shareButton.fadeOut(3, delay: 0, completion: {_ in})
        rateAppButton.fadeOut(3, delay: 0, completion: {_ in})
    }
    
    fileprivate func updatePredictionLabel() {
        predictionLabel.alpha = 1
        
        predictionLabel.text = PredictionServiceImp.shared.getRandomPrediction()
        
//        PredictionService.shared.makePrediction { (prediction, error) in
//            if error != nil || prediction == nil {
//                self.predictionLabel.text = String(key: .errorMessage)
//            } else {
//                self.predictionLabel.text = prediction!
//            }
//            
//            if let emptyString = self.predictionLabel.text?.isEmpty, !emptyString {
//                self.predictionLabel.shine()
//            }
//        }
    }
    
    fileprivate func updateButtons() {
        if let emptyText = predictionLabel.text?.isEmpty, !emptyText {
            shareButton.isHidden = false
            shareButton.fadeIn(2.0, delay: 0, completion: {_ in })
            
            rateAppButton.isHidden = false
            rateAppButton.fadeIn(2.0, delay: 0, completion: {_ in })
        } else {
            shareButton.isHidden = true
            shareButton.alpha = 0
            
            rateAppButton.isHidden = true
            rateAppButton.alpha = 0
        }
    }
}


