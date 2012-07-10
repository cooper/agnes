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

@synthesize ssl, manager, object, delegate, nickname, username, realname, thisUser;

int cuid = 0;

- (id)initWithDelegate:(id<AgnesConnectionDelegate>)del {
    self = [super init];
    if (self) {
        delegate    = del;
        ssl         = false;
        socket      = [[AgnesSocket alloc] initWithDelegate:self];
        parser      = [[AgnesParser alloc] initWithConnection:self];
        userDict    = [[NSMutableDictionary alloc] init];
        channelDict = [[NSMutableDictionary alloc] init];
        thisUser    = [[AgnesUser alloc] init];
        thisUser.connection = self;
    }
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
    socket.address = address;
}

/* messages sent by AgnesSocket. */

- (void)onConnectionEstablished {
    if ([delegate respondsToSelector:@selector(onConnectionEstablished:)])
        [delegate onConnectionEstablished:self];
    [manager createConnectionSession:self];
}

- (void)onConnectionError:(NSError *)error {
    if ([delegate respondsToSelector:@selector(onConnectionError:error:)])
        [delegate onConnectionError:self error:error];
    [manager showConnectionError:self error:error];
}

- (void)onRawLine:(NSString *)line {
    
    // pass on the raw event to the delegate.
    if ([delegate respondsToSelector:@selector(onRawLine:line:)])
        [delegate onRawLine:self line:line];
    
    // parse it with Parser.
    [parser parseLine:line];
}

- (void)onSSLHandshakeComplete {
    if ([delegate respondsToSelector:@selector(onSSLHandshakeComplete:)])
        [delegate onSSLHandshakeComplete:self];
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
        finalUser.uid = cuid++;
        [userDict setObject:finalUser forKey:[nick lowercaseString]];
    }
    // set information from string.
    finalUser.nickname = nick;
    finalUser.username = user;
    finalUser.cloak    = cloak;

    return finalUser;
}

- (AgnesChannel *)channelFromName:(NSString *)name {

    // look for an existing channel instance.
    AgnesChannel *foundChannel = [channelDict objectForKey:[name lowercaseString]];
    AgnesChannel *finalChannel;
    if (foundChannel)
        finalChannel = foundChannel;
    else {
        finalChannel = [[AgnesChannel alloc] init];
        finalChannel.connection = self;
        [channelDict setObject:finalChannel forKey:[name lowercaseString]];
    }
    
    finalChannel.name = name;
    
    return finalChannel;
}

- (void)updateNick:(NSString *)oldnick newNick:(NSString *)newnick {
    AgnesUser *user = [userDict objectForKey:[oldnick lowercaseString]];
    [userDict removeObjectForKey:[oldnick lowercaseString]];
    [userDict setObject:user forKey:[newnick lowercaseString]];
}

@end
