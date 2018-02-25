//
//  AnimatedLabel.swift
//  FortuneApp
//
//  Created by Николай Маторин on 24.02.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class AnimatedLabel: UILabel {
    
    var animatingAppear: Bool?
    var progress: CGFloat = 0

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
      
        
        guard let animatingAppear = self.animatingAppear else {
            return
        }
        
        animatingAppear ? appearStateDrawing(rect) : disappearStateDrawing(rect)
       
        //context.saveGState()
     
    }
    
    func appearStateDrawing(_ rect: CGRect) {
        let alpha = easeOut(startValue: 0, endValue: 1, time: self.progress)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let color = self.textColor.withAlphaComponent(alpha)
        self.textColor = color
        drawText(in: rect)
    
        context.saveGState()
        
    }
    
    func disappearStateDrawing(_ rect: CGRect) {
        
    }
    
    func easeOut(startValue: CGFloat,endValue: CGFloat, time: CGFloat) -> CGFloat {
        return startValue + (endValue - startValue) * quadraticEaseOut(time)
    }
    
    func quadraticEaseOut(_ p: CGFloat) -> CGFloat {
        return -(p * (p-2))
    }
    
/*
     CGFloat ZCQuadraticEaseOut(CGFloat p)
     {
     return -(p * (p - 2));
     }
 */


    
}
