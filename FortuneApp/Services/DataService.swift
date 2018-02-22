//
//  DataService.swift
//  FortuneApp
//
//  Created by Николай Маторин on 21.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataService {
    static let instance = DataService()
    
    private init() {}
    
    func makePrediction() -> String? {
        
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSON(data: data)
        } catch {
            debugPrint("Can't parse json file: \(error)")
        }
        
        return ""
    }
}
