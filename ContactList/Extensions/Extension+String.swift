//
//  Extension+String.swift
//  ContactList
//
//  Created by Tien Tran on 6/21/19.
//  Copyright © 2019 Tien Tran. All rights reserved.
//

import UIKit

extension String {
    
    /// Get string from localize
    ///
    /// - Parameter key: Key of string
    /// - Returns: String
    static func localizeFrom(key: String) -> String {
        return NSLocalizedString(key, comment: kEmptyString)
    }
    
    /// Convert string with format #RRBBGG in to UIColor with dynamic Alpha
    ///
    /// - Parameter alphaNumber: CGFloat of Alpha
    /// - Returns: UIColor for the string
    func hexColorWithAlpha(_ alphaNumber: CGFloat) -> UIColor {
        let hexint = Int(intFromHexString(self))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: alphaNumber)
        return color
    }
    
    /// Convert string with format #RRBBGG in to UIColor
    ///
    /// - Returns: UIColor for the string
    func hexColor() -> UIColor {
        let hexint = Int(intFromHexString(self))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return color
    }
    
    /// Get int from hex string
    ///
    /// - Parameter hexStr: hex string
    /// - Returns: int
    fileprivate func intFromHexString(_ hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner: Scanner = Scanner(string: hexStr)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

