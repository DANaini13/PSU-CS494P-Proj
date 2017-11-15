package com.nasoftware.Server.DataLayer;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by zeyongshan on 10/24/17.
 */
public class RoomDistributor {
    private HashMap<Integer, Room> roomHashMap = new HashMap<Integer, Room>();
    private LinkedList<Integer> removedList = new LinkedList<Integer>();
    private Lock lock = new ReentrantLock();

    public Room assignANewRoomID() {
        lock.lock();
        int roomID;
        if(removedList.size() > 0) {
            roomID = removedList.getLast();
            removedList.removeLast();
        } else {
            roomID = roomHashMap.size();
        }
        Room room = new Room(roomID);
        roomHashMap.put(roomID, room);
        lock.unlock();
        return room;
    }


    public boolean removeFromDistrubutor(int roomID) {
        lock.lock();
        boolean returnValue = false;
        if (roomHashMap.containsKey(roomID)) {
            returnValue = true;
            roomHashMap.remove(roomID);
            removedList.add(roomID);
        }
        lock.unlock();
        return returnValue;
    }


    public HashMap<Integer, Room> getReadOnlyRoomHashMap() {
        lock.lock();
        final HashMap<Integer, Room> map = roomHashMap;
        lock.unlock();
        return map;
    }
}
