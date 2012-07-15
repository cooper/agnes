//
//  AgnesManager.m
//  Mixtape
//
//  Created by Mitchell Cooper on 7/8/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesManager-and-delegate
//

#import "AgnesManager.h"

@implementation AgnesManager

int cId = 0;

@synthesize delegate, connectionDelegate, defaultNick, defaultUser, defaultReal;

- (id)initWithDelegate:(id<AgnesManagerDelegate>)del {
    self = [super init];
    if (self) {
        delegate = del;
        connectionDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// connection with default identity.
- (AgnesConnection *)createConnection:(NSString *)address port:(UInt16)port ssl:(BOOL)ssl {
    AgnesConnection *conn = [[AgnesConnection alloc] initWithDelegate:connectionDelegate];
    conn.address  = address;
    conn.port     = port;
    conn.ssl      = ssl;
    conn.nickname = defaultNick;
    conn.username = defaultUser;
    conn.realname = defaultReal;
    [self addConnection:conn];
    return conn;
}

// connection with custom identity.
- (AgnesConnection *)createConnection:(NSString *)address port:(UInt16)port ssl:(BOOL)ssl
                    nick:(NSString *)nick user:(NSString *)user real:(NSString *)real {
    AgnesConnection *conn = [[AgnesConnection alloc] initWithDelegate:connectionDelegate];
    conn.address  = address;
    conn.port     = port;
    conn.ssl      = ssl;
    conn.nickname = nick;
    conn.username = user;
    conn.realname = real;
    [self addConnection:conn];
    return conn;
}

// add a connection to the manager.
- (void)addConnection:(AgnesConnection *)conn {
    [connectionDict setObject:conn forKey:[NSNumber numberWithInt:(++cId)]];
    conn.manager = self;
}

/* sent by the connection. */

- (void)createConnectionSession:(AgnesConnection *)conn {
    if ([delegate respondsToSelector:@selector(manager:shouldCreateSessionForConnection:)])
        [delegate manager:self shouldCreateSessionForConnection:conn];
}

- (void)showConnectionError:(AgnesConnection *)conn error:(NSError *)err {
    if ([delegate respondsToSelector:@selector(manager:shouldShowError:forConnection:)])
        [delegate manager:self shouldShowError:err forConnection:conn];
}

@end
