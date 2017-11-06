//
//  MessagesContainer.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/5/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

struct MessagesContainer {
    private var messageList:[Message] = []
    
    var messages: [Message] {
        return messageList
    }
    
    var count: Int {
        return messageList.count
    }
    
    init() {
        var i = 0
        while i<30 {
            var messageContent = ""
            var j = 0
            while j < i {
                messageContent += "Hello World "
                j += 1
            }
            messageContent += "\(i)"
            messageList.append(Message(messageContent: messageContent, roomNo: 0, timeString: "currentTime", senderName: "Shan", senderId: 0))
            i += 1
        }
    }
    
    mutating func addMessage(message: Message) {
        messageList.append(message)
    }
    
}

struct MessageSender {
    func sendMessage(content: String, roomNo: Int, completionHandler: @escaping (Bool) -> Void) {
        let packet = PacketsGenerator.generateSendPacket(message: content, to: roomNo, handler: completionHandler)
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
}
