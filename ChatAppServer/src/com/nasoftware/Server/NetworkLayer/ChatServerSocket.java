package com.nasoftware.Server.NetworkLayer;

import com.nasoftware.Server.DataLayer.Database;
import com.nasoftware.Server.DataLayer.Room;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.util.HashMap;

import static com.nasoftware.Server.DataLayer.Database.chatServerDistributor;

/**
 * Created by zeyongshan on 10/23/17.
 */
public class ChatServerSocket extends Thread {
    private ServerSocket serverSocket;

    public ChatServerSocket(int port) {
        try {
            serverSocket = new ServerSocket(port);
            serverSocket.setSoTimeout(1000);
            Database.roomDistributor.assignANewRoomID();
        } catch (SocketException e) {
            System.out.print(e.getMessage());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void run() {
        while (true) {
            try {
                Socket server = serverSocket.accept();
                ChatServer chatServer = chatServerDistributor.assignANewChatServerID(server);
                System.out.println(chatServer.userID + "established");
                HashMap<Integer, Room> map = Database.roomDistributor.getReadOnlyRoomHashMap();
                Room zero = map.get(0);
                zero.addMember(chatServer);
                chatServer.start();
            } catch (IOException e) {
                //System.out.println("socket time out!");
            }
        }
    }
}
