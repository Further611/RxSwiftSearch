//
//  Extension+UIView.swift
//  ContactList
//
//  Created by Tien Tran on 6/21/19.
//  Copyright © 2019 Tien Tran. All rights reserved.
//

import UIKit

extension UIView {
    /// Draw radious for view
    ///
    /// - Parameters:
    ///   - radius: Radius
    ///   - thickness: width of border
    ///   - bgColor: background color
    ///   - boderColor: Border color
    func drawsRadiusView(_ radius: CGFloat, _ thickness: CGFloat, _ bgColor: UIColor, _ boderColor: UIColor) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = thickness
        self.layer.masksToBounds = true
        self.layer.borderColor = boderColor.cgColor
        self.layer.backgroundColor = bgColor.cgColor
        self.clipsToBounds = true
    }
}
