//
//  ViewController.swift
//  FortuneApp
//
//  Created by Николай Маторин on 21.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import RQShineLabel

class MagicSphereVC: UIViewController {

    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var predictionLabel: RQShineLabel!
    @IBOutlet weak var sphereImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIDefaults()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            sphereImageView.shake()
            
            predictionLabel.fadeoutDuration = 2.0
            predictionLabel.fadeOut()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.updatePredictionLabel()
                self.updateShareButton()
            })
        }
    }
    
    func updatePredictionLabel() {
        
        DataService.instance.makePrediction { (prediction, error) in
            if let error = error {
                self.predictionLabel.text = "Упс, кажется шар сломался..."
                debugPrint(error)
            }
            
            guard let prediction = prediction else {
                return
            }
            
            self.predictionLabel.text = prediction
            self.predictionLabel.shine()
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
        
        hintLabel.alpha = 0
        hintLabel.fadeIn(2.0, delay: 0, completion: {_ in })
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        guard let prediction = predictionLabel.text else {
            return
        }
        
        let textToShare = "Предсказание от FortuneApp: \"\(prediction)\""
        
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        activityVC.excludedActivityTypes = [.airDrop, .postToFlickr, .postToVimeo, .saveToCameraRoll]
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
}
