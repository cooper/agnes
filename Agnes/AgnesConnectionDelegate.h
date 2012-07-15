//
//  AgnesConnectionDelegate.h
//  Mixtape
//
//  Created by Mitchell Cooper on 7/1/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesConnection
//

#import <Foundation/Foundation.h>

@class AgnesConnection;

// this protocol is to be implemented by the client using Agnes.
// the class implementing it will receive message describing connection-specific events.
// all methods are optional.

@protocol AgnesConnectionDelegate <NSObject>

@optional

- (void)connectionDidConnect:(AgnesConnection *)connection;
- (void)connectionDidCompleteHandshake:(AgnesConnection *)connection;
- (void)connection:(AgnesConnection *)connection didFailConnectWithError:(NSError *)err;
- (void)connection:(AgnesConnection *)connection didReceiveLine:(NSString *)line;
- (void)connection:(AgnesConnection *)connection willChangeServerName:(NSString *)name;

@end
