//
//  AgnesManagerDelegate.h
//  Mixtape
//
//  Created by Mitchell Cooper on 7/8/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesManager
//

#import <Foundation/Foundation.h>
#import "AgnesManager.h"
#import "AgnesConnection.h"

@protocol AgnesManagerDelegate <NSObject>

@optional

- (void)manager:(AgnesManager *)manager shouldCreateSessionForConnection:(AgnesConnection *)connection;
- (void)manager:(AgnesManager *)manager shouldShowError:(NSError *)error forConnection:(AgnesConnection *)connection;

@end
