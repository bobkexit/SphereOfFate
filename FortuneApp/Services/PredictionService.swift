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

struct PredictionService {
    
   static func makePrediction(completion: @escaping CompletionHandler) {
    
        guard let url = Bundle.main.url(forResource: Config.dataFileName, withExtension: Config.dataFileExtension) else {
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
            print(error)
            completion(nil, error)
        }
    }
    
}
