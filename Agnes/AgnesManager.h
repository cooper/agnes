//
//  AgnesManager.h
//  Mixtape
//
//  Created by Mitchell Cooper on 7/8/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesManager-and-delegate
//

#import <Foundation/Foundation.h>
#import "AgnesManagerDelegate.h"
#import "AgnesConnectionDelegate.h"
#import "AgnesConnection.h"
#import "AgnesUser.h"

@class AgnesManager;

@interface AgnesManager : NSObject {
    NSMutableDictionary *connectionDict;
}

@property id<AgnesManagerDelegate> delegate;
@property id<AgnesConnectionDelegate> connectionDelegate;
@property NSString *defaultNick;
@property NSString *defaultUser;
@property NSString *defaultReal;

- (id)initWithDelegate:(id<AgnesManagerDelegate>)del;

// connect to address on port.
- (AgnesConnection *)createConnection:(NSString *)address port:(UInt16)port ssl:(BOOL)ssl;
// connect with unique identity settings.
- (AgnesConnection *)createConnection:(NSString *)address port:(UInt16)port ssl:(BOOL)ssl
                    nick:(NSString *)nick user:(NSString *)user real:(NSString *)real;
// add a connection to manager.
- (void)addConnection:(AgnesConnection *)conn;

// SENT BY AgnesConnection.
- (void)createConnectionSession:(AgnesConnection *)conn;
- (void)showConnectionError:(AgnesConnection *)conn error:(NSError *)err;

@end
