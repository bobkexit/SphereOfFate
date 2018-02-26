//
//  DataService.swift
//  FortuneApp
//
//  Created by Николай Маторин on 21.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias CompletionHandler = (_ prediction: String?, _ error: Error?) -> ()

class DataService {

    static let instance = DataService()
    
    private var plistData: [String: Any]?
   
    private var lang: String {
        get {
            let pre = Locale.preferredLanguages.first
            let lang = pre?.components(separatedBy: "-").first
            return lang ?? ""
        }
    }
    
    private init() {
        loadPlistData()
    }
    
    func loadPlistData() {
        
        guard let url = Bundle.main.url(forResource: "UILocalization", withExtension: "plist") else {
            return
        }
        
        plistData = NSDictionary(contentsOf: url) as? [String: Any]
    }
    
    func getUIMessage(for key: String) -> String? {
        guard let data = plistData?[lang] as? [String: Any] else {
            return nil
        }
        
        let message = data[key] as? String
    
        return message
    }
    
    private func getPredictionArray() -> [String]? {
        
        guard let data = plistData?[lang] as? [String: Any] else {
            return nil
        }
        
        let array = data["predictions"] as? [String]
        
        return array
    }
        
    func makePrediction(completion: @escaping CompletionHandler) {
        
        guard let url = Bundle.main.url(forResource: "data.\(lang)", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSON(data: data)
            
            let array = json[Config.keyForPredictionArray].arrayValue
            let randomIndex = arc4random_uniform(UInt32(array.count))
            let prediction = array[Int(randomIndex)].stringValue
            
            completion(prediction, nil)
            
        } catch {
            debugPrint(error)
            completion(nil, error)
        }
        
    }
    
    func GetSharingMessage(forPrediction prediction: String) -> String {
        
        var textToShare = "\"\(prediction)\""
        
        if let shareMsg = DataService.instance.getUIMessage(for: Config.keyForShareText),
            let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String {
            textToShare += " \(shareMsg) \(appName)"
        }
        
        return textToShare
    }
}
