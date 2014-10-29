//
//  GVVote.h
//  Grnvote
//
//  Created by Benedikt Lotter on 4/20/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVLocation.h"
#import "GVUser.h"

#define VOTE_COLD -1
#define VOTE_HOT 1
#define VOTE_OK 0

@interface GVVote : NSObject

@property (nonatomic) NSInteger value;
@property (nonatomic, retain) GVLocation *location;
@property (nonatomic, retain) GVUser *user;

@end
