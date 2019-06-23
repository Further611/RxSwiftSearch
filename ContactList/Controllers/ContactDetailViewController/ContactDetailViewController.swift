//
//  ContactDetailViewController.swift
//  ContactList
//
//  Created by Tien Tran on 6/20/19.
//  Copyright © 2019 Tien Tran. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactDetailViewController: BaseViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var viewDetail: UIView!
    
    @IBOutlet weak var lbNameValue: UILabel!
    
    @IBOutlet weak var lbSalaryTitle: UILabel!
    @IBOutlet weak var lbSalaryValue: UILabel!
    
    @IBOutlet weak var lbAgeTitle: UILabel!
    @IBOutlet weak var lbAgeValue: UILabel!
    
    private var detailContact: Contact?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Notify.shared.removeListener(self)
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        setupChildViews()
    }
    
    private func setupChildViews() {
        viewDetail.drawsRadiusView(kRadiousSize, kBorderSize, kBlueColor.hexColor(), kBrightenBlueColor.hexColor())
        setupImageView()
        setupLabels()
    }
    
    private func setupImageView() {
        imgAvatar.layer.masksToBounds = true
        imgAvatar.layer.borderWidth = 2
        imgAvatar.layer.borderColor = kYellowColor.hexColor().cgColor
        imgAvatar.layer.cornerRadius = imgAvatar.bounds.width / 2
    }
    
    private func setupLabels() {
        
        lbNameValue.font = UIFont.sizeBoldTitle()
        lbNameValue.textColor = kRedColor.hexColor()
        
        lbSalaryTitle.font = UIFont.sizeCharacterNameBoldText()
        lbSalaryTitle.textColor = kDarkGrayColor.hexColor()
        
        lbSalaryValue.font = UIFont.sizeCharacterNameText()
        lbSalaryValue.textColor = kWhiteColor.hexColor()
        
        lbAgeTitle.font = UIFont.sizeCharacterNameBoldText()
        lbAgeTitle.textColor = kDarkGrayColor.hexColor()
        
        lbAgeValue.font = UIFont.sizeCharacterNameText()
        lbAgeValue.textColor = kWhiteColor.hexColor()
        
        lbSalaryTitle.text = String.localizeFrom(key: "ContactDetailViewController_SalaryTitle")
        lbAgeTitle.text = String.localizeFrom(key: "ContactDetailViewController_lbAgeTitle")
    }
    
    private func setupData () {
        // Notification History
        Notify.shared.listen(self, selector: #selector(contactDetailUpdated(_:)), name: Notify.Name.Contact.detail, object: nil)
        
        // API requests
        Apify.shared.getContactDetail(detailContact!.id)
        
        loadDataWith(detailContact!)
    }
    
    // MARK: - Private Method
    private func loadDataWith(_ currentContact: Contact) {
        loadImageView(currentContact.imageUrl)
        
        lbNameValue.text = currentContact.name
        lbSalaryValue.text = currentContact.salary
        lbAgeValue.text = currentContact.age
    }
    
    private func loadImageView(_ currentUrlString: String) {
        if currentUrlString != kEmptyString {
            self.imgAvatar.sd_setImage(with: URL(string: currentUrlString), completed: nil)
        } else {
            self.imgAvatar.image = UIImage(named: "icon_avatar")
        }
    }
    
    // MARK: - Public Method
    public func setContact(_ currentContact: Contact) {
        detailContact = currentContact
    }
    
    // MARK: - Notification Handlers
    @objc fileprivate func contactDetailUpdated(_ notification: Notification) {
        if let success = notification.userInfo?["success"] as? Bool {
            if success {
                if let json = notification.userInfo!["json"] as? JSON {
                    let aContact = Contact(json)
                    detailContact = aContact
                    loadDataWith(detailContact!)
                }
            }
        }
    }
}
