//
//  HandlerBuffer.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/2/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation


/**
 This is a buffer pool that store the various kind of handlers,
 The handlers will be called after the PacketsChecker receive new
 return packets.
 */
struct HandlerBuffer {
    
    static private var setBuffer:   [(Bool) -> Void]     = []
    static private var sendBuffer:  [(Bool) -> Void]     = []
    static private var goBuffer:    [(Bool) -> Void]     = []
    static private var createBuffer:[(Int)  -> Void]     = []
    static private var logInBuffer: [(Int) -> Void]      = []
    static private var signUpBuffer:[(Bool) -> Void]     = []
    static private let lock                              = NSLock()
    
    /**
     the var that will pop a SET completion handler form the buffer queue.
     - Version: 1.0
     */
    static var setFirstHandler: ((Bool) -> Void)? {
        guard setBuffer.count != 0 else {
            return nil
        }
        lock.lock()
        let result = setBuffer.removeFirst()
        lock.unlock()
        return result
    }
    
    /**
     the var that will pop a SEND completion handler form the buffer queue.
     - Version: 1.0
     */
    static var sendFirstHandler: ((Bool) -> Void)? {
        guard sendBuffer.count != 0 else {
            return nil
        }
        lock.lock()
        let result = sendBuffer.removeFirst()
        lock.unlock()
        return result
    }
    
    /**
     the var that will pop a GO completion handler form the buffer queue.
     - Version: 1.0
     */
    static var goFirstHandler: ((Bool) -> Void)? {
        guard goBuffer.count != 0 else {
            return nil
        }
        lock.lock()
        let result = goBuffer.removeFirst()
        lock.unlock()
        return result
    }
    
    /**
     the var that will pop a CREATE completion handler form the buffer queue.
     - Version: 1.0
     */
    static var createFirstHandler: ((Int) -> Void)? {
        guard createBuffer.count != 0 else {
            return nil
        }
        lock.lock()
        let result = createBuffer.removeFirst()
        lock.unlock()
        return result
    }
    
    /**
     the var that will pop a LOGIN completion handler form the buffer queue.
     - Version: 1.0
     */
    static var logInFirstHandler: ((Int) -> Void)? {
        guard logInBuffer.count != 0 else {
            return nil
        }
        lock.lock()
        let result = logInBuffer.removeFirst()
        lock.unlock()
        return result;
    }
    
    /**
     the var that will pop a ADD completion handler form the buffer queue.
     - Version: 1.0
     */
    static var signUpFirstHandler: ((Bool) -> Void)? {
        guard signUpBuffer.count != 0 else {
            return nil
        }
        lock.lock()
        let result = signUpBuffer.removeFirst()
        lock.unlock()
        return result
    }
    
    /**
     the function that will add a handler to the set handler queue
     - parameter handler: the completion handler that will be called from the PacketsChecker.
     - Version: 1.0
     */
    static func addHandlerToSetBuffer(handler: @escaping (Bool) -> Void) {
        lock.lock()
        setBuffer.append(handler)
        lock.unlock()
    }
    
    /**
     the function that will add a handler to the send handler queue
     - parameter handler: the completion handler that will be called from the PacketsChecker.
     - Version: 1.0
     */
    static func addHandlerToSendBuffer(handler: @escaping (Bool) -> Void) {
        lock.lock()
        sendBuffer.append(handler)
        lock.unlock()
    }
    
    /**
     the function that will add a handler to the go handler queue
     - parameter handler: the completion handler that will be called from the PacketsChecker.
     - Version: 1.0
     */
    static func addHandlerToGoBuffer(handler: @escaping (Bool) -> Void) {
        lock.lock()
        goBuffer.append(handler)
        lock.unlock()
    }
    
    /**
     the function that will add a handler to the create handler queue
     - parameter handler: the completion handler that will be called from the PacketsChecker.
     - Version: 1.0
     */
    static func addHandlerToCreateBuffer(handler: @escaping (Int) -> Void) {
        lock.lock()
        createBuffer.append(handler)
        lock.unlock()
    }
    
    /**
     the function that will add a handler to the login handler queue
     - parameter handler: the completion handler that will be called from the PacketsChecker.
     - Version: 1.0
     */
    static func addHandlerToLogInBuffer(handler: @escaping (Int) -> Void) {
        lock.lock()
        logInBuffer.append(handler)
        lock.unlock()
    }
    
    /**
     the function that will add a handler to the signup handler queue
     - parameter handler: the completion handler that will be called from the PacketsChecker.
     - Version: 1.0
     */
    static func addHandlerToSignUpBuffer(handler: @escaping (Bool) -> Void) {
        lock.lock()
        signUpBuffer.append(handler)
        lock.unlock()
    }
}
