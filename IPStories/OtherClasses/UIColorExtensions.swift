//
//  UIColorExtensions.swift
//
//  Created by Ilesh Panchal
//  Copyright © 2018 IP. All rights reserved.

import Foundation
import UIKit

/*
 class ButtonBounce: UIButton {
 
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 
 
 self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
 
 UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
 self.transform = CGAffineTransform.identity
 
 
 }, completion: nil)
 
 
 super.touchesBegan(touches, with: event)
 }
 
 
 
 }*/


public extension UIColor {
    
    /// This method will get the Color from the Hex string
    ///
    /// ````
    /// UIColor.hexString("95A5A6")
    /// ````
    /// - Parameter hex: Hex String of the color
    /// - Returns: UIColor from the hex string
    public static func hexString(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
    }
}

extension UIColor {
    static let primaryGreen = UIColor.hexString("00CBA7") //Green
    static let primaryRed =  #colorLiteral(red: 0.9176470588, green: 0.168627451, blue: 0, alpha: 1) //UIColor.hexString("EA2B00") //Red
    static let primaryPink =  #colorLiteral(red: 1, green: 0.1921568627, blue: 0.3490196078, alpha: 1) //UIColor.hexString("FF3159") //Pink
    static let primaryGrey =  #colorLiteral(red: 0.7568627451, green: 0.7647058824, blue: 0.7803921569, alpha: 1) //UIColor.hexString("C1C3C7") //Grey
    static let linkHighlited_color = #colorLiteral(red: 0, green: 0.2901960784, blue: 0.4274509804, alpha: 1) //UIColor.hexString("004A6D") //Green
    static let backgroundGrey =  #colorLiteral(red: 0.7568627451, green: 0.7647058824, blue: 0.7843137255, alpha: 1) //UIColor.hexString("C1C3C8") //BGGrey
    static let lightBGGrey =  #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1) //UIColor.hexString("F6F6F6") //BGGrey
    static let primaryDarkGrey =  #colorLiteral(red: 0.4549019608, green: 0.462745098, blue: 0.4823529412, alpha: 1) //UIColor.hexString("74767B") //DarkGrey
    static let primaryBlack =  #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1) //UIColor.hexString("1f1f1f") //DarkGrey
}


