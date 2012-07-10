//
//  AgnesManagerDelegate.h
//  Mixtape
//
//  Created by Mitchell Cooper on 7/8/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesManager-and-delegate
//

#import <Foundation/Foundation.h>
#import "AgnesManager.h"
#import "AgnesConnection.h"

@protocol AgnesManagerDelegate <NSObject>

@optional

- (void)createConnectionSession:(AgnesManager *)manager connection:(AgnesConnection *)conn;
- (void)showConnectionError:(AgnesManager *)manager connection:(AgnesConnection *)conn error:(NSError *)err;

@end
