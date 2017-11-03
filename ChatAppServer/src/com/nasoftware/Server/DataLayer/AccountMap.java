package com.nasoftware.Server.DataLayer;

import java.util.HashMap;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by zeyongshan on 11/2/17.
 * the abstract data type that store all the accounts in the server.
 */
public class AccountMap {
    private HashMap<String, String> map = new HashMap<>();
    private Lock lock = new ReentrantLock();

    /**
     * This function will add a new account to the map if there is no same account exist yet.
     * @param account   the account that used to add
     * @param password  the password that used to add
     * @return          return a boolean that stands for the result of sign up.
     */
    public boolean addAccount(String account, String password) {
        if(map.containsKey(account))
            return false;
        lock.lock();
        map.put(account, password);
        lock.unlock();
        return true;
    }

    /**
     * the function used to access the data base.
     * @return  return the readonly hashMap that store the accounts and passwords.
     */
    public HashMap<String, String> getReadOnlyHashMap() {
        lock.lock();
        final HashMap<String, String> result = map;
        lock.unlock();
        return result;
    }
}
