//
//  DataService.swift
//  FortuneApp
//
//  Created by Николай Маторин on 21.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

typealias CompletionHandler = (_ prediction: String?, _ error: Error?) -> ()

protocol SyncService {
    func sync(_ completion: @escaping (_ error: Error?) -> Void)
    
}

protocol Predictor {
    func getRandomPrediction() -> String?
}

enum PredictionServiceError: Error, LocalizedError {
    case localError
    case fileNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .localError:
            return "Unrecognized system language code"
        case .fileNotFound(let name):
            return "Resource '\(name)' not found"
        }
    }
}

class PredictionService: SyncService, Predictor {
    
    static let shared = PredictionService()
    
    private var predictions: [String] = UserDefaults.standard.stringArray(forKey: UserDefaults.Keys.predictons) ?? []
    
    private var hashValue: Int = UserDefaults.standard.integer(forKey: UserDefaults.Keys.predictonsHash)
    
    private init() { }
    
    func getRandomPrediction() -> String? {
        if predictions.isEmpty { return nil }
        let randomIndex = Int.random(in: 0...predictions.count-1)
        let prediction = predictions[randomIndex]
        return prediction
    }
    
    func sync(_ completion: @escaping (_ error: Error?) -> Void) {
        
        if hashValue == predictions.hashValue {
            completion(nil)
            return
        }
        
        guard let languageCode = Locale.current.languageCode,
            let locale = languageCode.components(separatedBy: "-").first else {
                completion(PredictionServiceError.localError)
                return
        }
        
        let localizedFileName = "\(Config.dataFileName).\(locale.lowercased())"
        
        guard let url = Bundle.main.url(forResource: localizedFileName, withExtension: Config.dataFileExtension) else {
            completion(PredictionServiceError.fileNotFound(localizedFileName))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let predictons = try JSONDecoder().decode([String].self, from: data)
            UserDefaults.standard.setValue(predictons, forKey: UserDefaults.Keys.predictons)
            UserDefaults.standard.set(predictons.hashValue, forKey: UserDefaults.Keys.predictonsHash)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
