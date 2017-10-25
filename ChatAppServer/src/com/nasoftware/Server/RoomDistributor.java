package com.nasoftware.Server;

import com.nasoftware.Common.Message;
import static com.nasoftware.Common.ProtocolInfo.*;

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

    public boolean sendMessagePacket(String packet, int senderID, String senderName) {
        //packet example: ROOM-roomNumber-ROOM-MessageContent
        String splitter = roomSplitter;
        String header = roomHeader;
        String parts[] = packet.split(splitter);
        if (parts.length != 2)
            return false;
        String[] headerParts = parts[0].split(contentSplitter);
        if (headerParts.length != 2)
            return false;
        if (!headerParts[0].equals(header))
            return false;
        try {
            int roomNumber = Integer.parseInt(headerParts[1]);
            if (roomHashMap.containsKey(roomNumber)) {
                Room room = roomHashMap.get(roomNumber);
                Message message = Message.createFromClientPacket(parts[1], senderID, senderName);
                if(message == null)
                    return false;
                room.addMessageToRoom(message);
                return true;
            }
            return false;
        } catch (NumberFormatException _) {
            return false;
        }
    }


    public HashMap<Integer, Room> getReadonlyRoomHashMap() {
        lock.lock();
        final HashMap<Integer, Room> map = roomHashMap;
        lock.unlock();
        return map;
    }
}
