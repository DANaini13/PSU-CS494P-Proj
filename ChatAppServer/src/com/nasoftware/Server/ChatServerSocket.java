package com.nasoftware.Server;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.util.HashMap;

import static com.nasoftware.Server.Database.chatServerDistributor;

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
                HashMap<Integer, Room> map = Database.roomDistributor.getReadonlyRoomHashMap();
                Room zero = map.get(0);
                zero.roomMembers.add(chatServer);
                chatServer.start();
            } catch (IOException e) {
                //System.out.println("socket time out!");
            }
        }
    }
}
