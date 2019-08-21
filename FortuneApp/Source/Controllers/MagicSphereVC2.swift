//
//  MagicSphereVC2.swift
//  FortuneApp
//
//  Created by Николай Маторин on 19/08/2019.
//  Copyright © 2019 Николай Маторин. All rights reserved.
//

import UIKit

class MagicSphereVC2: NiblessViewController {
    
    typealias PredictorManager = Predictor & SyncService
    
    private lazy var rootView: MagicSphereView = self.makeRootView()
    private let rateAppService: RateAppService
    private let predictorManager: PredictorManager
    
    init(rateAppService: RateAppService, predictorManager: PredictorManager) {
        self.rateAppService = rateAppService
        self.predictorManager = predictorManager
        super.init()
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        predictorManager.sync { [unowned self] error in
            
            if let error = error {
                self.show(error)
                return
            }
            
            self.rootView.showHint()
            self.rateAppService.requestReviewIfNeeded()
        }
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard event?.subtype == .motionShake else {
            return
        }
        
        //NSObject.cancelPreviousPerformRequests(withTarget: self)
        //rootView.hidePrediction()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard event?.subtype == .motionShake else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            self.updatePrediction()
        }
    }
    
    private func updatePrediction() {
        let newPrediction = predictorManager.getRandomPrediction()
        rootView.show(newPrediction)
    }
    
    private func show(_ error: Error) {
        let alert = UIAlertController(
            title: "error".localized.capitalizingFirstLetter(),
            message: "errorMessage".localized.capitalizingFirstLetter(),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: "cancel".localized.capitalizingFirstLetter(),
            style: .cancel
        )
        
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func makeRootView() -> MagicSphereView {
        let v = MagicSphereView()
        return v
    }
}
