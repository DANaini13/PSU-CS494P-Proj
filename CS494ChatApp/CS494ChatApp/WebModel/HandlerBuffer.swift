//
//  HandlerBuffer.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/2/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

struct HandlerBuffer {
    
    static private var setBuffer:   [(Bool) -> Void]     = []
    static private var sendBuffer:  [(Bool) -> Void]     = []
    static private var goBuffer:    [(Bool) -> Void]     = []
    static private var createBuffer:[(Int)  -> Void]     = []
    static private var logInBuffer: [(Bool) -> Void]     = []
    static private var signUpBuffer:[(Bool) -> Void]     = []
    static private let lock                              = NSLock()
    
    static var setFirstHandler: ((Bool) -> Void)? {
        guard setBuffer.count != 0 else {
            return nil
        }
        lock.lock()
        let result = setBuffer.removeFirst()
        lock.unlock()
        return result
    }
    
    static var sendFirstHandler: ((Bool) -> Void)? {
        guard sendBuffer.count != 0 else {
            return nil
        }
        lock.lock()
        let result = sendBuffer.removeFirst()
        lock.unlock()
        return result
    }
    
    static var goFirstHandler: ((Bool) -> Void)? {
        guard goBuffer.count != 0 else {
            return nil
        }
        lock.lock()
        let result = goBuffer.removeFirst()
        lock.unlock()
        return result
    }
    
    static var createFirstHandler: ((Int) -> Void)? {
        guard createBuffer.count != 0 else {
            return nil
        }
        lock.lock()
        let result = createBuffer.removeFirst()
        lock.unlock()
        return result
    }
    
    static func addHandlerToSetBuffer(handler: @escaping (Bool) -> Void) {
        lock.lock()
        setBuffer.append(handler)
        lock.unlock()
    }
    
    static func addHandlerToSendBuffer(handler: @escaping (Bool) -> Void) {
        lock.lock()
        sendBuffer.append(handler)
        lock.unlock()
    }
    
    static func addHandlerToGoBuffer(handler: @escaping (Bool) -> Void) {
        lock.lock()
        goBuffer.append(handler)
        lock.unlock()
    }
    
    static func addHandlerToCreateBuffer(handler: @escaping (Int) -> Void) {
        lock.lock()
        createBuffer.append(handler)
        lock.unlock()
    }
    
    static func addHandlerToLogInBuffer(handler: @escaping (Bool) -> Void) {
        lock.lock()
        logInBuffer.append(handler)
        lock.unlock()
    }
    
    static func addHandlerToSignUpBuffer(handler: @escaping (Bool) -> Void) {
        lock.lock()
        signUpBuffer.append(handler)
        lock.unlock()
    }
}
