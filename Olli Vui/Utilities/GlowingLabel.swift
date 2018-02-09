//
//  GlowingLabel.swift
//  Olli Vui
//
//  Created by Man Huynh on 1/11/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@IBDesignable
class HMGlowingLabel: UILabel {
    
    @IBInspectable
    var blurColor :UIColor = UIColor(red: 104.0,green: 248.0,blue: 0,alpha: 0.7){
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    var glowSize :CGFloat = 25.0
    
    
    override func drawText(in rect: CGRect) {
        
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setShadow(offset: CGSize(width: 0, height: 0)
                , blur: self.glowSize
                , color: self.blurColor.cgColor)
            
            ctx.setTextDrawingMode(.fillStroke)
        }
        
        super.drawText(in: rect)
    }
    
}
