//
//  UIView+Ext.swift
//  FortuneApp
//
//  Created by Николай Маторин on 19/08/2019.
//  Copyright © 2019 Николай Маторин. All rights reserved.
//

import UIKit

extension UIView {
    func pinEdges(to other: UIView,withPadding constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: constant).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -constant).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor, constant: constant).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -constant).isActive = true
    }
    
    func center(in other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: other.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: other.centerYAnchor).isActive = true
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func shake(duration: TimeInterval = 0.05,
               shakeCount: Float = 6,
               xValue: CGFloat = 12,
               yValue: CGFloat = 0,
               completion: (() -> Void)? = nil) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = shakeCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - xValue, y: center.y - yValue))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + xValue, y: center.y - yValue))
        layer.add(animation, forKey: "shake")
        completion?()
    }
    
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
