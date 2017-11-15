package com.nasoftware.Server.DataLayer;

/**
 * Created by zeyongshan on 10/24/17.
 * the database interfaces.
 */
public class Database {
    /**
     * the map that contains all the users.
     */
    static public ChatServerDistributor chatServerDistributor = new ChatServerDistributor();
    /**
     * the map that contains all the rooms.
     */
    static public RoomDistributor roomDistributor = new RoomDistributor();
    /**
     * the map that contains all the accounts information
     */
    static public AccountMap accountMap = new AccountMap();
}
