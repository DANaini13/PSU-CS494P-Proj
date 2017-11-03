package com.nasoftware.Server.DataLayer;

import com.nasoftware.Server.NetworkLayer.ChatServer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by zeyongshan on 10/23/17.
 * The abstract that stands for the room in the server
 */
public class Room {
    public final int roomID;

    private ArrayList<Integer> roomMembers = new ArrayList<Integer>();
    private HashMap<Integer, Integer> roomMembersIDMap = new HashMap<>();
    private Lock lock = new ReentrantLock();

    public Room(int roomID) {
        this.roomID = roomID;
    }

    /**
     * this function will add a new member into the room
     * @param newMember     the parameter that store all the information of the user.
     * @return              return a boolean that store the result of the add operation.
     */
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

    /**
     * delete the member with the member information.
     * @param memberToDelete    the parameter that store the information of the member to delete
     */
    public void deleteMember(ChatServer memberToDelete) {
        lock.lock();
        roomMembers.remove(memberToDelete.userID);
        roomMembersIDMap.remove(memberToDelete.userID);
        lock.unlock();
    }

    /**
     * get the abstract data type to traverse
     * @return  return an read only array list to traverse
     */
    public ArrayList<Integer> getReadOnlyMemberList() {
        lock.lock();
        final ArrayList<Integer> list = roomMembers;
        lock.unlock();
        return list;
    }

    /**
     * get the abstract dad type to search
     * @return  return a read only haspMap to search
     */
    public HashMap<Integer, Integer> getReadOnlyRoomMembersIDMap() {
        lock.lock();
        final HashMap<Integer, Integer> map = roomMembersIDMap;
        lock.unlock();
        return map;
    }
}
