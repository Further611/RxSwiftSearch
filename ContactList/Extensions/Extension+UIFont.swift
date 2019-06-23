//
//  Extension+UIFont.swift
//  ContactList
//
//  Created by Tien Tran on 6/21/19.
//  Copyright © 2019 Tien Tran. All rights reserved.
//

import UIKit

extension UIFont {
    
    /// Title
    ///
    /// - Returns: 21
    static func sizeBoldTitle() -> UIFont {
        return UIFont.boldSystemFont(ofSize: kFontSizeTitle)
    }
    
    // Header Title
    ///
    /// - Returns: 17
    static func sizeBoldHeader() -> UIFont {
        return UIFont.boldSystemFont(ofSize: kFontSizeHeader)
    }
    
    ///  Name Text
    ///
    /// - Returns: 15 Bold
    static func sizeCharacterNameBoldText() -> UIFont {
        return UIFont.boldSystemFont(ofSize: kFontSizeNameText)
    }
    
    ///  Name Text
    ///
    /// - Returns: 15
    static func sizeCharacterNameText() -> UIFont {
        return UIFont.systemFont(ofSize: kFontSizeNameText)
    }
    
    /// Description Text
    ///
    /// - Returns: 14
    static func sizeDescriptionText() -> UIFont {
        return UIFont.systemFont(ofSize: kFontSizeDescriptionText)
    }
}

