//
//  LoginAndSignUpModel.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/2/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation

struct LoginAndSignUpModel {
    private var account: String?
    private var password: String?

    func logIn(account: String, password: String, completionHandler: @escaping (Int) -> Void) {
        let packet = PacketsGenerator.generateLogInPacket(account: account, password: password, handler: completionHandler)
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
    
    func signUp(account: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        let packet = PacketsGenerator.generateSignUpPacket(account: account, password: password, handler: completionHandler)
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
}
