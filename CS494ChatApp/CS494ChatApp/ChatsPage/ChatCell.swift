//
//  ChatCell.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/6/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    @IBOutlet weak var roomPictureView: UIImageView!
    
    private let profilePics: [Int : String] = [
        0: "room_icon_001.png",
        1: "room_icon_002.png",
        2: "room_icon_003.png",
        3: "room_icon_004.png"
    ]
    
    var room: Room? {
        didSet {
            titleLabel.text = room?.name
            messageLabel.text = room?.lastMessage
            roomPictureView.image = UIImage(named: profilePics[Int(arc4random() % 4)]!)
        }
    }
}
