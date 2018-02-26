//
//  LocalizationHelper.swift
//  FortuneApp
//
//  Created by Николай Маторин on 26.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class LocalizationHelper {
    
    static var sharedInstance = LocalizationHelper()
    
    fileprivate lazy var localizationDictionary: [String: Any]? = getlocalizationDictionary()
    
    private init() {
    }

    fileprivate func getlocalizationDictionary() -> [String: Any]? {
        guard let url = Bundle.main.url(forResource: Config.localizationFileName, withExtension: Config.localizationFileExtension) else {
            return nil
        }
        
        return NSDictionary(contentsOf: url) as? [String: Any]
    }
    
    static func getLocale() -> String {
        let pre = Locale.preferredLanguages.first
        let lang = pre?.components(separatedBy: "-").first
        return lang ?? Config.defaultLocale
    }
    
    static func getUIText(for key: String) -> String {
        
        let loc = LocalizationHelper.getLocale()
        
        guard let dict = LocalizationHelper.sharedInstance.localizationDictionary?[loc] as? [String: Any] else {
            return ""
        }
        guard let text = dict[key] as? String else {
            return ""
        }
        
        return text
    }
}
