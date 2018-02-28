//
//  Constants.swift
//  FortuneApp
//
//  Created by Николай Маторин on 25.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

enum Config {
    static let localizationFileName = "UILocalization"
    static let localizationFileExtension = "plist"
        
    static let dataFileName = "data.\(LocalizationHelper.shared.getLocale())"
    static let dataFileExtension = "json"
    
    static let keyForPredictionArray = "root"
    
    static let numberOfTriesPerHour = 5
    static let defaultLocale = "ru"
    
    static let appId = "APP_ID"
}

enum UILocalizationKeys {
    static let hintLabel = "HINT_LABEL"
    static let errorMesssageForUser = "ERROR_MESSAGE"
}

enum UserDefaultsKeys {
    static let appLaunchesCount = "APP_LAUNCHES_COUNT"
    static let appRatingShown = "APP_RATING_SHOWN"
}

enum UIColors {
    static let predictionTextColor = #colorLiteral(red: 0.4509803922, green: 0.5215686275, blue: 0.5921568627, alpha: 1)
}



