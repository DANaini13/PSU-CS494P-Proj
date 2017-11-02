//
//  ViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 10/25/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PacketsCheckerAndSender.start()
        PacketsCheckerAndSender.setNewPacketHandler() { [weak self]
            (message: Message) in
            DispatchQueue.main.async {
                self!.screen.text = message.sender + ":" + message.message
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchSend(_ sender: UIButton) {
        if let message = text.text {
            let packetGenerator = PacketsGenerator()
            let packet = packetGenerator.generateSendPacket(message: message, to: 0) {
                (result: Bool) in
                if !result {
                    print("send message failed!")
                }
            }
            PacketsCheckerAndSender.sendPacket(packet: packet)
        }
    }
    
    @IBOutlet weak var screen: UILabel!
    @IBOutlet weak var text: UITextField!
}

