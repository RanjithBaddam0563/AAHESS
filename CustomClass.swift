//
//  CustomClass.swift
//  Juvoxa
//
//  Created by sudhakar dalli on 10/01/19.
//  Copyright © 2019 Thukaram. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable class CustomView: UIView{
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{ self.layer.borderWidth = borderWidth }
    }
    
    @IBInspectable var borderColor1: UIColor = UIColor.clear {
        didSet { self.layer.borderColor = borderColor1.cgColor }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet{ self.layer.cornerRadius = cornerRadius }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}

//@IBDesignable class CustomButton: UIButton {
//    @IBInspectable var cornerRadius: CGFloat = 0.0 {
//        didSet{ self.layer.cornerRadius = cornerRadius }
//    }
//    
//    @IBInspectable var borderWidth: CGFloat = 0.0 {
//        didSet{ self.layer.borderWidth = borderWidth }
//    }
//    
//    @IBInspectable var borderColor: UIColor = UIColor.clear {
//        didSet { self.layer.borderColor = borderColor.cgColor }
//    }
//}
//
//@IBDesignable class CustomImageView: UIImageView {
//    @IBInspectable var cornerRadius: CGFloat = 0.0 {
//        didSet{
//            self.layer.cornerRadius = cornerRadius
//        }
//    }
//}
//
//@IBDesignable class CustomLabel: UILabel {
//    @IBInspectable var borderWidth: CGFloat = 0.0 {
//        didSet{ self.layer.borderWidth = borderWidth }
//    }
//    
//    @IBInspectable var borderColor: UIColor = UIColor.clear {
//        didSet { self.layer.borderColor = borderColor.cgColor }
//    }
//    
//    @IBInspectable var cornerRadius: CGFloat = 0.0 {
//        didSet{ self.layer.cornerRadius = cornerRadius }
//    }
//}
//
//@IBDesignable class CustomTextBox: UITextField {
//    @IBInspectable var borderWidth: CGFloat = 0.0 {
//        didSet{ self.layer.borderWidth = borderWidth }
//    }
//    
//    @IBInspectable var borderColor: UIColor = UIColor.clear {
//        didSet { self.layer.borderColor = borderColor.cgColor }
//    }
//    
//    @IBInspectable var cornerRadius: CGFloat = 0.0 {
//        didSet{ self.layer.cornerRadius = cornerRadius }
//    }
//}
