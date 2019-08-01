//
//  ShadowUIView.swift
//  Untind
//
//  Created by Honceriu Mihai on 02/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowUIView: UIView {
    
    @IBInspectable var cornerRadius : CGFloat = 0
    @IBInspectable var shadowWidth : Int = 2
    @IBInspectable var shadowHeight : Int = 2
    @IBInspectable var shadowColor : UIColor? = UIColor.black
    @IBInspectable var shadowOpacity : Float = 0.5
    @IBInspectable var shadowRadius : CGFloat = 0.5
    @IBInspectable var fillColor : UIColor = UIColor.black
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.clear
        if shadowLayer == nil {
            if(cornerRadius == 0) {
                cornerRadius = ( self.bounds.size.height / 2 )
            }
            
            shadowLayer = CAShapeLayer  ()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            
            shadowLayer.fillColor = UIColor.clear.cgColor
            shadowLayer.shadowColor = UIColor.black.cgColor
            
            let contactRect = CGRect(x: 5, y: bounds.size.height*0.9, width: bounds.size.width + 5 , height: bounds.size.height*0.1)

            shadowLayer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
            shadowLayer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowRadius = shadowRadius
            
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
}
