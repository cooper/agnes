//
//  AgnesConnection.m
//  Mixtape
//
//  Created by Mitchell Cooper on 7/1/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// AgnesConnection represents a connection to an IRC server and the server object itself.
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesConnection
//

#import "AgnesConnection.h"
#import "AgnesUser.h"
#import "AgnesChannel.h"
#import "AgnesManager.h"
#import "AgnesParser.h"

@implementation AgnesConnection

@synthesize identifier, session, ssl, manager, delegate, nickname, username, realname,
            thisUser, serverSupport, serverName;

- (id)initWithDelegate:(id<AgnesConnectionDelegate>)del {
    self = [super init];
    if (self) {
        identifier  = [self hash];
        delegate    = del;
        ssl         = false;
        socket      = [[AgnesSocket alloc] initWithDelegate:self];
        userDict    = [[NSMutableDictionary alloc] init];
        channelDict = [[NSMutableDictionary alloc] init];
        thisUser    = [[AgnesUser alloc] init];
        serverSupport = [[NSMutableDictionary alloc] init];
        thisUser.connection = self;
        thisUser.identifier = [thisUser hash];
    }
    NSLog(@"created with socket: %@", socket);
    return self;
}

// instance methods

- (void)connect {
    thisUser.nickname = nickname;
    [userDict setObject:thisUser forKey:[nickname lowercaseString]];
    [socket connect:ssl];
    [socket sendLine:[NSString stringWithFormat:@"USER %@ * * :%@", username, realname]];
    [socket sendLine:[NSString stringWithFormat:@"NICK %@", nickname]];
}

// command sending methods

- (void)sendLine:(NSString *)line {
    [socket sendLine:line];
}

- (void)sendPong:(NSString *)source {
    [socket sendLine:[NSString stringWithFormat:@"PONG %@", source]];
}

// these setters and getters forward to the AgnesSocket object.

- (UInt16)port {
    return socket.port;
}

- (void)setPort:(UInt16)port {
    socket.port = port;
}

- (NSString *)address {
    return socket.address;
}

- (void)setAddress:(NSString *)address {
    socket.address = serverName = address;
}

/* messages sent by AgnesSocket. */

- (void)onConnectionEstablished {
    if ([delegate respondsToSelector:@selector(connectionDidConnect:)])
        [delegate connectionDidConnect:self];
    [manager createConnectionSession:self];
}

- (void)onConnectionError:(NSError *)error {
    if ([delegate respondsToSelector:@selector(connection:didFailConnectWithError:)])
        [delegate connection:self didFailConnectWithError:error];
    [manager showConnectionError:self error:error];
}

- (void)onRawLine:(NSString *)line {
    
    // pass on the raw event to the delegate.
    if ([delegate respondsToSelector:@selector(connection:didReceiveLine:)])
        [delegate connection:self didReceiveLine:line];
    
    // parse it with Parser.
    [AgnesParser parseLine:line connection:self];
}

- (void)onSSLHandshakeComplete {
    if ([delegate respondsToSelector:@selector(connectionDidCompleteHandshake:)])
        [delegate connectionDidCompleteHandshake:self];
}

/* end messages by agnessocket */

// lookup or create a user by a nick!user@host string.
- (AgnesUser *)userFromString:(NSString *)string {

    // check if it's nick!user@host
    if ([string rangeOfString:@"!"].location == NSNotFound || [string rangeOfString:@"@"].location == NSNotFound)
        return nil;
    
    // separate data. perhaps there is a cleaner way to do so.
    NSArray *split1 = [string componentsSeparatedByString:@"!"];
    NSArray *split2 = [[split1 objectAtIndex:1] componentsSeparatedByString:@"@"];
    NSString *nick  = [split1 objectAtIndex:0];
    NSString *user  = [split2 objectAtIndex:0];
    NSString *cloak = [split2 objectAtIndex:1];
    
    // look for an existing user instance.
    AgnesUser *foundUser = [userDict objectForKey:[nick lowercaseString]];
    AgnesUser *finalUser;
    if (foundUser)
        finalUser = foundUser;
    else {
        finalUser = [[AgnesUser alloc] init];
        finalUser.connection = self;
        finalUser.identifier = [finalUser hash];
        [userDict setObject:finalUser forKey:[nick lowercaseString]];
    }
    // set information from string.
    finalUser.nickname = nick;
    finalUser.username = user;
    finalUser.cloak    = cloak;

    return finalUser;
}

// lookup or create a channel by its name.
- (AgnesChannel *)channelFromName:(NSString *)name {
    // look for an existing channel instance.
    AgnesChannel *foundChannel = [channelDict objectForKey:[name lowercaseString]];
    AgnesChannel *finalChannel;
    if (foundChannel)
        finalChannel = foundChannel;
    else {
        finalChannel = [[AgnesChannel alloc] init];
        finalChannel.connection = self;
        finalChannel.identifier = [finalChannel hash];
        [channelDict setObject:finalChannel forKey:[name lowercaseString]];
    }
    
    finalChannel.name = name;
    
    return finalChannel;
}

// update the nickname of this connection's user.
- (void)updateNick:(NSString *)oldnick newNick:(NSString *)newnick {
    AgnesUser *user = [userDict objectForKey:[oldnick lowercaseString]];
    [userDict removeObjectForKey:[oldnick lowercaseString]];
    [userDict setObject:user forKey:[newnick lowercaseString]];
}

/* setters and getters for serverName property. */

- (void)setServerName:(NSString *)name {
    if ([delegate respondsToSelector:@selector(connection:willChangeServerName:)])
        [delegate connection:self willChangeServerName:name];
    serverName = name;
}

- (NSString *)serverName {
    return serverName;
}

// NSObject description.
- (NSString *)description {
    return [NSString stringWithFormat:@"<AgnesConnection: %p (%d)>", self, identifier];
}

@end
