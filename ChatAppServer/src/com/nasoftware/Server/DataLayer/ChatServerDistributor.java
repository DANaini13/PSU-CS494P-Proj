package com.nasoftware.Server.DataLayer;


import com.nasoftware.Server.NetworkLayer.ChatServer;

import java.net.Socket;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by zeyongshan on 10/23/17.
 * the abstract data type that distribute a dynamic user id and store them into the map.
 */
public class ChatServerDistributor {
    private HashMap<Integer, ChatServer> map = new HashMap();
    private LinkedList<Integer> removedList = new LinkedList<>();
    private Lock lock = new ReentrantLock();

    /**
     * to assign a new dynamic chat server id
     * @param server    the socket that contains the user information.
     * @return          return the packaged chat server.
     */
    public ChatServer assignANewChatServerID(Socket server) {
        lock.lock();
        int userID;
        if(removedList.size() > 0) {
             userID = removedList.getLast();
             removedList.removeLast();

        } else {
            userID = map.size();
        }
        ChatServer chatServer = new ChatServer(server ,userID);
        map.put(userID, chatServer);
        lock.unlock();
        return chatServer;
    }

    /**
     * remove a user form the Distributor
     * @param userID    the id of the user that should be removed.
     * @return          return a boolean that store the remove result.
     */
    public boolean removeFormDistributor(int userID) {
        lock.lock();
        boolean returnValue = false;
        if (map.containsKey(userID))
        {
            returnValue = true;
            map.remove(userID);
            removedList.add(userID);
        }
        lock.unlock();
        return returnValue;
    }

    /**
     * get the read only hash map.
     * @return  return the read only hash map that contains all the user info.
     */
    public HashMap<Integer, ChatServer> getReadOnlyMap() {
        lock.lock();
        final HashMap<Integer, ChatServer> returnMap = map;
        lock.unlock();
        return returnMap;
    }
}
