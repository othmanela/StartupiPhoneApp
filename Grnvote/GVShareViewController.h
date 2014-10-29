//
//  GVShareViewController.h
//  Grnvote
//
//  Created by Benedikt Lotter on 4/25/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GVShareViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextView *postMessage;

- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapPost:(id)sender;

- (id) initWithInitialText:(NSString*)initialText;

@end
