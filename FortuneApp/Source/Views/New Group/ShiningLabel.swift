//
//  ShineLabel.swift
//  FortuneApp
//
//  Created by Николай Маторин on 20/08/2019.
//  Copyright © 2019 Николай Маторин. All rights reserved.
//

import UIKit

class ShiningLabel: UILabel {
    
    var useAutoStart: Bool = false
    var shiningDuration: Double = 2.5
    var fadingOutDuration: Double = 2.5
    
    private var characterAnimationDurations: [Double] = []
    private var characterAnimationDelays: [Double] = []
    private var beginTime: CFTimeInterval = 0.0
    private var endTime: CFTimeInterval = 0.0
    private var isFadeOut: Bool = false
    private var isShining: Bool { return !displaylink.isPaused }
    private var competion: (() -> Void)?
    private var attributedString: NSMutableAttributedString? 
    private lazy var displaylink: CADisplayLink = self.makeDisplayLink()
    
    override var text: String? {
        didSet {
            attributedText = NSAttributedString(string: text ?? "")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    deinit {
        displaylink.invalidate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil, useAutoStart else { return }
        shine()
    }

    func shine(_ competion: (() -> Void)? = nil) {
        guard let text = text, !text.isEmpty, !isShining else {
            return
        }
        prepareForAnimationText(text, with: shiningDuration, competion: competion)
        startAnimation(with: shiningDuration)
    }
    
    func fadeOut(_ competion: (() -> Void)? = nil) {
        guard !isShining else {
            return
        }
        
        isFadeOut = true
        
        shine(competion)
    }

    private func prepareForAnimationText(_ text: String, with duration: Double, competion: (() -> Void)?) {
        self.competion = competion

        text.forEach { _ in
            let characterAnimationDelay = drand48()
            let characterAnimationDuration = drand48()

            characterAnimationDelays.append(characterAnimationDelay)
            characterAnimationDurations.append(characterAnimationDuration)
        }
        
         attributedString = makeMutableAttributedString(with: text)
    }

    private func startAnimation(with duration: Double) {
        beginTime = CACurrentMediaTime()
        endTime = beginTime + duration
        displaylink.isPaused = false
    }

    @objc private func updateAttributedString() {
        guard let attributedString = attributedString else {
            return
        }
        
        let now = CACurrentMediaTime()
        for i in 0..<attributedString.length {
            let ch = attributedString.string[i]
            if ch.isNewline || ch.isWhitespace { continue }

            let range = NSMakeRange(i, 1)

            attributedString.enumerateAttribute(
            .foregroundColor,
            in: range,
            options: .longestEffectiveRangeNotRequired) { (value, range, stop) in

                guard let textColor = value as? UIColor else {
                    return
                }
                
                let currentAlpha = textColor.cgColor.alpha

                let shouldUpdateAlpha = (isFadeOut && currentAlpha > 0)
                    || (!isFadeOut && currentAlpha < 0)
                    || ((now - beginTime) >= characterAnimationDelays[i])

                if !shouldUpdateAlpha {
                    return
                }

                var percentage = (now - beginTime - characterAnimationDelays[i]) / characterAnimationDurations[i]
                
                if isFadeOut {
                    percentage = 1 - percentage
                }

                let newColor = textColor.withAlphaComponent(CGFloat(percentage))
                attributedString.addAttribute(.foregroundColor, value: newColor, range: range)
            }
            
            attributedText = attributedString
        }
        
        if (now > endTime) {
            displaylink.isPaused = true
            
            if isFadeOut {
                isFadeOut = false
            }
            
            self.competion?()
        }
    }
    
    func makeDisplayLink() -> CADisplayLink {
        let displayLink =  CADisplayLink(target: self, selector: #selector(updateAttributedString))
        displayLink.isPaused = true
        displayLink.add(to: .main, forMode: .default)
        return displayLink
    }

    private func makeMutableAttributedString(with text: String) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: text)
        let attributes = makeAttributes()
        mutableAttributedString.addAttributes(attributes, range: NSMakeRange(0, text.count))
        return mutableAttributedString
    }
    
    private func makeAttributedString(with text: String, _ attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
    
    private func makeAttributes(withAlphaComponent alpha: CGFloat = 0.0) -> [NSAttributedString.Key: Any] {
        let color = textColor.withAlphaComponent(0)
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        return attributes
    }
}

private extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
