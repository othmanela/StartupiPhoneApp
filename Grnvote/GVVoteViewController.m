//
//  GVVoteViewController.m
//  Grnvote
//
//  Created by Benedikt Lotter on 4/20/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import "GVVoteViewController.h"
#import "GVVote.h"

#import "GVShareViewController.h"

@interface GVVoteViewController ()

@property (nonatomic, retain) GVVote *lastVote;

- (void) submitVote:(GVVote*)vote;
- (void) didStopAnimating:(id)sender;

@end

@implementation GVVoteViewController

#pragma mark - Constructor

- (id) initWithLocation:(GVLocation*)location {
    
    self = [super initWithNibName:@"GVVoteViewController" bundle:nil];
    if (self) {
        self.location = location;
    }
    return self;
}

- (void)dealloc {
    
    [_lastVote release];
    [_location release];
    [_titleLabel release];
    [_hotButton release];
    [_okButton release];
    [_coldButton release];
    [_shareButton release];
    [super dealloc];
}

#pragma mark - View Lifecycle

- (void) viewDidLoad {
    
    //
    //  Prepare UI
    
    self.titleLabel.font = [UIFont fontWithName:@"BlenderPro-Book" size:30.0f];
    self.shareButton.alpha = 0.0f;
    
    [super viewDidLoad];
}

- (void) viewDidUnload {
    
    [self setTitleLabel:nil];
    [self setHotButton:nil];
    [self setOkButton:nil];
    [self setColdButton:nil];
    [self setShareButton:nil];
    [super viewDidUnload];
}

#pragma mark - Events

- (void) buttonClicked: (id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://ec2-54-214-85-226.us-west-2.compute.amazonaws.com:8080"]];
}

- (IBAction) didTapValueButton:(id)sender {
    
    CGFloat yOffsetHot = self.view.frame.size.height;
    CGFloat yOffsetOk = self.view.frame.size.height;
    CGFloat yOffsetCold = self.view.frame.size.height;
    
    GVUser *user = [[GVUser alloc] init];
    user.uid = [[UIDevice currentDevice] name];
    
    GVVote *vote = [[GVVote alloc] init];
    vote.location = self.location;
    vote.user = user;
    
    [user release];
    
    if ([sender isEqual:self.hotButton]) {
        vote.value = VOTE_HOT;
        yOffsetHot -= 140.0f;
    }
    else if ([sender isEqual:self.okButton]) {
        vote.value = VOTE_OK;
        yOffsetOk -= 140.0f;
    }
    else if ([sender isEqual:self.coldButton]) {
        vote.value = VOTE_COLD;
        yOffsetCold -= 140.0f;
    }
    
    self.lastVote = vote;
    
//    
//  Server not available
    
//    [self submitVote:vote];
    
    [vote release];
    
    [UIView beginAnimations:@"voteAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didStopAnimating:)];
    
    [self.hotButton setFrame:CGRectOffset(self.hotButton.frame, 0.0f, yOffsetHot)];
    [self.okButton setFrame:CGRectOffset(self.okButton.frame, 0.0f, yOffsetOk)];
    [self.coldButton setFrame:CGRectOffset(self.coldButton.frame, 0.0f, yOffsetCold)];
    
    [self.hotButton setAlpha:0.0f];
    [self.okButton setAlpha:0.0f];
    [self.coldButton setAlpha:0.0f];
    
    [self.titleLabel setText:[NSString stringWithFormat:@"Thanks for your vote %@!", [[FBSession activeSession] activeUser].first_name]];
    
    [UIView commitAnimations];
    
    //
    //additional webview for vote chart
    
    UILabel *myLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 300, 40)];
    [myLabel2 setBackgroundColor:[UIColor clearColor]];
    [myLabel2 setTextColor:[UIColor whiteColor]];
    [myLabel2 setTextAlignment:UITextAlignmentCenter];
    
    [myLabel2 setFont:[UIFont fontWithName:@"American Typewriter" size:18]];
    
    [myLabel2 setText:@"Look at what other people voted:"];
    [[self view] addSubview:myLabel2];
    [myLabel2 release];
    
    CGRect buttonFrame = CGRectMake( 80, 210, 160, 40 );
    UIButton *button = [[UIButton alloc] initWithFrame: buttonFrame];
    [button setTitle: @"Click here!" forState: UIControlStateNormal];
    [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    [button addTarget: self
               action: @selector(buttonClicked:)
     forControlEvents: UIControlEventTouchDown];
    [[self view] addSubview: button];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://ec2-54-214-85-226.us-west-2.compute.amazonaws.com:8080"]];
}

- (IBAction) didTapShareButton:(id)sender {

    NSString *voteValueString = self.lastVote.value == VOTE_COLD ? @"cold" : (self.lastVote.value == VOTE_HOT ? @"hot" : @"ok");
    NSString *voteLocationString = self.lastVote.location.fullName;
    NSString *voteShareText = [NSString stringWithFormat:@"I think it's %@ in %@!", voteValueString, voteLocationString];
    
    BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self initialText:voteShareText image:nil url:nil handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
        
        //
        //  Do not handle error 7 yet ('Dialog not supported')
        
        if (error && [error code] == 7) {
            NSLog(@"Facebook sharing is not available!");
            return;
        }
        
        NSString *alertText = @"";
        if (error) {
            alertText = [NSString stringWithFormat:@"error: domain = %@, code = %d", error.domain, error.code];
        }
        else if (result == FBNativeDialogResultSucceeded) {
            alertText = @"Posted successfully.";
        }
        
        if (![alertText isEqualToString:@""]) {
            [[[[UIAlertView alloc] initWithTitle:@"Result" message:alertText delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil] autorelease] show];
        }
    }];
    
    if (!displayedNativeDialog) {
        
        GVShareViewController *viewController = [[GVShareViewController alloc] initWithInitialText:voteShareText];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

#pragma mark - Methods

- (void) submitVote:(GVVote *)vote {
    
    NSMutableDictionary *rawLocation = [NSMutableDictionary dictionary];
    [rawLocation setValue:[NSNumber numberWithFloat:vote.location.latitude] forKey:@"latitude"];
    [rawLocation setValue:[NSNumber numberWithFloat:vote.location.longitude] forKey:@"longitude"];
    [rawLocation setValue:[NSNumber numberWithFloat:vote.location.altitude] forKey:@"altitude"];
    
    NSMutableDictionary *rawUser = [NSMutableDictionary dictionary];
    [rawUser setValue:vote.user.uid forKey:@"uid"];
    
    NSMutableDictionary *rawVote = [NSMutableDictionary dictionary];
    [rawVote setValue:rawLocation forKey:@"location"];
    [rawVote setValue:rawUser forKey:@"user"];
    [rawVote setValue:[NSNumber numberWithInt:vote.value] forKey:@"value"];
    
    NSURL *url = [NSURL URLWithString:@"http://130.91.127.208:8080/GreenvoteServer/votes/vote"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[rawVote JSONData]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error)
        NSLog(@"ERROR: %@", [error localizedDescription]);
    
    if (response)
        NSLog(@"RESPONSE: %@", response);
    
    NSLog(@"RESPONSE: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
}

- (void) didStopAnimating:(id)sender {
        
    [UIView beginAnimations:@"voteAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];

    [self.shareButton setAlpha:1.0f];
    
    [UIView commitAnimations];
}

@end
