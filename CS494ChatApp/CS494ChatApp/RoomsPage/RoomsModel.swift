//
//  RoomsModel.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/8/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

class RoomsModel{
    private var roomList: [String] = []
    
    var length: Int {
        return roomList.count
    }
    
    var list: [String] {
        return roomList
    }
    
    private let lock: NSLock = NSLock()
    
    private func compareWithList(list: [String]) -> Bool {
        var index = 0
        if list.count != roomList.count {
            return false
        }
        while index < list.count {
            if roomList[index] != list[index] {
                return false
            }
            index += 1
        }
        return true
    }
    var updateHandler:(() -> Void)?
    
    func startChecking() {
        DispatchQueue.global(qos: .utility).async {
            while(true) {
                if !PacketsCheckerAndSender.checking {
                    print("the packet checking is not opening!")
                    break;
                }
                let packet = PacketsGenerator.generateGetListPacket(key: "ROOMS") {
                    [weak self] result in
                    if self!.compareWithList(list: result) {
                        return
                    }
                    if result[0] == "" {
                        return
                    }
                    self!.roomList = result
                    DispatchQueue.main.async {
                        self!.updateHandler?()
                    }
                }
                PacketsCheckerAndSender.sendPacket(packet: packet)
                sleep(1)
            }
        }
    }
    
    func createRoom(password: String, completionHandler: @escaping (Int) -> Void) {
        let packet = PacketsGenerator.generateCreatePacket(administratorPassword: password, handler: completionHandler)
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
    
}
