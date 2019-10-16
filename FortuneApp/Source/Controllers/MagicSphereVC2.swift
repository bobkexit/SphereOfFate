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
    
    private lazy var rootView: MagicSphereView = MagicSphereView()
    
    private let rateAppService: RateAppService
    
    private let predictorManager: PredictorManager
    
    private weak var timer: Timer?
    
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
        
        rootView.shareButton.addTarget(
            self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        
        rootView.rateAppButton.addTarget(
            self, action: #selector(rateAppButtonTapped(_:)), for: .touchUpInside)
        
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
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        timer?.invalidate()
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard event?.subtype == .motionShake else {
            return
        }
        updatePrediction()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard event?.subtype == .motionShake else {
            return
        }
        
        updatePrediction()
    }
    
    @objc private func rateAppButtonTapped(_ sender: UIButton) {
        updatePrediction()
    }
    
    @objc private func shareButtonTapped(_ sender: UIButton) {
        updatePrediction()
    }
    
    private func updatePrediction() {
        let prediction = predictorManager.getRandomPrediction()
        rootView.update(prediction, animated: true, completion: nil)
    }
    
    private func autoHidePrediction() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak rootView] (_) in
            rootView?.hidePrediction()
        }
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
}
