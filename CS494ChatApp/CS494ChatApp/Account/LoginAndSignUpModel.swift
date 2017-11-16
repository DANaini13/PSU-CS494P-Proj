//
//  LoginAndSignUpModel.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/2/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import Foundation
/**
 The model of the login view controller and the sign up view controller
 It aimed to connect with the web model and do the signup and log in
 operation
 */
struct LoginAndSignUpModel {
    private var account: String?
    private var password: String?

    /**
     connect with the web model and send the login request
     - parameters:
        - account: the user account that uesd to login
        - password: the user password that used to login
        - completionHandler: the completion handler that will be called after the server responsed
     - Version: 1.0
     */
    func logIn(account: String, password: String, completionHandler: @escaping (Int) -> Void) {
        let packet = PacketsGenerator.generateLogInPacket(account: account, password: password, handler: completionHandler)
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
    
    /**
     connect with the web model and send the sign up request
     - parameters:
        - account: the user account that uesd to sign up
        - password: the user password that used to sign up
        - completionHandler: the completion handler that will be called after the server responsed
     - Version: 1.0
     */
    func signUp(account: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        let packet = PacketsGenerator.generateSignUpPacket(account: account, password: password, handler: completionHandler)
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
}
