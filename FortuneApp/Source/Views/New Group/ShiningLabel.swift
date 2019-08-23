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
        animateLabel(with: shiningDuration, competion: competion)
    }
    
    func fadeOut(_ competion: (() -> Void)? = nil) {
        isFadeOut = true
        animateLabel(with: fadingOutDuration, competion: competion)
    }
    
    private func animateLabel(with duration: Double, competion: (() -> Void)? = nil) {
        guard let text = text, !text.isEmpty, !isShining else {
            return
        }
        self.text = nil
        prepareForAnimationText(text, with: duration, competion: competion)
        startAnimation(with: duration)
    }

    private func prepareForAnimationText(_ text: String, with duration: Double, competion: (() -> Void)?) {
        self.competion = competion

        text.forEach { _ in
          
            let characterAnimationDelay = Double.random(in: 0..<(duration / 2 * 100)) / 100
            let remain = duration - characterAnimationDelay
            let characterAnimationDuration = Double.random(in: 0..<(remain * 100)) / 100

            characterAnimationDelays.append(characterAnimationDelay)
            characterAnimationDurations.append(characterAnimationDuration)
        }
        
        let alpha: CGFloat = isFadeOut ? 1 : 0
        attributedString = makeMutableAttributedString(with: text, withAlphaComponent: alpha)
    }

    private func startAnimation(with duration: Double) {
        beginTime = CACurrentMediaTime()
        endTime = beginTime + duration
        displaylink.isPaused = false
    }
    
    @objc func updateLabel() {
        let now = CACurrentMediaTime()
        updateAttributedStringFor(now)
        guard now > endTime else { return }
        displaylink.isPaused = true
        isFadeOut = false
        competion?()
    }

    private func updateAttributedStringFor(_ now: CFTimeInterval) {
        guard let attributedString = attributedString else {
            return
        }
        
        for (index, character) in attributedString.string.enumerated() {
            if character.isNewline || character.isWhitespace { continue }
            let range = NSMakeRange(index, 1)
            attributedString.enumerateAttribute(
                .foregroundColor,
                in: range,
                options: .longestEffectiveRangeNotRequired) { (value, range, stop) in
                    
                    guard let textColor = value as? UIColor else {
                        return
                    }
                    
//                    let currentAlpha = textColor.cgColor.alpha
//
//                    let shouldUpdateAlpha = (isFadeOut && currentAlpha > 0)
//                        || (!isFadeOut && currentAlpha < 0)
//                        || ((now - beginTime) >= characterAnimationDelays[index])
//
//                    if !shouldUpdateAlpha {
//                        return
//                    }
//
                    var percentage = (now - beginTime - characterAnimationDelays[index]) / characterAnimationDurations[index]
                    
                    if isFadeOut {
                        percentage = 1 - percentage
                    }
                    
                    let newColor = textColor.withAlphaComponent(CGFloat(percentage))
                    attributedString.addAttribute(.foregroundColor, value: newColor, range: range)
                    print(percentage)
                    
            }
        }
        attributedText = attributedString
    }
    
    func makeDisplayLink() -> CADisplayLink {
        let displayLink =  CADisplayLink(target: self, selector: #selector(updateLabel))
        displayLink.isPaused = true
        displayLink.add(to: .main, forMode: .default)
        return displayLink
    }

    private func makeMutableAttributedString(with text: String, withAlphaComponent alpha: CGFloat = 0.0) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: text)
        let attributes = makeAttributes(withAlphaComponent: alpha)
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
