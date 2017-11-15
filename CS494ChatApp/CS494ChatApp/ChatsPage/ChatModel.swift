//
//  ChatModel.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/9/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation


class MessageRoom {
    init(roomNum: Int) {
        roomNumber = roomNum
    }
    
    func match(room: MessageRoom) -> Bool {
        return room.roomNumber == roomNumber
    }
    
    var messageList: [Message] = []
    let roomNumber:Int
    var unreadMessage = 0
}

class ChatsContainer{
    
    var roomList:[MessageRoom] = []
    
    var length: Int {
        return roomList.count
    }
    
    var list: [MessageRoom] {
        return roomList
    }
    
    var updateHandler: (() -> Void)?
    
    private func contains(room: MessageRoom) -> Bool {
        for x in self.roomList {
            if x.match(room: room) {
                return true
            }
        }
        return false
    }
    
    init() {
        PacketsCheckerAndSender.setNewPersonallistHandler(){
            [unowned self] result in
            if result[0] == ""{
                self.roomList = []
                return
            }
            for x in result{
                let roomNo = Int(x)!
                let room = MessageRoom(roomNum: roomNo)
                if !self.contains(room: room) {
                    self.roomList.append(room)
                }
            }
            self.updateHandler?()
        }
    }
    
    func check() {
        let packet = PacketsGenerator.generateGetListPersonal() {
            [unowned self] result in
            if result[0] == ""{
                self.roomList = []
                return
            }
            for x in result{
                let roomNo = Int(x)!
                let room = MessageRoom(roomNum: roomNo)
                if !self.contains(room: room) {
                    self.roomList.append(room)
                }
            }
            self.updateHandler?()
        }
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
    
    func addMessageToRooms(message: Message) {
        let roomNo = message.roomNumber
        var index = 0
        while(index < roomList.count) {
            if roomList[index].roomNumber == roomNo {
                roomList[index].messageList.append(message)
                roomList[index].unreadMessage += 1
                self.updateHandler?()
            }
            index += 1
        }
    }
    
    func addMessageToRoomsWithoutIncrementUnread(message: Message) {
        let roomNo = message.roomNumber
        var index = 0
        while(index < roomList.count) {
            if roomList[index].roomNumber == roomNo {
                roomList[index].messageList.append(message)
                self.updateHandler?()
            }
            index += 1
        }
    }
    
    func getRoom(with roomNo: Int) -> MessageRoom? {
        var index = 0
        while(index < roomList.count) {
            if roomList[index].roomNumber == roomNo {
                return roomList[index]
            }
            index += 1
        }
        return nil
    }
    
}
