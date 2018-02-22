//
//  ViewController.swift
//  FortuneApp
//
//  Created by Николай Маторин on 21.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var predictionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.predictionLbl.text = ""
        
        
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            
            DataService.instance.makePrediction { (prediction, error) in
                if let error = error {
                    debugPrint(error)
                }
                
                guard let prediction = prediction else {
                    return
                }
            
                self.predictionLbl.text = ""
                self.predictionLbl.text = prediction
              
            }
        }
    }
}


