//
//  JoinRoomViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/9/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class JoinRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    
    var roomNo:Int?
    
    var users:[String]? {
        didSet{
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        image.image = picture
        image.layer.zPosition = 100
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        roomLabel.text = roomText
        requestUserList()
    }
    
    @IBOutlet weak var roomLabel: UILabel!
    
    @IBAction func touchJoinInButton(_ sender: UIButton) {
        guard roomNo != nil else {
            return
        }
        let packet = PacketsGenerator.generateGoPacket(to: roomNo!) {
            result in
            DispatchQueue.main.async {
                [weak self] in
                self?.waitingIndicator.stopAnimating()
                if result {
                    let alertController = UIAlertController(title: "Hint", message: "Join in room successfully!", preferredStyle: .alert)
                    let okAcount = UIAlertAction(title: "Ok", style: .cancel, handler: {
                        action in
                    })
                    alertController.addAction(okAcount)
                    self?.present(alertController, animated: true, completion: nil)
                }else {
                    let alertController = UIAlertController(title: "Hint", message: "log in status unexpectly!", preferredStyle: .alert)
                    let okAcount = UIAlertAction(title: "Ok", style: .cancel, handler: {
                        action in
                    })
                    alertController.addAction(okAcount)
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
        waitingIndicator.startAnimating()
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
    
    var picture: UIImage?
    var roomText: String?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        cell.textLabel?.text = users?[indexPath.row]
        return cell
    }
    
    func requestUserList() {
        guard roomNo != nil else {
            return
        }
        let packet = PacketsGenerator.generateGetUserPacket(roomID: roomNo!){
            [weak self] result in
            self?.users = result
        }
        PacketsCheckerAndSender.sendPacket(packet: packet)
    }
}
