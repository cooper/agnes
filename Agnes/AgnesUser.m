//
//  AgnesUser.m
//  Mixtape
//
//  Created by Mitchell Cooper on 7/9/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesUser
//

#import "AgnesUser.h"

@implementation AgnesUser

@synthesize session, identifier, connection, realname, nickname, username, hostname, cloak;

- (NSString *)description {
    return [NSString stringWithFormat:@"<AgnesUser: %p (%ld)>", self, identifier];
}

@end
