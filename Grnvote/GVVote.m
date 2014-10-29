//
//  GVVote.m
//  Grnvote
//
//  Created by Benedikt Lotter on 4/20/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import "GVVote.h"

@implementation GVVote

- (void) dealloc {
    
    [_location release];
    [_user release];
    [super dealloc];
}

@end
