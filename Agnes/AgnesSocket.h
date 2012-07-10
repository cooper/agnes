//
//  AgnesSocket.h
//  Mixtape
//
//  Created by Mitchell Cooper on 6/30/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesSocket
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@class AgnesConnection;

@interface AgnesSocket : NSObject {
    AsyncSocket *socket;
}

@property AgnesConnection *delegate;
@property NSString *address;
@property UInt16 port;

- (id)initWithDelegate:(AgnesConnection *)del;
- (void)connect:(BOOL)ssl;
- (void)sendLine:(NSString *)line;

@end
