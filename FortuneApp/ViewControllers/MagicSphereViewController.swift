//
//  MagicSphereViewController.swift
//  FortuneApp
//
//  Created by Николай Маторин on 19/08/2019.
//  Copyright © 2019 Николай Маторин. All rights reserved.
//

import UIKit

class MagicSphereViewController: NiblessViewController {
    
    // MARK: - Properties
    
    private weak var timer: Timer?
    private let rateAppManager: RateAppManager
    private let predictionManager: PredictionManager
    private lazy var rootView: MagicSphereView = MagicSphereView()
    
    // MARK: - Init
    
    init(rateAppManager: RateAppManager, predictionManager: PredictionManager) {
        self.rateAppManager = rateAppManager
        self.predictionManager = predictionManager
        super.init()
    }
    
    // MARK: - View Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.delegate = self
        predictionManager.setDelegate(self)
        
        rootView.displayHint()
        rootView.dismissPrediction(animated: false)
        rateAppManager.requestReviewIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        autoDismissPrediction()
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard event?.subtype == .motionShake else { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        timer?.invalidate()
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard event?.subtype == .motionShake else { return }
        updatePrediction()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard event?.subtype == .motionShake else { return }
        updatePrediction()
    }
    
    // MARK: -
    
    private func updatePrediction() {
        let prediction = predictionManager.randomPrediction()
        rootView.display(prediction)
        autoDismissPrediction()
    }
    
    private func autoDismissPrediction() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: false) { [weak rootView] (_) in
            rootView?.dismissPrediction()
        }
    }
    
    private func share(_ prediction: String) {
        let sharePost = PredictionPost(prediction: prediction, viewController: self)
        
        let activityVC = UIActivityViewController(activityItems: [sharePost], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        activityVC.excludedActivityTypes = [.airDrop, .postToFlickr, .postToVimeo, .saveToCameraRoll]
        activityVC.completionWithItemsHandler = { [unowned self] (type, completed, items, error) in
            if let error = error {
                self.show(error)
            }
            
            if !completed && type == nil {
                self.rootView.dismissPrediction()
            }
        }
        
        present(activityVC, animated: true)
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

// MARK: - MagicSphereView Delegate Methods

extension MagicSphereViewController: MagicSphereViewDelegate {
    func magicSphereViewDidTapRateAppButton(_ magicSphereView: MagicSphereView) {
        rateAppManager.requestReview()
    }
    
    func magicSphereView(_ magicSphereView: MagicSphereView, didTapShare prediction: String?) {
        guard let prediction = prediction else { return }
        timer?.invalidate()
        share(prediction)
    }
}

// MARK: - PredictionManager Delegate Methods

extension MagicSphereViewController: PredictionManagerDelegate {
    func predictionManager(_ predictionManager: PredictionManager, didFailWith error: Error) {
        show(error)
    }
}
