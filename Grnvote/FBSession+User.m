//
//  FBSession+User.m
//  Grnvote
//
//  Created by Benedikt Lotter on 4/25/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import "FBSession+User.h"

@implementation FBSession (User)

#pragma mark - Fields

id<FBGraphUser> _activeUser;

@dynamic activeUser;

#pragma mark - API

- (void) setActiveUser:(id<FBGraphUser>)activeUser {
    [_activeUser release];
    _activeUser = nil;
    _activeUser = [activeUser retain];
}

- (id<FBGraphUser>) activeUser {
    return _activeUser;
}

@end
