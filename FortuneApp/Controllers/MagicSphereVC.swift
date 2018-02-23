//
//  ViewController.swift
//  FortuneApp
//
//  Created by Николай Маторин on 21.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class MagicSphereVC: UIViewController {

    @IBOutlet weak var predictionLbl: UILabel!
    @IBOutlet weak var ballImgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.predictionLbl.text = ""
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            
            ballImgView.shake()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.updatePredictionLbl()
            })
        }
    }
    
    func updatePredictionLbl() {
        predictionLbl.text = ""
        DataService.instance.makePrediction { (prediction, error) in
            if let error = error {
                self.predictionLbl.text = "Упс, кажется шар сломался..."
                debugPrint(error)
            }
            
            guard let prediction = prediction else {
                return
            }
            
            self.predictionLbl.text = prediction
        }
    }
}
