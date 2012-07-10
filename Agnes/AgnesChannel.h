//
//  AgnesChannel.h
//  Mixtape
//
//  Created by Mitchell Cooper on 7/9/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesChannel
// hello there.

#import <Foundation/Foundation.h>
#import "AgnesConnection.h"
#import "AgnesUser.h"

@interface AgnesChannel : NSObject

@property AgnesConnection *connection;
@property NSString *name;
@property (readonly) NSMutableArray *users;
@property id session;

- (BOOL)hasUser:(AgnesUser *)user;

@end
