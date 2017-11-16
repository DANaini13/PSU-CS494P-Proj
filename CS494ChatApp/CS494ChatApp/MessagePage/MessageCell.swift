//
//  MessageCell.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/4/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

/**
 The message cell that will be display in the message view controller
 - components:
    - profile picture
    - name label
    - time label
    - message label
 */
class MessageCell: UITableViewCell {

    /**
     override the super function awakeFromNib
     initialize the layer of the message label before
     the view appear
     - Version: 1.0
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.layer.cornerRadius = 10
        messageLabel.clipsToBounds = true
    }
    
    /**
     the profile picture names that will be random access
     - Version: 1.0
     */
    private let profilePics: [Int : String] = [
        0: "bear_pic.png",
        1: "bunny_pic.png",
        2: "monkey_pic.png",
        3: "doggie_pic.png"
    ]
    
    /**
     the profile picture view
     - Version: 1.0
     */
    @IBOutlet weak var profilePic: UIImageView!
    
    /**
     the name label view
     - Version: 1.0
     */
    @IBOutlet weak var nameLabel: UILabel!
    
    /**
     the time label view
     - Version: 1.0
     */
    @IBOutlet weak var timeLabel: UILabel!
    
    /**
     the message label view
     - Version: 1.0
     */
    @IBOutlet weak var messageLabel: UILabel!
    
    /**
     The message abstract that should be set up before the message cell displayed
    */
    var message: Message? {
        didSet {
            profilePic.image = nil
            nameLabel.text = message?.sender
            timeLabel.text = message?.time
            messageLabel.text = message?.message
            profilePic.image = UIImage(named: profilePics[Int(arc4random() % 4)]!)
        }
    }
    
}
