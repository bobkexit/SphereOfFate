//
//  ViewController.swift
//  FortuneApp
//
//  Created by Николай Маторин on 21.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.instance.makePrediction()
    }

}

