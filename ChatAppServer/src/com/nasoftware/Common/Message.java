package com.nasoftware.Common;

import java.util.Date;
import static com.nasoftware.Common.ProtocolInfo.*;

/**
 * Created by zeyongshan on 10/23/17.
 */


/**
 * Class name: Message
 * public functions:
 *     public static Message createFromServerPacket(String packet)
 *     public static Message createFromClientPacket(String packet, int senderID, String senderName)
 *     String generateMessagePacket()
 */
public class Message {
    private Date date = new Date();
    public final String content;
    public final int senderID;
    public final String senderName;


    /**
     * Function name:   createFromServerPacket()
     * @param packet    The packet that will be parse into the message
     * @return          return the message that store the same information with the packet
     */
    public static Message createFromServerPacket(String packet) {
        String[] parts = packet.split(messageSplitter);
        if (parts.length != 2)
            return null;
        if (!parts[0].equals(ProtocolInfo.messageHeader))
            return null;
        String[] messParts = parts[1].split(contentSplitter);
        if (messParts.length != 4)
            return null;
        try {
            int senderID   = Integer.parseInt(messParts[0]);
            String senderName = messParts[1];
            Date date = new Date(messParts[2]);
            String content = messParts[3];
            Message message = new Message(content, senderID, senderName);
            message.date = date;
            return message;
        }catch (NumberFormatException e) {
            return null;
        }
    }

    // MESS-MESSSPLITTER-content: To server

    /**
     * Function name: createFromClientPacket
     * This function will create a message from the packet that received from client
     * @param packet        the packet that will be translated
     * @param senderID      the sender id
     * @param senderName    the string that hold the name of the sender.
     * @return              return the Message that contains the same information with the packet that passed in.
     */
    public static Message createFromClientPacket(String packet, int senderID, String senderName) {
        String[] parts = packet.split(messageSplitter);
        if (parts.length != 2)
            return null;
        if (!parts[0].equals(messageHeader))
            return null;
        String[] messParts = parts[1].split(contentSplitter);
         if (messParts.length != 1)
            return null;
        try {
            Message message = new Message(messParts[0], senderID, senderName);
            return message;
        }catch (NumberFormatException e) {
            return null;
        }
    }

    /**
     * The initializer that init a message.
     * @param messageContent    the message content that used to create the message object.
     * @param senderID          the number of the sender.
     * @param senderName        the name of the sender.
     */
    public Message(String messageContent, int senderID, String senderName) {
        this.content = messageContent;
        this.senderID = senderID;
        this.senderName = senderName;
    }

    /**
     * generate the message string to display in the server. (only for debuging)
     * @return  return the string that used to display
     */
    public String generateMessageStringForDisplay() {
        return date + "\n" + senderName + "\t: " + content;
    }

    /**
     * generate the packet from the message
     * @return return the packet that contains the same information with the message.
     */
    public String generateMessagePacket() {
        String header = "MESS" + messageSplitter;
        if(senderName != null)
            return header + senderID + contentSplitter + senderName + contentSplitter + date + contentSplitter + content;
        else
            return header + senderID + contentSplitter + "UNKNOWN" + contentSplitter + date + contentSplitter + content;
    }
}
