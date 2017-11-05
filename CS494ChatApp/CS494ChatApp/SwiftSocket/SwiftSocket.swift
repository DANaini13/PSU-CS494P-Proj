//
//  File.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 10/25/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

/**
 This class is just interfaces that translate form the CSocket.
 include: connect, disconnect, read and write.
 - public functions:
     1. init()
     2. func writeToServer(context: String) -> Bool
     3. func readFromServer() -> String?
 - read only vars:
     1. var connectionStatus:Bool
 */
class SwiftSocket {
    
    private var connecting = false
    
    /**
     This initializor will try to connect to the server.
     The server information was save in the HostInfo.h
     - Version:
     1.0
     */
    init() {
        let result = socketInit()
        if result >= 0 {
            connecting = true
        }
    }
    
    /**
     This function will call the socketWrite to send string to server.
     The server information was save in the HostInfo.h
     - parameter context: the string that will be sent.
     - returns: it return a Bool to show if the write operation is successful or not.
     - Version:
     1.0
     */
    func writeToServer(context: String) -> Bool {
        let result = socketWrite(UnsafeMutablePointer<Int8>(mutating: (context as NSString).utf8String))
        return result >= 0
    }
    
    /**
     This function will call the socketWrite to read string form the server.
     The server information was save in the HostInfo.h
     - returns: it returns the string that received, return nil if no new packets.
     - Version:
     1.0
     */
    func readFromServer() -> String? {
        let result = socketRead();
        if let bufResult = result {
            let buff = String.init(cString: bufResult)
            return buff
        }else {
            return nil
        }
    }

    deinit {
        closeConnection()
        connecting = false
    }
    
    /**
     The readonly variable that return the connection status of the socket.
     */
    var connectionStatus:Bool {
        return connecting
    }
    
}
