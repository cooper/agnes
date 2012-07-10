//
//  AgnesParserCommand.h
//  Mixtape
//
//  Created by Mitchell Cooper on 7/8/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesParserCommand
///

#import <Foundation/Foundation.h>
#import "AgnesUser.h"
#import "AgnesChannel.h"

@interface AgnesParserCommand : NSObject

@property (readonly) NSString *dataLine;     /* the line of data received from the server */
@property (readonly) NSArray *realArguments; /* space-separated data, just as from server */
@property (readonly) NSArray *arguments;     /* parsed as IRC-style arguments             */
@property AgnesUser *user;                   /* parser will insert an AgnesUser object    */
@property AgnesChannel *channel;             /* parser will insert an AgnesChannel object */
@property BOOL targetIsMe;                   /* true if the command is aimed at this user */

+ (NSArray *)parseArguments:(NSArray *)args;

- (id)initWithLine:(NSString *)line;

- (NSString *)last;                          /* get the last IRC-style argument  */
- (NSString *)nth:(int)n;                    /* get the (n)th IRC-style argument */
- (NSString *)lastReal;                      /* get last real argument           */
- (NSString *)nthReal:(int)n;                /* get the (n)th real argument      */

@end
