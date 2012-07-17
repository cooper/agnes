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
#import "AgnesParserCommand.h"

static NSUInteger currentId = 0;
static NSMutableDictionary *commandHandlers;

@implementation AgnesParser

+ (void)installDefaults {
    commandHandlers = [[NSMutableDictionary alloc] init];
    NSArray *defaultCommands = [NSArray arrayWithObjects:
        @"005",     handleISupport,         /* RPL_ISUPPORT   */
        @"376",     handleEndOfMOTD,        /* RPL_ENDOFMOTD  */
        @"396",     handleHostHidden,       /* RPL_HOSTHIDDEN */
        @"PRIVMSG", handlePrivmsg,
        @"NICK",    handleNick,
    nil];
    for (uint8 i = 0; i != defaultCommands.count; i++) {
        NSString *command = [defaultCommands objectAtIndex:i]; i++;
        CommandCallback callback = [defaultCommands objectAtIndex:i];
        [self registerCommandHandler:callback forCommand:command];
    }
}

+ (int)registerCommandHandler:(CommandCallback)callback forCommand:(NSString *)command {
    NSMutableArray *events;
    
    // if event array does not exist, create it.
    NSMutableArray *foundEvents = [commandHandlers objectForKey:command];
    if (foundEvents)
        events = foundEvents;
    else {
        events = [[NSMutableArray alloc] init];
        [commandHandlers setObject:events forKey:command];
    }
    
    // register the event.
    int myId = currentId++;
    NSArray *thisEvent = [NSArray arrayWithObjects:[NSNumber numberWithInt:myId], callback, nil];
    [events addObject:thisEvent];

    return myId;
}

// fire event callbacks.
+ (void)fireEvent:(NSString *)command withCmd:(AgnesParserCommand *)cmd {
    NSMutableArray *events = [commandHandlers objectForKey:command];
    if (events == nil) return;

    // call each callback with arguments.
    for (NSArray *e in events)
        ((CommandCallback)[e objectAtIndex:1])(cmd);
}

+ (void)parseLine:(NSString *)line connection:(AgnesConnection *)conn {
    NSArray *args = [line componentsSeparatedByString:@" "];
    AgnesParserCommand *cmd = [[AgnesParserCommand alloc] initWithLine:line];
    
    // handle PING. hard coded.
    if ([[args objectAtIndex:0] isEqualToString:@"PING"]) {
        [conn sendPong:[args objectAtIndex:1]];
        return;
    }
    cmd.connection = conn;
    cmd.user = [conn userFromString:[cmd nth:0]];
    
    // fire commands.
    [self fireEvent:[args objectAtIndex:1] withCmd:cmd];
}


/* NUMERIC HANDLERS */


// RPL_ISUPPORT
void (^handleISupport)(AgnesParserCommand *) = ^(AgnesParserCommand *cmd) {
    uint8 lastIndex = [[cmd arguments] count] - 1;
    for (uint8 i = 0; i < lastIndex; i++) {
        if (i < 3) continue;
        NSString *item = [cmd nth:i];
        
        // key=value
        if ([item rangeOfString:@"="].location != NSNotFound) {
            NSArray *components = [item componentsSeparatedByString:@"="];
            NSString *key   = [components objectAtIndex:0];
            NSString *value = [components objectAtIndex:1];
            [cmd.connection.serverSupport setObject:value forKey:key];
            
            // set server name
            if ([key isEqualToString:@"NETWORK"])
                cmd.connection.serverName = value;
        }
        
        // value
        else
            [cmd.connection.serverSupport setObject:@"TRUE" forKey:item];
    }
};

// RPL_ENDOFMOTD
void (^handleEndOfMOTD)(AgnesParserCommand *) = ^(AgnesParserCommand *cmd) {
    [cmd.connection sendLine:@"JOIN #k"];
};

// RPL_HOSTHIDDEN
void (^handleHostHidden)(AgnesParserCommand *) = ^(AgnesParserCommand *cmd) {
    [cmd.connection.thisUser setCloak:[cmd nth:3]];
};

/* COMMAND HANDLERS */


// NICK
void (^handleNick)(AgnesParserCommand *) = ^(AgnesParserCommand *cmd) {
    NSString *oldnick = cmd.user.nickname;
    [cmd.user setNickname:[cmd last]];
    [cmd.connection updateNick:oldnick newNick:[cmd last]];
};

// PRIVMSG
void (^handlePrivmsg)(AgnesParserCommand *) = ^(AgnesParserCommand *cmd) {
    NSString *msg = [cmd last];
    AgnesConnection *conn = cmd.connection;

    if ([[cmd nthReal:3] isEqualToString:@":@info"]) [conn sendLine:
        [NSString stringWithFormat:
        @"PRIVMSG #k :connection = %@, user = %@, channel = %@, msg = %@",
        conn, cmd.user, cmd.channel, msg]];
        
    if ([[cmd nthReal:3] isEqualToString:@":@channel"]) [conn sendLine:
        [NSString stringWithFormat:@"PRIVMSG #k :channel = %@, connection = %@, name = %@",
        cmd.channel, cmd.channel.connection, cmd.channel.name]];
        
    if ([[cmd nthReal:3] isEqualToString:@":@user"]) [conn sendLine:
        [NSString stringWithFormat:
        @"PRIVMSG #k :user = %@, connection = %@, nick = %@, ident = %@, cloak = %@",
        cmd.user, cmd.user.connection, cmd.user.nickname, cmd.user.username, cmd.user.cloak]];
        
    if ([[cmd nthReal:3] isEqualToString:@":@you"]) [conn sendLine:
        [NSString stringWithFormat:
        @"PRIVMSG #k :user = %@, connection = %@, nick = %@, ident = %@, cloak = %@",
        conn.thisUser, conn.thisUser.connection, conn.thisUser.nickname,
        conn.thisUser.username, conn.thisUser.cloak]];
        
    if ([[cmd nthReal:3] isEqualToString:@":@setnick"])
        [conn sendLine:[NSString stringWithFormat:@"NICK %@", [cmd nthReal:4]]];
    
    if ([[cmd nthReal:3] isEqualToString:@":@isupport"]) [conn sendLine:
        [NSString stringWithFormat:@"PRIVMSG #k :%@",
        [cmd.connection.serverSupport objectForKey:[cmd nthReal:4]]]];
};

@end
