package com.nasoftware.Server.DataLayer;

import com.nasoftware.Server.NetworkLayer.ChatServer;
import java.util.ArrayList;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by zeyongshan on 10/23/17.
 */
public class Room {
    public final int roomID;

    private ArrayList<Integer> roomMembers = new ArrayList<Integer>();
    private Lock lock = new ReentrantLock();

    public Room(int roomID) {
        this.roomID = roomID;
    }

    public void addMember(ChatServer newMember) {
        lock.lock();
        roomMembers.add(newMember.userID);
        lock.unlock();
    }

    public void deleteMember(ChatServer memberToDelete) {
        lock.lock();
        roomMembers.remove(memberToDelete.userID);
        lock.unlock();
    }

    public ArrayList<Integer> getReadOnlyMemberList() {
        lock.lock();
        final ArrayList<Integer> list = roomMembers;
        lock.unlock();
        return list;
    }
}
