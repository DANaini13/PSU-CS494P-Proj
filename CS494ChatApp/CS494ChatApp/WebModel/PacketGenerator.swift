//
//  PacketGenerator.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/2/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

struct PacketsGenerator{
    
    static func generateSendPacket(message: String, to room: Int, handler: @escaping (Bool) -> Void) -> Packet {
        let content = ProtocolInfo.sendHeader + ProtocolInfo.requestSplitter
            + ProtocolInfo.roomHeader + ProtocolInfo.contentSplitter + String(room) + ProtocolInfo.roomSplitter
            + ProtocolInfo.messageHeader + ProtocolInfo.messageSplitter + message
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.sendHandler(handler))
        return packet
    }
    
    static func generateSetPacket(userName: String, handler: @escaping (Bool) -> Void) -> Packet {
        let content = ProtocolInfo.setHeader + ProtocolInfo.requestSplitter
            + userName
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.setHandler(handler))
        return packet
    }
    
    static func generateCreatePacket(administratorPassword: String, handler: @escaping (Int) -> Void) -> Packet {
        let content = ProtocolInfo.createHeader + ProtocolInfo.requestSplitter
            + administratorPassword
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.createHandler(handler))
        return packet
    }
    
    static func generateGoPacket(to room: Int, handler: @escaping (Bool) -> Void) -> Packet {
        let content = ProtocolInfo.goHeader + ProtocolInfo.requestSplitter
            + ProtocolInfo.roomHeader + ProtocolInfo.contentSplitter + String(room)
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.goHandler(handler))
        return packet
    }
    
    static func generateLogInPacket(account: String, password: String, handler: @escaping (Bool) -> Void) -> Packet {
        let content = ProtocolInfo.logInHeader + ProtocolInfo.requestSplitter
            + account + ProtocolInfo.contentSplitter + password
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.logInHandler(handler))
        return packet
    }
    
    static func generateSignUpPacket(account: String, password: String, handler: @escaping (Bool) -> Void) -> Packet {
        let content = ProtocolInfo.addHeader + ProtocolInfo.requestSplitter
            + account + ProtocolInfo.contentSplitter + password
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.signUpHandler(handler))
        return packet
    }
}
