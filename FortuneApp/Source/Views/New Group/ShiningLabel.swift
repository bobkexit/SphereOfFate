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
    private var characterAnimationDurations: [Double] = []
    private var characterAnimationDelays: [Double] = []
    private var displaylink: CADisplayLink?
    private var beginTime: CFTimeInterval = 0.0
    private var endTime: CFTimeInterval = 0.0
    private var isFadeOut: Bool = false
    private var isShining: Bool { return displaylink?.isPaused ?? false }
    private lazy var attributedString: NSMutableAttributedString = self.makeMutableAttributedString()
    private var competion: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil, useAutoStart else { return }
        shine()
    }

    func shine(with duration: Double = 2.5, competion: (() -> Void)? = nil) {
        guard let text = text, !isShining else { return }
        prepareForAnimation(text, with: duration, competion: competion)
        startAnimation(with: duration)
    }
    
    func fadeOut(with duration: Double = 2.5, competion: (() -> Void)? = nil) {
        isFadeOut = true
        shine(with: duration, competion: competion)
    }

    private func prepareForAnimation(_ text: String, with duration: Double, competion: (() -> Void)?) {
        self.competion = competion

        text.forEach { _ in
            let characterAnimationDelay =  Double.random(in: 0...((duration / 2) * 100)) / 100
            let remain = duration - characterAnimationDelay
            let characterAnimationDuration = Double.random(in: 0...((remain / 100) * 100))

            characterAnimationDelays.append(characterAnimationDelay)
            characterAnimationDurations.append(characterAnimationDuration)
        }

        attributedText = attributedString
    }

    private func startAnimation(with duration: Double) {
        beginTime = CACurrentMediaTime()
        endTime = beginTime + duration

        displaylink?.invalidate()
        displaylink = CADisplayLink(target: self, selector: #selector(updateAttributedString))
        displaylink?.add(to: .main, forMode: .default)
    }

    @objc private func updateAttributedString() {
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

            if (now > endTime) {
                isFadeOut = false
                displaylink?.invalidate()
                self.competion?()
            }
        }

    }

    private func makeMutableAttributedString() -> NSMutableAttributedString {
        guard let text = text else {
            return NSMutableAttributedString(string: "")
        }
        
        let mutableAttributedString = NSMutableAttributedString(string: text)
        let color = textColor.withAlphaComponent(0)
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        mutableAttributedString.addAttributes(attributes, range: NSMakeRange(0, text.count))
        
        return mutableAttributedString
    }
}

private extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
