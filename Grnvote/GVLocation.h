//
//  GVLocation.h
//  Grnvote
//
//  Created by Benedikt Lotter on 4/20/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVLocation : NSObject

@property (nonatomic, retain) NSString *fullName;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) float altitude;

@end
