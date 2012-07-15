//
//  AgnesUser.h
//  Mixtape
//
//  Created by Mitchell Cooper on 7/9/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesUser
//

#import <Foundation/Foundation.h>

@class AgnesUser;

@interface AgnesUser : NSObject

@property NSString *nickname;
@property NSString *username;
@property NSString *realname;
@property NSString *hostname;
@property NSString *cloak;
@property (readonly) NSUInteger identifier;
@property id connection;
@property id session;

@end
