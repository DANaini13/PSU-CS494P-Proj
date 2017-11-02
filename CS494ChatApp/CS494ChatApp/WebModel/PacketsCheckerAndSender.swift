//
//  File.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/1/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

class PacketsCheckerAndSender {
    
    static private var onChecking = true
    static private var newMessageHandler: ((Message) -> Void)?
    static let swiftSocket = SwiftSocket();
    
    static func start() {
        DispatchQueue.global(qos: .utility).async {
            while(onChecking) {
                guard let result = swiftSocket.readFromServer() else {
                    continue;
                }
                guard result.characters.count > 5 else {
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
                default:
                    print(head)
                }
            }
        }
    }
    
    static func setNewMessageHandler(handler: @escaping (Message) -> Void) {
        self.newMessageHandler = handler
    }
    
    
    static func sendPacket(packet: Packet) {
        let content = packet.packetContent
        let handler = packet.handler
        switch handler {
        case .setHandler(let function):
            HandlerBuffer.addHandlerToSetBuffer(handler: function)
        case .sendHandler(let function):
            HandlerBuffer.addHandlerToSendBuffer(handler: function)
        case .createHandler(let function):
            HandlerBuffer.addHandlerToCreateBuffer(handler: function)
        case .goHandler(let function):
            HandlerBuffer.addHandlerToGoBuffer(handler: function)
        case .logInHandler(let function):
            HandlerBuffer.addHandlerToLogInBuffer(handler: function)
        case .signUpHandler(let function):
            HandlerBuffer.addHandlerToSignUpBuffer(handler: function)
        }
        if !swiftSocket.writeToServer(context: content) {
            print("write to server failed!")
        }
    }
}
