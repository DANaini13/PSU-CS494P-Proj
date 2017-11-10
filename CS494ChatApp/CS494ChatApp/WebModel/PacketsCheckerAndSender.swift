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
    static var lock:NSLock = NSLock()
    
    static var checking:Bool = true {
        willSet {
            lock.lock()
            if newValue {
                start()
            }
            lock.unlock()
        }
    }
    static private var newMessageHandler: ((Message) -> Void)?
    static private var newGlobalRoomListHandler:(([String]) -> Void)?
    static private var newPersonalRoomListHandler:(([String]) -> Void)?
    static private var swiftSocket:SwiftSocket = SwiftSocket();
    
    /**
     This function will keep checking the new packets.
     - Important: this function will create a new thread and keep running until the switch turn off
     The server information was sotred in the HostInfo.h.
     - Version: 1.0
     */
    static private func start() {
        DispatchQueue.global(qos: .utility).async {
            while(checking && swiftSocket.connectionStatus) {
                usleep(200000)
                guard let result = swiftSocket.readFromServer() else {
                    continue
                }
                if result.count <= 5 {
                    print("server is unusual")
                    print(result)
                    continue
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
                        if(components[1] == ProtocolInfo.failedText) {
                            handler(-1)
                        }else {
                            handler(Int(components[1])!)
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
                case ProtocolInfo.getListHeader:
                    let secondLevel = components[1].components(separatedBy: ProtocolInfo.roomSplitter);
                    if secondLevel[0] == ProtocolInfo.globalKeyWord {
                        if let handler = HandlerBuffer.globolRoomFirstHandler {
                            handler(secondLevel[1].components(separatedBy: ProtocolInfo.contentSplitter))
                        }else{
                            self.newGlobalRoomListHandler?(secondLevel[1].components(separatedBy: ProtocolInfo.contentSplitter))
                        }
                    }else if secondLevel[0] == ProtocolInfo.personalKeyWord {
                        if let handler = HandlerBuffer.personalRoomFirstHandler {
                            handler(secondLevel[1].components(separatedBy: ProtocolInfo.contentSplitter))
                        }else{
                            self.newPersonalRoomListHandler?(secondLevel[1].components(separatedBy: ProtocolInfo.contentSplitter))
                        }
                    }else {
                        print("not supposed to be here!")
                    }
                default:
                    print(head)
                }
            }
            checking = false
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
    
    static func setNewGloballistHandler(handler: @escaping (([String]) -> Void)) {
        self.newGlobalRoomListHandler = handler
    }
    
    static func setNewPersonallistHandler(handler: @escaping (([String]) -> Void)) {
        self.newPersonalRoomListHandler = handler
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
                function(-1)
                break
            }
            HandlerBuffer.addHandlerToLogInBuffer(handler: function)
        case .signUpHandler(let function):
            if !serverConnected {
                function(false)
                break
            }
            HandlerBuffer.addHandlerToSignUpBuffer(handler: function)
        case .globalListHandler(let function):
            if !serverConnected {
                function([])
                break
            }
            HandlerBuffer.addHandlerToGlobalRoomListBuffer(handler: function)
        case .personalListHandler(let function):
            if !serverConnected {
                function([])
                break
            }
            HandlerBuffer.addHandlerToPersonalRoomListBuffer(handler: function)
        }
    
    }

}
