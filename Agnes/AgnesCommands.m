//
//  AgnesCommands.m
//  Mixtape
//
//  Created by Mitchell Cooper on 7/7/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesCommands
// 

#import "AgnesCommands.h"

@implementation AgnesCommands

static NSDictionary *commandsDict;
static NSDictionary *supportDict;

+ (void)initCommands {
    commandsDict = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInt:RPL_ISUPPORT], 
        @"005",
        [NSNumber numberWithInt:RPL_ENDOFMOTD], 
        @"376",
        [NSNumber numberWithInt:CMD_PRIVMSG],
        @"PRIVMSG",
        [NSNumber numberWithInt:CMD_NICK],
        @"NICK",
    nil];
    supportDict = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInt:IS_PREFIX],
        @"PREFIX",
    nil];
}

+ (serverResponse)getCommand:(NSString *)cmd {
    // commands not yet initialized.
    if (commandsDict == nil)
        [AgnesCommands initCommands];
    
    // found a match
    serverResponse res = (serverResponse)[[commandsDict objectForKey:cmd] intValue];
    if (res) return res;
    
    // no match
    return -1;
}

+ (serverSupport)getSupport:(NSString *)name {
    // support not yet initialized.
    if (supportDict == nil)
        [AgnesCommands initCommands];
    
    // found a match
    serverSupport res = (serverSupport)[[supportDict objectForKey:name] intValue];
    if (res) return res;
    
    // no match
    return -1;
}


@end
