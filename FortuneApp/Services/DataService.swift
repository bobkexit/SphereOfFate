//
//  DataService.swift
//  FortuneApp
//
//  Created by Николай Маторин on 21.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias CompletionHandler = (_ prediction: String?, _ error: Error?) -> ()

class DataService {
    static let instance = DataService()
    
    private init() {}
    
    func makePrediction(completion: @escaping CompletionHandler) {
        
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSON(data: data)
            
            let randomIndex = arc4random_uniform(UInt32(json.count))
            
            let prediction = json[String(randomIndex)]["ru"].stringValue
            
            completion(prediction, nil)
            
        } catch {
            completion(nil, error)
        }
        
    }
}
