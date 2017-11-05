//
//  MessageCell.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/4/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class MessageCellLeft: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageLabel.layer.cornerRadius = 10
        messageLabel.clipsToBounds = true
    }
    
    private let profilePics: [Int : String] = [
        0: "bear_pic.png",
        1: "bunny_pic.png",
        2: "monkey_pic.png",
        3: "doggie_pic.png"
    ]
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var message: Message? {
        didSet {
            profilePic.image = nil
            nameLable.text = message?.sender
            timeLabel.text = message?.time
            messageLabel.text = message?.message
            profilePic.image = UIImage(named: profilePics[Int(arc4random() % 4)]!)
        }
    }
    
}
