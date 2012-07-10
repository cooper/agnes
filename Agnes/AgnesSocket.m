//
//  AgnesSocket.m
//  Mixtape
//
//  Created by Mitchell Cooper on 6/30/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesSocket
//

#import "AgnesSocket.h"
#import "AgnesConnection.h"

@implementation AgnesSocket

@synthesize address, port, delegate;

- (id)initWithDelegate:(id)del
{
    self = [super init];
    if (self) {
        socket = [[AsyncSocket alloc] initWithDelegate:self];
        delegate = del;
    }
    return self;
}

- (id)initWithAddress:(NSString *)addr onPort:(UInt16)prt {
    self = [self init];
    address = addr;
    port = prt;
    return self;
}

- (void)connect:(BOOL)ssl {
	[socket connectToHost:address onPort:port error:nil];
    if (ssl) [socket startTLS:nil];
}

- (void)sendLine:(NSString *)line {
    line = [line stringByAppendingString:@"\r\n"];
    NSData *data = [line dataUsingEncoding:NSUTF8StringEncoding];
    [socket writeData:data withTimeout:-1 tag:1];
}

- (void)read {
	[socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
	//NSLog(@"Disconnecting. Error: %@", [err localizedDescription]);
    [delegate onConnectionError:err];    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
	//NSLog(@"Disconnected.");
    
	[socket setDelegate:nil];
	//[socket release];
	socket = nil;
}

- (BOOL)onSocketWillConnect:(AsyncSocket *)sock {
	//NSLog(@"onSocketWillConnect:");
	return YES;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)prt {
	//NSLog(@"Connected To %@:%i.", host, prt);
    [delegate onConnectionEstablished];
	[self read];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	NSString *string = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    
    // nothing; try again...
    if (string == NULL) {
        [self read];
        return;
    }
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    [delegate onRawLine:string];
	//NSLog(@"recv: %@", string);
    //NSLog(@"reading more");
	[self read];
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(CFIndex)partialLength tag:(long)tag {
	//NSLog(@"onSocket:didReadPartialDataOfLength:%ld tag:%ld", partialLength, tag);
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	//NSLog(@"onSocket:didWriteDataWithTag:%ld", tag);
}

// SSL connection established
- (void)onSocketDidSecure:(AsyncSocket *)sock {
    [delegate onSSLHandshakeComplete];
}

@end
