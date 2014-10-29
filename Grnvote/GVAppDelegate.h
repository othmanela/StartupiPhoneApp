//
//  GVAppDelegate.h
//  Grnvote
//
//  Created by Benedikt Lotter on 4/20/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GVLoginViewController;

@interface GVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GVLoginViewController *viewController;

@end
