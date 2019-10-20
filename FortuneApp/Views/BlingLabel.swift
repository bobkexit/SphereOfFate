//
//  BlingLabel.swift
//  FortuneApp
//
//  Created by Nikolay Matorin on 15.10.2019.
//  Copyright © 2019 Николай Маторин. All rights reserved.
//

import UIKit

fileprivate enum AnimationState {
    case none
    case fadingOut
    case fadingIn
}

class BlingLabel: UILabel {

    // MARK: - Properties
    
    public var fadeInDuration: CGFloat = 1.5
    public var fadeOutDuration: CGFloat = 1.5
    public var attributedString: NSMutableAttributedString?

    private var displayLink: CADisplayLink?
    private var beginTime: CFTimeInterval?
    private var characterDurationArray: [CGFloat] = []
    private var animationState: AnimationState = .none
    private var textColorAlpha: CGFloat = 1
    private var completionHandler: (() -> Void)?
    
    override var textColor: UIColor! {
        didSet {
            guard textColor.cgColor.alpha > 0 else { return }
            textColorAlpha = textColor.cgColor.alpha
        }
    }
    
    // MARK: - Public methods
    
    public func display(completion: (() -> Void)? = nil) {
        animationState = .fadingIn
        animateLabel(with: completion)
    }
    
    public func dismiss(completion: (() -> Void)? = nil) {
        animationState = .fadingOut
        animateLabel(with: completion)
    }
    
    private func animateLabel(with completion: (() -> Void)?) {
        prepareForAnimation(with: completion)
        startAnimation()
    }
    
    // MARK: - Private methods
    
    private func prepareForAnimation(with completion: (() -> Void)?) {
        let duration = durationFor(animationState)
        fillCharacterDurationArray(for: duration)
        completionHandler = completion
        guard let text = text else { return }
        attributedString = makeAttributedString(for: text, with: animationState)
        attributedText = attributedString
    }
    
    private func startAnimation() {
        beginTime = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(updateAttributedString))
        displayLink!.isPaused = false
        displayLink!.add(to: .main, forMode: .default)
    }
    
    private func stopAnimation() {
        displayLink?.isPaused = true
        beginTime = nil
        animationState = .none
        completionHandler?()
        completionHandler = nil
    }
    
    @objc private func updateAttributedString() {
        guard let attributedString = attributedString, let beginTime = beginTime else {
            stopAnimation()
            return
        }
        
        let duration = durationFor(animationState)
        let pastDuration = CGFloat(CACurrentMediaTime() - beginTime)
        
        if CACurrentMediaTime() > (beginTime + Double(duration)) {
            stopAnimation()
            return
        }
        
        update(attributedString, with: duration, pastDuration: pastDuration,
               isReverseAnimation: (animationState == .fadingOut))
        
        self.attributedText = attributedString
    }
    
    private func fillCharacterDurationArray(for duration: CGFloat) {
        characterDurationArray = []
        text?.forEach { _ in
            let progress = CGFloat.random(in: 0..<1) 
            let characterDuration = progress * duration * 0.5
            characterDurationArray.append(characterDuration)
        }
    }
    
    private func update(_ attributedString: NSMutableAttributedString, with duration: CGFloat,
                        pastDuration: CGFloat, isReverseAnimation: Bool) {
        var i = 0
        while i < attributedString.length {
            
            var progress = (pastDuration - characterDurationArray[i]) / (duration * 0.5)
            progress = max(0, progress)
            progress = min(progress, 1)
            
            let alpha = isReverseAnimation ? (1 - progress) : progress
            let color = textColor.withAlphaComponent(alpha * textColorAlpha) 
            
            attributedString.addAttributes(
                [NSAttributedString.Key.foregroundColor: color],  range: NSMakeRange(i, 1)
            )
            
            i += 1
        }
    }
    
    private func durationFor(_ animationState: AnimationState) -> CGFloat {
        switch animationState {
        case .fadingIn:
            return fadeInDuration
        case .fadingOut:
            return fadeOutDuration
        default:
            return 0.0
        }
    }
    
    private func makeAttributedString(for text: String, with state: AnimationState) -> NSMutableAttributedString {
        
        let resultString = NSMutableAttributedString(string: text)
        alpha = 1.0
        
        switch state {
        case .fadingIn:
            let color = textColor.withAlphaComponent(0.0)
            resultString.addAttributes(
                [NSAttributedString.Key.foregroundColor: color],  range: NSMakeRange(0, text.count)
            )
        case .fadingOut:
            let color = textColor.withAlphaComponent(1.0)
            resultString.addAttributes(
                [NSAttributedString.Key.foregroundColor: color],  range: NSMakeRange(0, text.count)
            )
        default:
            break
        }
        
        return resultString
    }
}
