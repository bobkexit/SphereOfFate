//
//  FNBlingBlingLabel.swift
//  FNBlingBlingLabel
//
//  Created by Fnoz on 16/5/30.
//  Copyright © 2016年 Fnoz. All rights reserved.
//
import UIKit

public class FNBlingBlingLabel: UILabel{
    public var appearDuration: CGFloat = 1.5
    public var disappearDuration: CGFloat = 1.5
    public var attributedString:NSMutableAttributedString?
    public var needAnimation = false
    
    private var displaylink: CADisplayLink?
    private var isAppearing: Bool = false
    private var isDisappearing: Bool = false
    private var isDisappearing4ChangeText: Bool = false
    private var beginTime: CFTimeInterval?
    private var endTime: CFTimeInterval?
    private var durationArray: [CGFloat] = []
    private var lastString: String?
    private var textColorAlpha: CGFloat = 1
    
    
     enum AnimationType {
        case none
        case appearing
        case disappearing
    }
    
    var animation: AnimationType = .none
    
    override public var text: String? {
        get {
            if needAnimation {
                return self.attributedString?.string
            }
            else {
                return super.text
            }
        }
        
        set {
            if needAnimation {
                self.convertToAttributedString(text: newValue ?? "")
            }
            else {
                super.text = newValue
            }
        }
    }
    
    override public var textColor: UIColor! {
        didSet
        {
            if self.textColor.cgColor.alpha > 0 {
                print("fffffffff: %f", self.textColor.cgColor.alpha)
                textColorAlpha = self.textColor.cgColor.alpha
            }
        }
    }
    
    public func convertToAttributedString(text: String) {
        lastString = text
        if (self.attributedText?.length ?? 0) > 0 {
            disappear()
            isDisappearing4ChangeText = true
        }
        else {
            appear()
        }
    }
    
    public func appear() {
        attributedString = NSMutableAttributedString.init(string: lastString! as String)
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 4
        attributedString?.addAttributes(
            [NSAttributedString.Key.paragraphStyle:paragraphStyle],
            range: NSMakeRange(0, lastString?.count ?? 0)
        )
        
        isAppearing = true
        beginTime = CACurrentMediaTime()
        endTime = CACurrentMediaTime() + Double(appearDuration)
        displaylink?.isPaused = false
        
        updateDurationArray(duration: appearDuration)
    }
    
    public func disappear() {
        isDisappearing = true
        beginTime = CACurrentMediaTime()
        endTime = CACurrentMediaTime() + Double(disappearDuration)
        displaylink?.isPaused = false
        updateDurationArray(duration: disappearDuration)
    }
    
    private func updateDurationArray(duration: CGFloat) {
        durationArray.removeAll()
        
        attributedString?.string.forEach { _ in
            let progress = CGFloat(arc4random_uniform(100))/100.0
            let characterDuration = progress * duration * 0.5
            durationArray.append(characterDuration)
        }
        
        print(durationArray)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTimer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initTimer() {
        displaylink = CADisplayLink.init(target: self, selector: #selector(updateAttributedString))
        displaylink?.isPaused = true
        displaylink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    @objc func updateAttributedString() {
        
        guard let beginTime = beginTime else { return }
        
        let pastDuration = CGFloat(CACurrentMediaTime() - beginTime)
        
        if pastDuration > appearDuration {
            displaylink?.isPaused = true
            isAppearing = false
        } else if pastDuration > disappearDuration  {
            displaylink?.isPaused = true
            isDisappearing = false
            
            if isDisappearing4ChangeText {
                isDisappearing4ChangeText = false
                appear()
            }
            return
        }
        
        guard let attributedString = attributedString else { return }
        
        for (i, _) in attributedString.string.enumerated() {
            
            let duration = isAppearing ? appearDuration : disappearDuration
            
            var progress = (pastDuration - durationArray[i]) / (duration * 0.5)
            
            if progress > 1 {
                progress = 1
            } else if progress<0 {
                progress = 0
            }
            
            let color = isAppearing ?
                textColor.withAlphaComponent(progress * textColorAlpha)
                : textColor.withAlphaComponent((1 - progress) * textColorAlpha)
            
            attributedString.addAttributes(
                [NSAttributedString.Key.foregroundColor: color],
                range: NSMakeRange(i, 1)
            )
        }
    
        attributedText = attributedString
    }
    
//    @objc func updateAttributedString() {
//        
//        guard let beginTime = beginTime, let attributedString = attributedString else {
//            return
//        }
//        
//        var duration: CGFloat = 0.0
//        
//        switch animation {
//        case .appearing:
//            duration = appearDuration
//        case .disappearing:
//            duration = disappearDuration
//        default:
//            return
//        }
//        
//        let isAppearing = animation == .appearing
//        
//        update(attributedString, beginTime: beginTime, duration: duration, isAppearing: isAppearing)
//        
//        attributedText = attributedString
//    }
//    
    
    func update(_ attributedString: NSMutableAttributedString,
                beginTime: CFTimeInterval,
                duration: CGFloat,
                isAppearing: Bool) {
        
        let pastDuration = CGFloat(CACurrentMediaTime() - beginTime)
        
        if pastDuration > duration {
            displaylink?.isPaused = true
            return
        }
        
        update(attributedString, duration: duration, pastDuration: pastDuration, isAppearing: isAppearing)
    }
    
    func update(_ attributedString: NSMutableAttributedString,
                duration: CGFloat,
                pastDuration: CGFloat,
                isAppearing: Bool) {
        var i = 0
        while i < attributedString.length {
            
            var progress = (pastDuration - durationArray[i]) / (duration * 0.5)
            progress = max(0, progress)
            progress = min(progress, 1)
            
            let alpha = isAppearing ? progress : (1 - progress)
            let color = textColor.withAlphaComponent(alpha * textColorAlpha)
            
            attributedString.addAttributes(
                [NSAttributedString.Key.foregroundColor: color],  range: NSMakeRange(i, 1)
            )
            
            i += 1
        }
    }
}
