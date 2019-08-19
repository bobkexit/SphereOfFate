//
//  MagicSphereView.swift
//  FortuneApp
//
//  Created by Николай Маторин on 19/08/2019.
//  Copyright © 2019 Николай Маторин. All rights reserved.
//

import UIKit
import RQShineLabel

class MagicSphereView: UIView {
    
    private lazy var hintLabel: UILabel = self.makeHintLabel()
    private lazy var predictionLabel: RQShineLabel = self.makePredictionLabel()
    private lazy var sphereImageView: UIImageView = self.makeSphereImageView()
    private lazy var shareButton: UIButton = self.makeShareButton()
    private lazy var rateAppButton: UIButton = self.makeRateAppButton()
    private lazy var buttonStack: UIStackView = self.makeButtonStack()
    private lazy var layoutConstraints: [NSLayoutConstraint] = self.makeLayoutConstraints()
    private lazy var topContainer: UIView = self.makeViewContainer()
    private lazy var middleContainer: UIView = self.makeViewContainer()
    private lazy var bottomContainer: UIView = self.makeViewContainer()
    private lazy var gradientlayer: CAGradientLayer = self.makeGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shareButton.setNeedsLayout()
        shareButton.layoutIfNeeded()
        
        rateAppButton.setNeedsLayout()
        rateAppButton.layoutIfNeeded()
        
        shareButton.layer.cornerRadius = shareButton.bounds.width / 2
        rateAppButton.layer.cornerRadius = rateAppButton.bounds.width / 2
        
        let width = sphereImageView.bounds.width / 1.6
        let size = CGRect(x: 0, y: 0, width: width, height: width)
        predictionLabel.bounds = size
        predictionLabel.layer.cornerRadius = size.width / 2
        predictionLabel.layer.masksToBounds = true
        
        if layer.sublayers?.first != gradientlayer {
            layer.insertSublayer(gradientlayer, at: 0)
        }
    }
    
    private func initView() {
        addSubviews(topContainer, middleContainer, bottomContainer)

        topContainer.addSubviews(hintLabel)
        hintLabel.pinEdges(to: topContainer)
        
        middleContainer.addSubviews(predictionLabel, sphereImageView)
        sphereImageView.pinEdges(to: middleContainer)
        predictionLabel.center(in: middleContainer)

        bottomContainer.addSubviews(buttonStack)
        buttonStack.center(in: bottomContainer)

        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func showHint() {
        hintLabel.alpha = 0
        hintLabel.fadeIn(2.0, delay: 0, completion: {_ in })
    }
    
    func shake() {
        sphereImageView.shake()
    }
    
    func show(_ prediction: String?) {
        sphereImageView.shake() { [unowned self] in
            self.predictionLabel.isHidden = false
            self.predictionLabel.alpha = 1
            self.predictionLabel.text = prediction
            self.predictionLabel.shine()
        }
    }
    
    func hidePrediction(_ animated: Bool = true) {
        if animated {
            predictionLabel.fadeOut(1, delay: 0, completion: {_ in })
        } else {
            predictionLabel.isHidden = true
        }
    }
    
    func reset() {
        predictionLabel.text = nil
        shareButton.isHidden = true
        shareButton.alpha = 0
        rateAppButton.isHidden = true
        rateAppButton.alpha = 0
        hintLabel.alpha = 0
    }
    
    private func makeHintLabel() -> UILabel {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Shake the sphere"
        v.textAlignment = .center
        v.font = UIFont.systemFont(ofSize: 45.0, weight: .light)
        v.textColor = .white
        return v
    }
    
    private func makePredictionLabel() -> RQShineLabel {
        let v = RQShineLabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "prediction"
        v.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
        v.textColor = UIColor(red: 0.4529309869, green: 0.5190772414, blue: 0.595322907, alpha: 1)
        v.numberOfLines = 0
        v.textAlignment = .center
        return v
    }
    
    private func makeSphereImageView() -> UIImageView {
        let v = UIImageView(image: UIImage(named: "Crystal-ball"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }
    
    private func makeShareButton() -> UIButton {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Share Icon Solid")
        v.setImage(image, for: .normal)
        v.setImage(image, for: .selected)
        return v
    }
    
    private func makeRateAppButton() -> UIButton {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "RateApp Icon Solid")
        v.setImage(image, for: .normal)
        v.setImage(image, for: .selected)
        return v
    }
    
    private func makeButtonStack() -> UIStackView {
        let v = UIStackView(arrangedSubviews: [shareButton, rateAppButton])
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.alignment = .center
        v.distribution = .fillEqually
        v.spacing = 40
        return v
    }
    
    private func makeGradientLayer() -> CAGradientLayer {
        let topColor = UIColor(red: 0.4, green: 0.4980392157, blue: 0.5882352941, alpha: 1)
        let bottomColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = self.bounds
        
        return gradientLayer
    }
    
    private func makeViewContainer() -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
    
    private func makeLayoutConstraints() -> [NSLayoutConstraint] {
        return [
            topContainer.heightAnchor.constraint(equalToConstant: 128),
            topContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            middleContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            middleContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            middleContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            middleContainer.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor),
            
            bottomContainer.heightAnchor.constraint(equalToConstant: 128),
            bottomContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ]
    }
}
