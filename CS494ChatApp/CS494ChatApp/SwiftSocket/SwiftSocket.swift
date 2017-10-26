//
//  File.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 10/25/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation


class SwiftSocket {
    
    private var connecting = false
    
    init() {
        let result = socketInit()
        if result >= 0 {
            connecting = true
        }
    }
    
    func writeToServer(context: String) -> Bool {
        let result = socketWrite(UnsafeMutablePointer<Int8>(mutating: (context as NSString).utf8String))
        return result >= 0
    }
    
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
    }
    
    var connectionStatus:Bool {
        return connecting
    }
    
}
