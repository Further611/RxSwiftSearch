//
//  ContactListTableViewCell.swift
//  ContactList
//
//  Created by Tien Tran on 6/21/19.
//  Copyright © 2019 Tien Tran. All rights reserved.
//

import UIKit
import SDWebImage

class ContactListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    /// Setup Cell layout
    private func setupCell () {
        setupImageView()
        
        lbName.font = UIFont.sizeCharacterNameBoldText()
        lbName.textColor = kGrayColor.hexColor()
    }
    
    private func setupImageView() {
        imgThumbnail.layer.masksToBounds = true
        imgThumbnail.layer.borderWidth = 2
        imgThumbnail.layer.borderColor = kYellowColor.hexColor().cgColor
        imgThumbnail.layer.cornerRadius = imgThumbnail.bounds.width / 2
    }
    
    /// Config Cell layout with Contact Model
    ///
    /// - Parameter currentManga: Must be Contact type
    public func configCellWith(_ currentContact: Contact) {
        
        // Setup for contact image
        if currentContact.imageUrl != kEmptyString {
            self.imgThumbnail.sd_setImage(with: URL(string: currentContact.imageUrl), completed: nil)
        } else {
            self.imgThumbnail.image = UIImage(named: "icon_avatar")
        }
        
        // Setup Name and Author Name
        lbName.text = currentContact.name
    }
    
}
