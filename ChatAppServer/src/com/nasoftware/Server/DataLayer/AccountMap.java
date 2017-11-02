package com.nasoftware.Server.DataLayer;

import java.util.HashMap;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by zeyongshan on 11/2/17.
 */
public class AccountMap {
    private HashMap<String, String> map = new HashMap<>();
    private Lock lock = new ReentrantLock();

    public boolean addAccount(String account, String password) {
        if(map.containsKey(account))
            return false;
        lock.lock();
        map.put(account, password);
        lock.unlock();
        return true;
    }

    public HashMap<String, String> getReadOnlyHashMap() {
        lock.lock();
        final HashMap<String, String> result = map;
        lock.unlock();
        return result;
    }
}
