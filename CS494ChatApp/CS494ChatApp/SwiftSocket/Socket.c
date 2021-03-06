//
//  Socket.c
//  CS494ChatApp
//
//  Created by zeyong shan on 10/25/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include "HostInfo.h"

static int sock = -1;
static char* readBuffer1 = NULL;
static char* readBuffer2 = NULL;

/**
 This function will initialize the buffer and connect with server.
 it returns -1 for the case that connection failed.
 */
int socketInit() {
    readBuffer1 = malloc(sizeof(char)*350);
    readBuffer2 = malloc(sizeof(char)*350);
    sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr(HOST_ADDRESS);
    serv_addr.sin_port = htons(HOST_PORT);
    int result = connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    if (result < 0) {
        free(readBuffer1);
        readBuffer1 = NULL;
        free(readBuffer2);
        readBuffer2 = NULL;
        sock = -1;
        return -1;
    }
    return 0;
}

/**
 This function will only work after the socketInit() was
 called successfully.
 It would read from the server if there is a packet sent from
 server.
 It returns NULL if no unread packet.
 */
char* socketRead() {
    if(sock < 0)
        return NULL;
    ssize_t result = read(sock, readBuffer1, sizeof(char)*MAX_POCKET_LEN);
    if (result < 0)
        return NULL;
    strcpy(readBuffer2, readBuffer1);
    readBuffer1[0] = '\0';
    readBuffer2[result] = '\0';
    return readBuffer2;
}

/**
 This function will only work after the socketInit() was
 called successfully.
 It would send a packet to server.
 return -1 if sending failed.
 */
long socketWrite(const char* content) {
    if(sock < 0)
        return -1;
    long writingResult = write(sock, content, sizeof(char)*MAX_POCKET_LEN);
    return writingResult;
}

/**
 This function will only work after the socketInit() was
 called successfully.
 It would colse the connection from the server.
 */
void closeConnection() {
    close(sock);
    sock = -1;
    if(readBuffer1) {
        free(readBuffer1);
        readBuffer1 = NULL;
    }
    if(readBuffer2) {
        free(readBuffer2);
        readBuffer2 = NULL;
    }
}


