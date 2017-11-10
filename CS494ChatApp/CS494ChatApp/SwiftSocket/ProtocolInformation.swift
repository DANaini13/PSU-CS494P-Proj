//
//  ProtocolInformation.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/2/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

// Protocols

/*
 SET USERNAME:
 SET-COMMANDSPL-nameContent  //To server
 SET-COMMANDSPL-SUCCESS | FAILED // To client
 */


/*
 SEND MESSAGE:
 SEND-COMMANDSPL-ROOM-roomNumber-ROOMHEADER-MESS-MessageContent  //Both side
 SEND-COMMANDSPL-PERSON-userID~MESS-MessageContent  //Both side
 */



/*
 GO INTO ROOM:
 GO-COMMANDSPL-ROOM-roomNumber  //To server
 GO-COMMANDSPL-SUCCESS | FAILED //To client
 */


/*
 CREATE NEW ROOM:
 CREATE-COMMANDSPL-Password  //To server
 CREATE-COMMANDSPL-ROOM-roomNumber  //To client
 */

// Message Packet Example:
// MESS-MESSAGESPL-content: To server
// MESS-MESSAGESPL-senderID-senderName-date-content: To client

/*
 ADD NEW ACCOUNT:
 ADD-COMMANDSPL-accountName-password //To server
 ADD-COMMANDSPL-SUCCESS|FAILED //To Client
 */


/*
 LOG IN:
 LOGIN-COMMANDSPL-accountName-password //To server
 LOGIN-COMMANDSPL-SUCCESS|FAILED //To Client
 */

/**
 * Explanation:
 * All the Information in headers are split by "-":
 * For example: ROOM-0 means this packet was package by the room NO.
 * The header contains two message:
 *      1. it has been package by room.
 *      2. the room No is 0.
 * Different header in different level has it's own splitter to the package.
 * For example:
 *      SEND-COMMANDSPL-ROOM-1-ROOMSPL-MESS-MESSAGESPL-0-FunName-Tue Oct 24 15:41:33 PDT 2017-Hello
 *      Above is a packet that sent form the server.
 *      this packet contains three header and three header splitter:
 *      SEND header:   -COMMAND-
 *      ROOM header:   -ROOM-
 *      MESS header:   -MESSAGE-
 *
 *      SEND-COMMANDSPL-ROOM-0-ROOMSPL-MESS-MESSAGESPL-Hello world!
 *      Above is a packet that sent form the client.
 *
 *      which means this packet was packaged by SEND command, Room No. 1 and Message.
 *      The text in the MESS part shows that the user and message information:
 *      userID: 0
 *      userName: funName
 *      sendDate: Tue Oct 24 15:41:33 PDT   // All the date is generated from server.
 *      messageContent: Hello
 */
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
    static let getListHeader    = "GETLIST"
    static let roomHeader       = "ROOM"
    static let messageHeader    = "MESS"
    static let successText      = "SUCCESS"
    static let failedText       = "FAILED"
    static let globalKeyWord    = "GLOBAL"
    static let personalKeyWord  = "PERSONAL"
}
