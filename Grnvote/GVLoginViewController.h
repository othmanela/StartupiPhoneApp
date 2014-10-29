//
//  GVViewController.h
//  Grnvote
//
//  Created by Benedikt Lotter on 4/20/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GVLoginViewController : UIViewController<FBLoginViewDelegate, CLLocationManagerDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (retain, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (retain, nonatomic) IBOutlet UIImageView *logoView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) FBLoginView *loginView;

@property (retain, nonatomic) NSMutableData *connectionData;

- (IBAction)didTapLogin:(id)sender;

@end
