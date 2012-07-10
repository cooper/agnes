//
//  AgnesChannel.m
//  Mixtape
//
//  Created by Mitchell Cooper on 7/9/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesChannel
//

#import "AgnesChannel.h"

@implementation AgnesChannel

@synthesize connection, name, users;

- (BOOL)hasUser:(AgnesUser *)user {
    if ([users containsObject:user])
        return YES;
    return FALSE;
}

@end
