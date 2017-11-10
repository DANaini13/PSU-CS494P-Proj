//
//  RoomsViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/8/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class RoomsViewController: UITableViewController {
    
    var roomsContainer = RoomsContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomsContainer.updateHandler = {
            DispatchQueue.main.async {
                [weak self] in self?.tableView.reloadData()
            }
        }
        roomsContainer.check()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomsContainer.length
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
        if let roomCell = cell as? RoomCell {
            roomCell.roomName = "room " + roomsContainer.list[indexPath.row]
        }
        return cell
    }
    
    @IBAction func touchCreateButton(_ sender: UIButton) {
        roomsContainer.createRoom(password: "000000") {
            result in
            print("create room \(result) successfully!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            let joinInPage = segue.destination as? JoinRoomViewController,
            let roomCell = sender as? RoomCell {
            if identifier == "joinRoom" {
                joinInPage.picture = roomCell.picture
                joinInPage.title = "Join in " + (roomCell.roomName ?? "unknow")
                joinInPage.roomNo = Int((roomCell.roomName?.components(separatedBy: " ")[1])!)
            }
        }
    }

    
}
