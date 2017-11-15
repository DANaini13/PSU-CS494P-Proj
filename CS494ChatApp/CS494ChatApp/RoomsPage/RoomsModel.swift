//
//  RoomsModel.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/8/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

class RoomsContainer{
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
        PacketsCheckerAndSender.setNewGloballistHandler(){
            [unowned self] result in
            if result[0] == ""{
                self.roomList = []
                return
            }
            self.roomList = result
        }
    }
    
    func check() {
        let packet = PacketsGenerator.generateGetListGlobal() {
            [unowned self] result in
            if result[0] == ""{
                self.roomList = []
                return
            }
            self.roomList = result
        }
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
    
    func createRoom(password: String, completionHandler: @escaping (Int) -> Void) {
        let packet = PacketsGenerator.generateCreatePacket(administratorPassword: password, handler: completionHandler)
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
}

