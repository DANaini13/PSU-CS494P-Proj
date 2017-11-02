//
//  Packet.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/1/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

/**
 Packet is a abstract type that contains a completion handler and
 a string to store the packet content.
 */
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

