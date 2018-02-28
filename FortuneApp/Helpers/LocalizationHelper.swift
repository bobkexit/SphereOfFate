//
//  LocalizationHelper.swift
//  FortuneApp
//
//  Created by Николай Маторин on 26.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class LocalizationHelper {
    
    static var shared = LocalizationHelper()
    
    fileprivate lazy var localizationDictionary: [String: Any]? = getlocalizationDictionary()
    
    private init() {
    }

    fileprivate func getlocalizationDictionary() -> [String: AnyObject]? {
        guard let url = Bundle.main.url(forResource: Config.localizationFileName, withExtension: Config.localizationFileExtension) else {
            return nil
        }
        
        return NSDictionary(contentsOf: url) as? [String: AnyObject]
    }
    
    func getLocale() -> String {
        let pre = Locale.preferredLanguages.first
        let lang = pre?.components(separatedBy: "-").first
        return lang ?? Config.defaultLocale
    }
    
    func getUIText(for key: String) -> String {
        let loc = getLocale().uppercased()
        
        guard let dict = localizationDictionary?[loc] as? [String: AnyObject], let text = dict[key] as? String else {
            print("Localization for key \(key) not found")
            return ""
        }
    
        return text
    }
}
