//
//  PersonCell.swift
//  PeopleMon
//
//  Created by Christopher Stanley on 11/10/16.
//  Copyright © 2016 Christopher Stanley. All rights reserved.
//

import UIKit
import AFDateHelper

class PersonCell: UITableViewCell {
//    @IBOutlet weak var avatar: CircleImage!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    var person: User!
    
    func setupCell(person: User) {
        self.person = person
        
        nameLabel.text = person.userName
      
        
        if let image = Utils.imageFromString(imageString: person.avatarBase64) {
            avatar.image = image
        } else {
            avatar.image = UIImage(named: "default-user-icon-profile")
        }
    }
}

