package com.nasoftware.Server.DataLayer;

import com.nasoftware.Server.NetworkLayer.ChatServer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by zeyongshan on 10/23/17.
 */
public class Room {
    public final int roomID;

    private ArrayList<Integer> roomMembers = new ArrayList<Integer>();
    private HashMap<Integer, Integer> roomMembersIDMap = new HashMap<>();
    private Lock lock = new ReentrantLock();

    public Room(int roomID) {
        this.roomID = roomID;
    }

    public boolean addMember(ChatServer newMember) {
        lock.lock();
        if(roomMembersIDMap.containsKey(newMember.userID)) {
            lock.unlock();
            return false;
        }
        roomMembers.add(newMember.userID);
        roomMembersIDMap.put(newMember.userID, 0);
        lock.unlock();
        return true;
    }

    public void deleteMember(ChatServer memberToDelete) {
        lock.lock();
        roomMembers.remove(memberToDelete.userID);
        roomMembersIDMap.remove(memberToDelete.userID);
        lock.unlock();
    }

    public ArrayList<Integer> getReadOnlyMemberList() {
        lock.lock();
        final ArrayList<Integer> list = roomMembers;
        lock.unlock();
        return list;
    }

    public HashMap<Integer, Integer> getReadOnlyRoomMembersIDMap() {
        lock.lock();
        final HashMap<Integer, Integer> map = roomMembersIDMap;
        lock.unlock();
        return map;
    }
}
