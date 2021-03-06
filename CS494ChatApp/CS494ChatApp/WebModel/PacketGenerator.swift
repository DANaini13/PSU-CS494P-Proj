//
//  PacketGenerator.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/2/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

/**
 The struct that generate various packets for client
 - include:
     1. generateSendPacket
     2. generateSetPacket
     3. generateCreatePacket
     4. generateGoPacket
     5. generateLogInPacket
     6. generateSignUpPacket
 - Version: 1.0
 */
struct PacketsGenerator{
    
    /**
     The function that generate the send packet for user.
     - parameters:
         - message: the message that will be put into the packet
         - room: the room that this message will be
         - handler: the completion handler that will be run when the system receive the return packet.
     - returns: a packet that can be passed into the packets sender.
     - Version: 1.0
     */
    static func generateSendPacket(message: String, to room: Int, handler: @escaping (Bool) -> Void) -> Packet {
        let content = ProtocolInfo.sendHeader + ProtocolInfo.requestSplitter
            + ProtocolInfo.roomHeader + ProtocolInfo.contentSplitter + String(room) + ProtocolInfo.roomSplitter
            + ProtocolInfo.messageHeader + ProtocolInfo.messageSplitter + message
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.sendHandler(handler))
        return packet
    }
    
    /**
     The function that generate the set packet for user.
     - parameters:
         - userName: The user name that the user want to set.
         - handler: the completion handler that will be run when the system receive the return packet.
     - returns: a packet that can be passed into the packets sender.
     - Version: 1.0
     */
    static func generateSetPacket(userName: String, handler: @escaping (Bool) -> Void) -> Packet {
        let content = ProtocolInfo.setHeader + ProtocolInfo.requestSplitter
            + userName
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.setHandler(handler))
        return packet
    }
    
    /**
     The function that generate the set packet for user.
     - parameters:
         - administratorPassword: the password that used to verify the auth to create a new room on the server
         - handler: the completion handler that will be run when the system receive the return packet.
     - returns: a packet that can be passed into the packets sender.
     - Version: 1.0
     */
    static func generateCreatePacket(administratorPassword: String, handler: @escaping (Int) -> Void) -> Packet {
        let content = ProtocolInfo.createHeader + ProtocolInfo.requestSplitter
            + administratorPassword
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.createHandler(handler))
        return packet
    }
    
    /**
     The function that generate the set packet for user.
     - parameters:
         - room: The room that will be transfer to.
         - handler: the completion handler that will be run when the system receive the return packet.
     - returns: a packet that can be passed into the packets sender.
     - Version: 1.0
     */
    static func generateGoPacket(to room: Int, handler: @escaping (Bool) -> Void) -> Packet {
        let content = ProtocolInfo.goHeader + ProtocolInfo.requestSplitter
            + ProtocolInfo.roomHeader + ProtocolInfo.contentSplitter + String(room)
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.goHandler(handler))
        return packet
    }
    
    /**
     The function that generate the set packet for user.
     - parameters:
         - account: The account string that will be used to login.
         - password: The password string that will be used to verify the account
         - handler: the completion handler that will be run when the system receive the return packet.
     - returns: a packet that can be passed into the packets sender.
     - Version: 1.0
     */
    static func generateLogInPacket(account: String, password: String, handler: @escaping (Int) -> Void) -> Packet {
        let content = ProtocolInfo.logInHeader + ProtocolInfo.requestSplitter
            + account + ProtocolInfo.contentSplitter + password
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.logInHandler(handler))
        return packet
    }
    
    /**
     The function that generate the set packet for user.
     - parameters:
         - account: The account string that will be used to sign up.
         - password: The password string that will be used to verify the account
         - handler: the completion handler that will be run when the system receive the return packet.
     - returns: a packet that can be passed into the packets sender.
     - Version: 1.0
     */
    static func generateSignUpPacket(account: String, password: String, handler: @escaping (Bool) -> Void) -> Packet {
        let content = ProtocolInfo.addHeader + ProtocolInfo.requestSplitter
            + account + ProtocolInfo.contentSplitter + password
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.signUpHandler(handler))
        return packet
    }

    /**
     The function that generate the get global list packet for user.
     - parameters:
        - handler: the completion handler that will be run when the system receive the return packet.
        - returns: a packet that can be passed into the packets sender.
     - Version: 1.0
     */
    static func generateGetListGlobal(handler: @escaping ([String]) -> Void) -> Packet {
        let content = ProtocolInfo.getListHeader + ProtocolInfo.requestSplitter + ProtocolInfo.globalKeyWord
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.globalListHandler(handler))
        return packet
    }
    
    /**
     The function that generate the get personal list packet for user.
     - parameters:
     - handler: the completion handler that will be run when the system receive the return packet.
     - returns: a packet that can be passed into the packets sender.
     - Version: 1.0
     */
    static func generateGetListPersonal(handler: @escaping ([String]) -> Void) -> Packet {
        let content = ProtocolInfo.getListHeader + ProtocolInfo.requestSplitter + ProtocolInfo.personalKeyWord
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.personalListHandler(handler))
        return packet
    }
    
    /**
     The function that generate the get user list packet for user.
     - parameters:
     - handler: the completion handler that will be run when the system receive the return packet.
     - returns: a packet that can be passed into the packets sender.
     - Version: 1.0
     */
    static func generateGetUserPacket(roomID: Int, handler: @escaping ([String]) -> Void) -> Packet {
        let content = ProtocolInfo.getUsersHeader + ProtocolInfo.requestSplitter +
            ProtocolInfo.roomHeader + ProtocolInfo.contentSplitter + String(roomID)
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.userListHandler(handler))
        return packet
    }
    
}
