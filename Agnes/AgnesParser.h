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

@class AgnesParserCommand;
typedef void(^CommandCallback)(AgnesParserCommand *);

@interface AgnesParser : NSObject

+ (void)installDefaults;
+ (void)parseLine:(NSString *)line connection:(AgnesConnection *)conn;
+ (int)registerCommandHandler:(CommandCallback)callback forCommand:(NSString *)command;

@end