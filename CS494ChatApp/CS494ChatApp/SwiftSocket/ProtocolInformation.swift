//
//  ProtocolInformation.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/2/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation


struct ProtocolInfo {
    static let requestSplitter  = "-COMMANDSPL-"
    static let roomSplitter     = "-ROOMSPL-"
    static let messageSplitter  = "-MESSAGESPL-"
    static let contentSplitter  = "-"
    static let sendHeader       = "SEND"
    static let setHeader        = "SET"
    static let goHeader         = "GO"
    static let createHeader     = "CREATE"
    static let addHeader        = "ADD"
    static let logInHeader      = "LOGIN"
    static let roomHeader       = "ROOM"
    static let messageHeader    = "MESS"
    static let successText      = "SUCCESS"
    static let failedText       = "FAILED"
}
