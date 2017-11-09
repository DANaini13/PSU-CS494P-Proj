//
//  JoinRoomViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/9/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class JoinRoomViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    var roomNo:Int?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        image.image = picture
    }
    
    @IBAction func touchJoinInButton(_ sender: UIButton) {
        guard roomNo != nil else {
            return
        }
        let packet = PacketsGenerator.generateGoPacket(to: roomNo!) {
            result in
            print(result)
        }
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
    
    var picture: UIImage?
    
}
