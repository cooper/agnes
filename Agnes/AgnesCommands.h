//
//  AgnesCommands.h
//  AgnesTypes.h
//  Mixtape
//
//  Created by Mitchell Cooper on 7/7/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//  Created by Diego Massanti on 7/8/12.
//  Copyright (c) 2012 SaferTaxi. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesCommands
// 

#import <Foundation/Foundation.h>

typedef enum _serverResponse {
    RPL_ENDOFMOTD = 374,
    CMD_PRIVMSG,
    CMD_NICK
} serverResponse;

@interface AgnesCommands : NSObject 

+ (void)initCommands;
+ (serverResponse)getCommand:(NSString *)cmd;

@end
