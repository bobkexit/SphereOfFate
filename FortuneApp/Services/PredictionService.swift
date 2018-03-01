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

class PredictionService {
    
    public static var shared = PredictionService()
    
    private init() {
        
    }
    
    func makePrediction(completion: @escaping CompletionHandler) {
        
        guard let pre = Locale.current.languageCode, let locale = pre.components(separatedBy: "-").first else {
            fatalError("Can't get current language")
        }
        
        let localizedDataFile = "\(Config.dataFileName).\(locale.lowercased())"
        
        guard let url = Bundle.main.url(forResource: localizedDataFile, withExtension: Config.dataFileExtension) else {
            fatalError("Can't get url for resource: \(localizedDataFile)")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSON(data: data)
            
            let array = json[Config.keyForPredictionArray].arrayValue
            let randomIndex = arc4random_uniform(UInt32(array.count))
            let prediction = array[Int(randomIndex)].stringValue
            
            completion(prediction, nil)
            
        } catch {
            print(error)
            completion(nil, error)
        }
    }
    
}
