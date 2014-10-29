//
//  FBSession+User.h
//  Grnvote
//
//  Created by Benedikt Lotter on 4/25/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

@interface FBSession (User)

@property (nonatomic, retain) id<FBGraphUser> activeUser;

@end
