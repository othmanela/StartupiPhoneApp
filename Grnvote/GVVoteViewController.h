//
//  GVVoteViewController.h
//  Grnvote
//
//  Created by Benedikt Lotter on 4/20/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVLocation.h"

@interface GVVoteViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *hotButton;
@property (retain, nonatomic) IBOutlet UIButton *okButton;
@property (retain, nonatomic) IBOutlet UIButton *coldButton;
@property (retain, nonatomic) IBOutlet UIButton *shareButton;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) GVLocation *location;

- (id) initWithLocation:(GVLocation*)location;

- (IBAction) didTapValueButton:(id)sender;
- (IBAction)didTapShareButton:(id)sender;

@end
