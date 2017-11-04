//
//  File.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/1/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

/**
 This class will automaticly check the new packet arrived.
 it will catagratory the packets then pick the right handler form
 the buffer pool
 It can also send message to the sever.
 The server information was sotred in the HostInfo.h.
 
 - public vars:
     1. checking
 - public functions:
     1. func start()
     2. func setNewMessageHandler(handler: @escaping (Message) -> Void)
     3. func sendPacket(packet: Packet)
 - Important: set the newMessageHandler before you call the start() function.
 */
class PacketsCheckerAndSender {
    /**
     This variable is the turn on/off switch of the checker
     */
    static var checking = true{
        didSet {
            if checking {
                start()
            }
        }
    }
    static private var newMessageHandler: ((Message) -> Void)?
    static let swiftSocket = SwiftSocket();
    
    /**
     This function will keep checking the new packets.
     - Important: this function will create a new thread and keep running until the switch turn off
     The server information was sotred in the HostInfo.h.
     - Version: 1.0
     */
    static func start() {
        DispatchQueue.global(qos: .utility).async {
            while(checking) {
                guard let result = swiftSocket.readFromServer() else {
                    continue;
                }
                guard result.count > 5 else {
                    print("server is unusual")
                    break;
                }
                let components = result.components(separatedBy: ProtocolInfo.requestSplitter)
                let head = components[0]
                guard components.count == 2 else {
                    continue;
                }
                switch head {
                case ProtocolInfo.setHeader :
                    if let handler = HandlerBuffer.setFirstHandler {
                        if(components[1] == ProtocolInfo.successText) {
                            handler(true)
                        }else {
                            handler(false)
                        }
                    }
                case ProtocolInfo.sendHeader :
                    if(components[1] == ProtocolInfo.successText) {
                        if let handler = HandlerBuffer.sendFirstHandler {
                            handler(true)
                        }
                        break;
                    }else if(components[1] == ProtocolInfo.failedText) {
                        if let handler = HandlerBuffer.sendFirstHandler {
                            handler(false)
                        }
                        break;
                    }
                    // New Message arrive!
                    let message = Message(serverPacket: components[1])
                    newMessageHandler?(message)
                    
                case ProtocolInfo.createHeader :
                    if let handler = HandlerBuffer.createFirstHandler {
                        let roomHeaderParts = components[1].components(separatedBy: ProtocolInfo.contentSplitter)
                        assert(roomHeaderParts[0] == ProtocolInfo.roomHeader)
                        assert(roomHeaderParts.count == 2)
                        handler(Int(roomHeaderParts[1])!)
                    }
                case ProtocolInfo.goHeader :
                    if let handler = HandlerBuffer.goFirstHandler {
                        if(components[1] == ProtocolInfo.successText) {
                            handler(true)
                        }else {
                            handler(false)
                        }
                    }
                case ProtocolInfo.logInHeader :
                    if let handler = HandlerBuffer.logInFirstHandler {
                        if(components[1] == ProtocolInfo.successText) {
                            handler(true)
                        }else {
                            handler(false)
                        }
                    }
                case ProtocolInfo.addHeader:
                    if let handler = HandlerBuffer.signUpFirstHandler {
                        if(components[1] == ProtocolInfo.successText) {
                            handler(true)
                        }else {
                            handler(false)
                        }
                    }
                default:
                    print(head)
                }
            }
        }
    }
    
    /**
     This function will put the handler into the struct then run it when recieve
     the new message.
     The server information was sotred in the HostInfo.h.
     - parameter handler: the handler that will be run wen new message arrived.
     - Version: 1.0
     */
    static func setNewMessageHandler(handler: @escaping (Message) -> Void) {
        self.newMessageHandler = handler
    }
    
    /**
     This function will send packet to the server. The server information was sotred
     in the HostInfo.h.
     - parameter packet: the packet that will be sent, it should contains the handler that will be run later.
     - Version: 1.0
     */
    static func sendPacket(packet: Packet) {
        let content = packet.packetContent
        let handler = packet.handler
        var serverConnected = true
        if !swiftSocket.writeToServer(context: content) {
            serverConnected = false
        }
        switch handler {
        case .setHandler(let function):
            if !serverConnected {
                function(false)
                break
            }
            HandlerBuffer.addHandlerToSetBuffer(handler: function)
        case .sendHandler(let function):
            if !serverConnected {
                function(false)
                break
            }
            HandlerBuffer.addHandlerToSendBuffer(handler: function)
        case .createHandler(let function):
            if !serverConnected {
                function(-1)
                break
            }
            HandlerBuffer.addHandlerToCreateBuffer(handler: function)
        case .goHandler(let function):
            if !serverConnected {
                function(false)
                break
            }
            HandlerBuffer.addHandlerToGoBuffer(handler: function)
        case .logInHandler(let function):
            if !serverConnected {
                function(false)
                break
            }
            HandlerBuffer.addHandlerToLogInBuffer(handler: function)
        case .signUpHandler(let function):
            if !serverConnected {
                function(false)
                break
            }
            HandlerBuffer.addHandlerToSignUpBuffer(handler: function)
        }
    }
}
