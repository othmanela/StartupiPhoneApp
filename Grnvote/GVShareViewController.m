//
//  GVShareViewController.m
//  Grnvote
//
//  Created by Benedikt Lotter on 4/25/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import "GVShareViewController.h"

@interface GVShareViewController ()

@property (nonatomic, retain) NSString *initialText;
@property (nonatomic, retain) NSMutableDictionary *postParams;

@end

@implementation GVShareViewController

#pragma mark - Constructor

- (id) initWithInitialText:(NSString*)initialText {
    self = [super initWithNibName:@"GVShareViewController" bundle:nil];

    if (self) {
        self.initialText = initialText;
        self.postParams = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)dealloc {
    [_postParams release];
    [_initialText release];
    [_postMessage release];
    [super dealloc];
}

#pragma mark - View Lifecycle

- (void) viewDidLoad {
    
    self.postMessage.text = self.initialText;
    self.postMessage.font = [UIFont fontWithName:@"BlenderPro-Book" size:14.0f];
    
    [super viewDidLoad];
}

- (void) viewDidUnload {
    
    [self setPostMessage:nil];
    [super viewDidUnload];
}

#pragma mark - Methods

- (IBAction)didTapCancel:(id)sender {
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)didTapPost:(id)sender {
 
    //
    //  Hide keyboard if showing when button clicked
    
    if ([self.postMessage isFirstResponder]) {
        [self.postMessage resignFirstResponder];
    }
    
    //
    //  Add user message parameter if user filled it in
    
    if (![self.postMessage.text isEqualToString:@""]) {
        [self.postParams setObject:self.postMessage.text forKey:@"message"];
    }
    
    //
    //  Ask for 'publish_actions' permissions in context
    
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {

        [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
            
            if (!error) {
                [self publishStory];
            }
        }];
    }
    else {
        [self publishStory];
    }
}

- (void) publishStory {
    
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:self.postParams HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        NSString *alertText;
        
        if (error) {
            alertText = [NSString stringWithFormat:@"error: domain = %@, code = %d", error.domain, error.code];
        }
        else {
             alertText = @"Posted successfully.";
        }
        
        //
        //  Show the result in an alert

        [[[[UIAlertView alloc] initWithTitle:@"Result" message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        
    }];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

@end
