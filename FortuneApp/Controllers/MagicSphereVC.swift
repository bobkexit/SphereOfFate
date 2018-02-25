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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        predictionLabel.text = ""
        hintLabel.alpha = 0
        hintLabel.fadeIn(duration: 2.0)
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            sphereImageView.shake()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.updatePredictionLbl()
            })
        }
    }
    
    func updatePredictionLbl() {
        
        self.predictionLabel.fadeOut()
        
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
}
