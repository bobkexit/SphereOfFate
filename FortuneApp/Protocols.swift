//
//  Protocols.swift
//  FortuneApp
//
//  Created by Nikolay Matorin on 17.10.2019.
//  Copyright © 2019 Николай Маторин. All rights reserved.
//

import Foundation

protocol PredictionManagerDelegate: AnyObject {
    func predictionManager(_ predictionManager: PredictionManager, didFailWith error: Error)
}

protocol PredictionManager {
    func randomPrediction() -> String?
    func setDelegate(_ delegate: PredictionManagerDelegate?)
}

protocol RateAppManager {
    func requestReview()
    func requestReviewIfNeeded()
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
