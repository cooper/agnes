//
//  AgnesCore.m
//  AgnesCore
//
//  Created by Mitchell Cooper on 6/30/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//

#import "AgnesCore.h"
#import "AgnesParser.h"

@implementation AgnesCore

+ (void)prepare {
    [AgnesParser installDefaults];
}

@end
