//
//  MagicSphereView.swift
//  FortuneApp
//
//  Created by Николай Маторин on 19/08/2019.
//  Copyright © 2019 Николай Маторин. All rights reserved.
//

import UIKit

protocol MagicSphereViewDelegate: AnyObject {
    func magicSphereViewDidTapRateAppButton(_ magicSphereView: MagicSphereView)
    func magicSphereView(_ magicSphereView: MagicSphereView, didTapShare prediction: String?)
}

class MagicSphereView: UIView {
    
    weak var delegate: MagicSphereViewDelegate?
    
    // MARK: - UI Properties
    
    private lazy var hintLabel: UILabel = self.makeHintLabel()
    private lazy var predictionLabel: BlingLabel = self.makePredictionLabel()
    private lazy var sphereImageView: UIImageView =  self.makeSphereImageView()
    private lazy var shareButton: UIButton = self.makeShareButton()
    private lazy var rateAppButton: UIButton = self.makeRateAppButton()
    private lazy var buttonStack: UIStackView = self.makeButtonStack()
    private lazy var gradientlayer: CAGradientLayer = self.makeGradientlayer()
    private lazy var topContainer: UIView = self.makeViewContainer()
    private lazy var middleContainer: UIView = self.makeViewContainer()
    private lazy var bottomContainer: UIView = self.makeViewContainer()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        addSubview(topContainer)
        addSubview(middleContainer)
        addSubview(bottomContainer)
        
        topContainer.addSubview(hintLabel)
        middleContainer.addSubview(sphereImageView)
        sphereImageView.addSubview(predictionLabel)
        bottomContainer.addSubview(buttonStack)
        
        setupConstraints()
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        
        hintLabel.pinEdges(to: topContainer)
        
        sphereImageView.pinEdges(to: middleContainer)
        
        predictionLabel.center(in: sphereImageView)
        
        buttonStack.center(in: bottomContainer)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints += [
            topContainer.heightAnchor.constraint(equalToConstant: 128),
            topContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ]
        
        constraints += [
            middleContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            middleContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            middleContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            middleContainer.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor),
        ]
        
        constraints += [
            bottomContainer.heightAnchor.constraint(equalToConstant: 128),
            bottomContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
        ]
        
        constraints += [
            predictionLabel.widthAnchor.constraint(equalTo:
                sphereImageView.widthAnchor, multiplier: 0.6),
            
            predictionLabel.heightAnchor.constraint(equalTo:
                sphereImageView.heightAnchor, multiplier: 0.5),
        ]
                  
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - View Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shareButton.setNeedsLayout()
        shareButton.layoutIfNeeded()
        
        rateAppButton.setNeedsLayout()
        rateAppButton.layoutIfNeeded()
        
        shareButton.layer.cornerRadius = shareButton.bounds.width / 2
        rateAppButton.layer.cornerRadius = rateAppButton.bounds.width / 2
        
        if layer.sublayers?.first != gradientlayer {
            layer.insertSublayer(gradientlayer, at: 0)
        }
    }
    
    // MARK: -
    
    public func displayHint() {
        hintLabel.alpha = 0
        hintLabel.fadeIn(2.0, delay: 0, completion: {_ in })
    }
    
    public func display(_ prediction: String?, completion: (() -> Void)? = nil) {
        sphereImageView.shake { [unowned self] in
            self.predictionLabel.text = prediction
            self.predictionLabel.display {
                self.buttonStack.fadeIn()
            }
        }        
    }
    
    public func dismissPrediction(animated: Bool = true) {
        
        if !animated {
            predictionLabel.alpha = 0
            buttonStack.alpha = 0
            return
        }
        
        predictionLabel.dismiss()
        buttonStack.fadeOut()
    }
    
    // MARK: - Actions
    
    @objc private func rateAppButtonTapped(_ sender: UIButton) {
        delegate?.magicSphereViewDidTapRateAppButton(self)
    }
    
    @objc private func shareButtonTapped(_ sender: UIButton) {
        delegate?.magicSphereView(self, didTapShare: predictionLabel.text)
    }
    
    // MARK: - Fabric methods
    
    private func makeViewContainer() -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
    
    private func makeHintLabel() -> UILabel {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Shake your phone".localized
        v.textAlignment = .center
        let fontSize: CGFloat = UIScreen.isSmallScreen ? 32.0 : 45.0
        v.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
        v.textColor = .white
        return v
    }
    
    private func makePredictionLabel() -> BlingLabel {
        let v = BlingLabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = ""
        let fontSize: CGFloat = UIScreen.isSmallScreen ? 14.0 : 22.0
        v.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        v.textColor = UIColor(red: 0.4529309869, green: 0.5190772414, blue: 0.595322907, alpha: 1)
        v.numberOfLines = 0
        v.textAlignment = .center
        v.numberOfLines = 0
        v.fadeInDuration = 1.5
        v.fadeOutDuration = 1.5

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
        v.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        return v
    }
    
    private func makeRateAppButton() -> UIButton {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "RateApp Icon Solid")
        v.setImage(image, for: .normal)
        v.setImage(image, for: .selected)
        v.addTarget(self, action: #selector(rateAppButtonTapped(_:)), for: .touchUpInside)
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
    
    private func makeGradientlayer() -> CAGradientLayer {
        let topColor = UIColor(red: 0.4, green: 0.4980392157, blue: 0.5882352941, alpha: 1)
        let bottomColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let l = CAGradientLayer()
        l.colors = [topColor.cgColor, bottomColor.cgColor]
        l.startPoint = CGPoint(x: 0.5, y: 0)
        l.endPoint = CGPoint(x: 0.5, y: 1)
        l.frame = self.bounds
        
        return l
    }
}
