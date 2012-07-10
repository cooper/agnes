//
//  AgnesParser.h
//  Mixtape
//
//  Created by Mitchell Cooper on 7/7/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesParser
//

#import <Foundation/Foundation.h>
#import "AgnesConnection.h"

@interface AgnesParser : NSObject

@property AgnesConnection *connection;

- (id)initWithConnection:(AgnesConnection *)conn;
- (void)parseLine:(NSString *)line;

@end
