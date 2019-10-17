//
//  DataService.swift
//  FortuneApp
//
//  Created by Николай Маторин on 21.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

class PredictionController: PredictionManager {
    
    private weak var delegate: PredictionManagerDelegate?
    
    private lazy var predictions: [String] = self.makePredictions()
    
    func randomPrediction() -> String? {
        guard !predictions.isEmpty else { return nil }
        let randomIndex = Int.random(in: 0...predictions.count-1)
        let prediction = predictions[randomIndex]
        return prediction
    }
    
    func setDelegate(_ delegate: PredictionManagerDelegate?) {
        self.delegate = delegate
    }
    
    private func makePredictions() -> [String] {
        var result = [String]()
        
        guard let languageCode = Locale.current.languageCode,
            let locale = languageCode.components(separatedBy: "-").first else { return result }
        
        let localizedFileName = "\(AppSettings.dataFileName).\(locale.lowercased())"
        
        guard let url = Bundle.main.url(forResource: localizedFileName,
                                        withExtension: AppSettings.dataFileExtension) else {
                                            return result
        }
        
        do {
            let data = try Data(contentsOf: url)
            result = try JSONDecoder().decode([String].self, from: data)
        } catch {
            delegate?.predictionManager(self, didFailWith: error)
        }
        
        return result
    }
}
