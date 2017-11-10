//
//  ChatModel.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/9/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation


class ChatsContainer{
    private var roomList: [String] = [] {
        didSet {
            updateHandler?()
        }
    }
    
    var length: Int {
        return roomList.count
    }
    
    var list: [String] {
        return roomList
    }
    
    var updateHandler: (() -> Void)?
    
    init() {
        PacketsCheckerAndSender.setNewPersonallistHandler(){
            [unowned self] result in
            if result[0] == ""{
                self.roomList = []
                return
            }
            self.roomList = result
        }
    }
    
    func check() {
        let packet = PacketsGenerator.generateGetListPersonal() {
            [unowned self] result in
            if result[0] == ""{
                self.roomList = []
                return
            }
            self.roomList = result
        }
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
    
}
