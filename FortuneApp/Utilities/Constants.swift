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
        
    static let dataFileName = "data.\(LocalizationHelper.getLocale())"
    static let dataFileExtension = "json"
    
    static let keyForPredictionArray = "root"
    
    static let numberOfTriesPerHour = 5
    static let defaultLocale = "ru"
}

enum UILocalizationKeys {
    static let hintLabel = "hintLabel"
    static let errorMesssageForUser = "errorMessage"
}

enum UserDefaultsKeys {
    static let appOpenedCount = "APP_OPENED_COUNT"
    static let wasReviewRequestInCurrentSession = "WAS_REVIEW_REQUEST_IN_CURRENT_SESSION"
}

enum UIColors {
    static let predictionTextColor = #colorLiteral(red: 0.4509803922, green: 0.5215686275, blue: 0.5921568627, alpha: 1)
}



