//
//  Packet.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/1/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

struct Packet{
    enum PacketReturnHandler{
        case setHandler((Bool) -> Void)
        case goHandler((Bool) -> Void)
        case createHandler((Int) -> Void)
        case sendHandler((Bool) -> Void)
        case logInHandler((Bool) -> Void)
        case signUpHandler((Bool) -> Void)
    }
    
    let handler:PacketReturnHandler
    
    let packetContent:String
    
    init(content: String, handler: PacketReturnHandler) {
        self.handler = handler
        packetContent = content
    }
}

struct PacketsGenerator{
    
    func generateSendPacket(message: String, to room: Int, handler: @escaping (Bool) -> Void) -> Packet {
        let content = ProtocolInfo.sendHeader + ProtocolInfo.requestSplitter
            + ProtocolInfo.roomHeader + ProtocolInfo.contentSplitter + String(room) + ProtocolInfo.roomSplitter
            + ProtocolInfo.messageHeader + ProtocolInfo.messageSplitter + message
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.sendHandler(handler))
        return packet
    }
    
    func generateSetPacket(userName: String, handler: @escaping (Bool) -> Void) -> Packet {
        let content = ProtocolInfo.setHeader + ProtocolInfo.requestSplitter
            + userName
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.setHandler(handler))
        return packet
    }
    
    func generateCreatePacket(administratorPassword: String, handler: @escaping (Int) -> Void) -> Packet {
        let content = ProtocolInfo.createHeader + ProtocolInfo.requestSplitter
            + administratorPassword
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.createHandler(handler))
        return packet
    }
    
    func generateGoPacket(to room: Int, handler: @escaping (Bool) -> Void) -> Packet {
        let content = ProtocolInfo.goHeader + ProtocolInfo.requestSplitter
            + ProtocolInfo.roomHeader + ProtocolInfo.contentSplitter + String(room)
        let packet = Packet(content: content, handler: Packet.PacketReturnHandler.goHandler(handler))
        return packet
    }
}
