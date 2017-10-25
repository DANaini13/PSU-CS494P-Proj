package com.nasoftware.Common;

import java.util.HashMap;

/**
 * Created by zeyongshan on 10/24/17.
 */

// Protocols

/*
SET USERNAME:

SET-SETHEADER-nameContent  //To server
SET-SETHEADER-SUCCESS | FAILED // To client
*/


/*
SEND MESSAGE:

SEND-SENDHEADER-ROOM-roomNumber-ROOMHEADER-MESS-MessageContent  //Both side
SEND-SENDHEADER-PERSON-userID~MESS-MessageContent  //Both side
*/



/*
GO INTO ROOM:

GO-GOSENDHEADER-RROOM-roomNumber  //To server
GO-GOSENDHEADER-SUCCESS | FAILED //To client
*/


/*
CREATE NEW ROOM:

CREATE-CREATEHEADER-Password  //To server
CREATE-CREATEHEADER-ROOM-roomNumber  //To client
*/

// Message Packet Example:
    // MESS-MESSSPLITTER-content: To server
    // MESS-MESSSPLITTER-senderID-senderName-date-content: To client


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
public class ProtocolInfo {
    public static final String requestSplitter = "-COMMANDSPL-";
    public static final String roomSplitter = "-ROOMSPL-";
    public static final String messageSplitter = "-MESSAGESPL-";
    public static final String contentSplitter = "-";
    public static final String sendHeader = "SEND";
    public static final String setHeader = "SET";
    public static final String goHeader = "GO";
    public static final String createHeader = "CREATE";
    public static final String roomHeader = "ROOM";
    public static final String messageHeader = "MESS";
    public static final String failedText = "FALIED";
    public static final String successText = "SUCCESS";
}

