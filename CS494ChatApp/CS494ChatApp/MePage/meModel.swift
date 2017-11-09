//
//  meModel.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/8/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation


struct MeModel {
    func setNickedName(name: String, completionHandler: @escaping (Bool) -> Void) {
        let packet = PacketsGenerator.generateSetPacket(userName: name, handler: completionHandler)
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
}
