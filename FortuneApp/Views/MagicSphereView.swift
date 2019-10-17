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
    
    // MARK: - UI
    private(set) lazy var hintLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Shake the sphere".localized
        v.textAlignment = .center
        v.font = UIFont.systemFont(ofSize: 45.0, weight: .light)
        v.textColor = .white
        return v
    } ()
    
    
    private(set) lazy var predictionLabel: BlingLabel = {
        let v = BlingLabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "prediction"
        v.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
        v.textColor = UIColor(red: 0.4529309869, green: 0.5190772414, blue: 0.595322907, alpha: 1)
        v.numberOfLines = 0
        v.textAlignment = .center
        v.numberOfLines = 0
        v.fadeInDuration = 1.5
        v.fadeOutDuration = 1.5

        return v
    } ()
    
    private(set) lazy var sphereImageView: UIImageView =  {
        let v = UIImageView(image: UIImage(named: "Crystal-ball"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    } ()
    
    private(set) lazy var shareButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Share Icon Solid")
        v.setImage(image, for: .normal)
        v.setImage(image, for: .selected)
        v.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        return v
    } ()
    
    private(set) lazy var rateAppButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "RateApp Icon Solid")
        v.setImage(image, for: .normal)
        v.setImage(image, for: .selected)
        v.addTarget(self, action: #selector(rateAppButtonTapped(_:)), for: .touchUpInside)
        return v
    } ()
    
    private lazy var buttonStack: UIStackView = {
        let v = UIStackView(arrangedSubviews: [shareButton, rateAppButton])
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.alignment = .center
        v.distribution = .fillEqually
        v.spacing = 40
        return v
    } ()
        
    private lazy var gradientlayer: CAGradientLayer = {
        let topColor = UIColor(red: 0.4, green: 0.4980392157, blue: 0.5882352941, alpha: 1)
        let bottomColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = self.bounds
        
        return gradientLayer
    } ()
    
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
    
    func displayHint() {
        hintLabel.alpha = 0
        hintLabel.fadeIn(2.0, delay: 0, completion: {_ in })
    }
    
    func display(_ prediction: String?, completion: (() -> Void)? = nil) {
        sphereImageView.shake { [unowned self] in
            self.predictionLabel.text = prediction
            self.predictionLabel.display {
                self.buttonStack.fadeIn()
            }
        }        
    }
    
    func dismissPrediction(animated: Bool = true) {
        
        if !animated {
            predictionLabel.alpha = 0
            buttonStack.alpha = 0
            return
        }
        
        predictionLabel.dismiss()
        buttonStack.fadeOut()
    }
    
    @objc private func rateAppButtonTapped(_ sender: UIButton) {
        delegate?.magicSphereViewDidTapRateAppButton(self)
    }
    
    @objc private func shareButtonTapped(_ sender: UIButton) {
        delegate?.magicSphereView(self, didTapShare: predictionLabel.text)
    }
    
    private func makeViewContainer() -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
}
