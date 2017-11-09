//
//  RoomCell.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/8/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {

    @IBOutlet private weak var profilePictureView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    private let profilePics: [Int : String] = [
        0: "room_icon_001.png",
        1: "room_icon_002.png",
        2: "room_icon_003.png",
        3: "room_icon_004.png"
    ]
    
    var roomName: String? {
        didSet {
            nameLabel.text = roomName
            profilePictureView.image = UIImage(named: profilePics[Int(arc4random() % 4)]!)
        }
    }
    
}
