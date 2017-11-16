//
//  MessagesContainer.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/5/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

/**
 The struct that connect to the Web model then send message.
*/
struct MessageSender {
    func sendMessage(content: String, roomNo: Int, completionHandler: @escaping (Bool) -> Void) {
        let packet = PacketsGenerator.generateSendPacket(message: content, to: roomNo, handler: completionHandler)
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
}
