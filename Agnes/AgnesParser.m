//
//  AgnesParser.m
//  Mixtape
//
//  Created by Mitchell Cooper on 7/7/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesParser
//

#import "AgnesParser.h"
#import "AgnesCommands.h"
#import "AgnesParserCommand.h"

@implementation AgnesParser

@synthesize connection;

- (id) initWithConnection:(AgnesConnection *)conn {
    self = [super init];
    if (self) {
        connection = conn;
    }
    return self;
}

- (void)parseLine:(NSString *)line {
    NSArray *args = [line componentsSeparatedByString:@" "];
    AgnesParserCommand *cmd = [[AgnesParserCommand alloc] initWithLine:line];
    
    // handle PING. hard coded.
    if ([[args objectAtIndex:0] isEqualToString:@"PING"]) {
        [connection sendPong:[args objectAtIndex:1]];
        return;
    }
    
    cmd.user = [connection userFromString:[cmd nth:0]];
    
    // huge switch.
    serverResponse command = [AgnesCommands getCommand:[args objectAtIndex:1]];
    switch (command) {
            
        case CMD_PRIVMSG:
            // if the target is not myself...
            if (![[[cmd nth:2] lowercaseString] isEqualToString:[connection.thisUser.nickname lowercaseString]])
                cmd.channel = [connection channelFromName:[cmd nth:2]];
            else
                cmd.targetIsMe = YES;
            [self handlePrivmsg:cmd];
            break;
            
        case RPL_ENDOFMOTD:
            [connection sendLine:@"JOIN #k"];
            break;
            
        case CMD_NICK:
            [self handleNick:cmd];
            break;
            
        default:
            break;
    }
}

/* HANDLERS */

- (void)handlePrivmsg:(AgnesParserCommand *)cmd {
    NSString *msg = [cmd last];
    if ([[cmd nthReal:3] isEqualToString:@":@info"])
        [connection sendLine:[NSString stringWithFormat:@"PRIVMSG #k :connection = %@, user = %@, channel = %@, msg = %@",
                          connection, cmd.user, cmd.channel, msg]];
    if ([[cmd nthReal:3] isEqualToString:@":@channel"])
        [connection sendLine:[NSString stringWithFormat:@"PRIVMSG #k :channel = %@, connection = %@, name = %@",
                              cmd.channel, cmd.channel.connection, cmd.channel.name]];
    if ([[cmd nthReal:3] isEqualToString:@":@user"])
        [connection sendLine:[NSString stringWithFormat:
                              @"PRIVMSG #k :user = %@, connection = %@, nick = %@, ident = %@, cloak = %@",
                              cmd.user, cmd.user.connection, cmd.user.nickname, cmd.user.username, cmd.user.cloak]];
    if ([[cmd nthReal:3] isEqualToString:@":@you"])
        [connection sendLine:[NSString stringWithFormat:
                              @"PRIVMSG #k :user = %@, connection = %@, nick = %@, ident = %@, cloak = %@",
                              connection.thisUser, connection.thisUser.connection, connection.thisUser.nickname,
                              connection.thisUser.username, cmd.user.cloak]];
    if ([[cmd nthReal:3] isEqualToString:@":@setnick"])
        [connection sendLine:[NSString stringWithFormat:@"NICK %@", [cmd nthReal:4]]];
}

- (void)handleNick:(AgnesParserCommand *)cmd {
    NSString *oldnick = cmd.user.nickname;
    [cmd.user setNickname:[cmd last]];
    [connection updateNick:oldnick newNick:[cmd last]];
}

@end
