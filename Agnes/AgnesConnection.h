//
//  AgnesConnection.h
//  Mixtape
//
//  Created by Mitchell Cooper on 7/1/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesConnection
//

#import <Foundation/Foundation.h>
#import "AgnesSocket.h"
#import "AgnesConnectionDelegate.h"

@class AgnesManager, AgnesChannel, AgnesUser;

@interface AgnesConnection : NSObject {
    AgnesSocket *socket;
    NSMutableDictionary *userDict;
    NSMutableDictionary *channelDict;
}

@property (assign) id<AgnesConnectionDelegate> delegate;
@property (assign) AgnesManager *manager;
@property (assign) UInt16 port;
@property (assign) BOOL ssl;
@property (assign) NSString *address;
@property (assign) NSString *username;
@property (assign) NSString *realname;
@property (assign) NSString *nickname; // note: these are DESIRED values. real values can be fetched
@property AgnesUser *thisUser;         // from the thisUser AgnesUser property.
@property NSMutableDictionary *serverSupport;
@property id session;
@property int sid;
@property NSString *serverName;

- (id)initWithDelegate:(id)del;
- (void)connect;
- (void)sendLine:(NSString *)line;
- (void)sendPong:(NSString *)source;

/*  These messages are sent by AgnesSocket.
    They used to be included in the AgnesSocketProtocol. */
- (void)onConnectionEstablished;
- (void)onConnectionError:(NSError *)error;
- (void)onSSLHandshakeComplete;
- (void)onRawLine:(NSString *)line;

// updates the nickname in its storage dictionary.
- (void)updateNick:(NSString *)oldnick newNick:(NSString *)newnick;

// create OR fetch a user from a nick!ident\@host string
- (AgnesUser *)userFromString:(NSString *)string;

// create OR fetch a channel from #channelname string
- (AgnesChannel *)channelFromName:(NSString *)name;

@end