//
//  Message.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/2/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

/**
 The abstract Message data type that
 - contains:
     - message context
     - room number
     - time that message generated (server standard)
     - the sender name of this message
 */
struct Message{
    private var messageContent: String
    var message: String {
        return messageContent
    }
    
    private var roomNo: Int
    var roomNumber: Int {
        return roomNo
    }
    
    private var timeString: String
    var time: String {
        return timeString
    }
    
    private var senderName: String
    var sender: String {
        return senderName
    }
    
    private var senderId: Int
    var dynamicId: Int {
        return senderId
    }
    
    /**
     init the message by seperare components.
     */
    init(messageContent: String, roomNo: Int, timeString: String, senderName: String, senderId: Int) {
        self.messageContent = messageContent
        self.roomNo         = roomNo
        self.timeString     = timeString
        self.senderName     = senderName
        self.senderId       = senderId
    }
    
    /**
     init the message from the packet that received from the server.
     */
    init(serverPacket: String) {
        let firstLevelParts = serverPacket.components(separatedBy: ProtocolInfo.roomSplitter)
        assert(firstLevelParts.count == 2)
        let roomHeaderParts = firstLevelParts[0].components(separatedBy: ProtocolInfo.contentSplitter)
        assert(roomHeaderParts.count == 2 && roomHeaderParts[0] == ProtocolInfo.roomHeader)
        let roomNumber = Int(roomHeaderParts[1])
        let secondLevelParts = firstLevelParts[1].components(separatedBy: ProtocolInfo.messageSplitter)
        assert(secondLevelParts.count == 2 && secondLevelParts[0] == ProtocolInfo.messageHeader)
        let messageContentParts = secondLevelParts[1].components(separatedBy: ProtocolInfo.contentSplitter)
        assert(messageContentParts.count == 4)
        self.roomNo         = roomNumber!
        self.senderName     = messageContentParts[1]
        self.messageContent = messageContentParts[3]
        self.timeString     = messageContentParts[2]
        self.senderId       = Int(messageContentParts[0])!
    }
}
