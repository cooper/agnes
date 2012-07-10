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

- (void)onConnectionEstablished:(AgnesConnection *)connection;
- (void)onConnectionError:(AgnesConnection *)connection error:(NSError *)err;
- (void)onSSLHandshakeComplete:(AgnesConnection *)connection;
- (void)onRawLine:(AgnesConnection *)connection line:(NSString *)line;

@end
