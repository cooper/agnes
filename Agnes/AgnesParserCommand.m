//
//  AgnesParserCommand.m
//  Mixtape
//
//  Created by Mitchell Cooper on 7/8/12.
//  Copyright (c) 2012 mac-mini.org. All rights reserved.
//
// Documentation: https://github.com/cooper/mixtape/wiki/AgnesParserCommand
///

#import "AgnesParserCommand.h"

@implementation AgnesParserCommand

@synthesize connection, user, channel, dataLine, arguments, realArguments, targetIsMe;

- (id)initWithLine:(NSString *)line {
    self = [super init];
    if (self) {
        dataLine      = line;
        realArguments = [line componentsSeparatedByString:@" "];
        arguments     = [AgnesParserCommand parseArguments:realArguments];
        targetIsMe    = NO;
    }
    return self;
}

- (NSString *)last {
    return [arguments lastObject];
}

- (NSString *)lastReal {
    return [realArguments lastObject];
}

- (NSString *)nth:(int)n {
    return [arguments objectAtIndex:n];
}

- (NSString *)nthReal:(int)n {
    return [realArguments objectAtIndex:n];
}

// parse an array of arguments into IRC-style arguments.
+ (NSArray *)parseArguments:(NSArray *)args {
    NSMutableArray *final = [[NSMutableArray alloc] init];
    int i = -1;
    for (NSString* arg in args) {
        i++;
        
        // first argument.
        if (i == 0) {
            [final addObject:[arg substringWithRange:NSMakeRange(1, arg.length-1)]];
            continue;
        }

        // multiple spaces in a row.
        if ([arg isEqualToString:@""])
            continue;

        // final argument.
        if ([arg hasPrefix:@":"]) {
            NSString *lastArg = [[args subarrayWithRange:NSMakeRange(i, args.count-i)] componentsJoinedByString:@" "];
            [final addObject:[lastArg substringWithRange:NSMakeRange(1, lastArg.length-1)]];
            break;
        }
        
        // regular old argument.
        [final addObject:arg];
    }
    return final;
}

@end
