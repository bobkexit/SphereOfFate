//
//  Constants.swift
//  FortuneApp
//
//  Created by Николай Маторин on 25.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

enum Config {
    static let dataFileName = "data"
    static let dataFileExtension = "json"
    
    static let keyForPredictionArray = "root"
    static let appStoreUrl = "https://itunes.apple.com/app/id1354453250"
}

enum LocalizationKeys: String {
    case errorMessage
}

enum UserDefaultsKeys {
    static let appLaunchesCount = "APP_LAUNCHES_COUNT"
}

enum Colors {
    static let predictionTextColor = #colorLiteral(red: 0.4509803922, green: 0.5215686275, blue: 0.5921568627, alpha: 1)
}



