//
//  GVViewController.m
//  Grnvote
//
//  Created by Benedikt Lotter on 4/20/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import "GVLoginViewController.h"
#import "GVLocationViewController.h"

@interface GVLoginViewController ()

- (void) locatePlaces;

@end

@implementation GVLoginViewController

#pragma mark - Constructor

- (void)dealloc {
    
    [_logoView release];
    [_loginView release];
    [_connectionData release];
    [_locationManager release];
    [_activityIndicator release];
    [_copyrightLabel release];
    [super dealloc];
}

#pragma mark - API

- (void)viewDidLoad {
    
    //
    //  Prepare UI
    
    self.activityIndicator.alpha = 0.0f;
    self.copyrightLabel.font = [UIFont fontWithName:@"BlenderPro-Book" size:12.0f];
    
    //
    //  Create Login View so that the app will be granted "status_update" permission.
    
    self.loginView = [[[FBLoginView alloc] init] autorelease];
    self.loginView.frame = CGRectOffset(self.loginView.frame, self.view.frame.size.width / 2 -
                                   self.loginView.frame.size.width / 2, self.view.frame.size.height / 3);
    self.loginView.delegate = self;
    self.loginView.publishPermissions = @[@"publish_actions"];
    self.loginView.defaultAudience = FBSessionDefaultAudienceFriends;
    
    [self.view addSubview:self.loginView];
    
    [self.loginView sizeToFit];
    
    //
    //  Prepare Location Manager
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;

    [super viewDidLoad];
}

- (void)viewDidUnload {
    
    [self setLogoView:nil];
    [self setActivityIndicator:nil];
    [self setCopyrightLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Methods

- (void) locatePlaces {
    
    //
    //  Show network indicator
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.loginView setUserInteractionEnabled:NO];
    
    //
    //  Start determining location
    
    [self.locationManager startUpdatingLocation];
    
    //
    //  Start activity indicator
    
    [self.activityIndicator startAnimating];
    
    //
    //  Hide UI
    
    [UIView beginAnimations:@"loginAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75f];
    
    [self.logoView setCenter:CGPointMake(self.view.center.x, self.view.center.y * 0.75f)];
    [self.activityIndicator setAlpha:1.0f];
    [self.loginView setAlpha:0.0f];
    [self.loginView setFrame:CGRectOffset(self.loginView.frame, 0.0f, 75.0f)];
    
    [UIView commitAnimations];
}

#pragma mark - Events

- (IBAction) didTapLogin:(id)sender {
    
    //
    //  Not used
}

#pragma mark - Location Manager Delegate

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    //
    //  Stop location services
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
    
    //
    //  Query "pennstudyplaces.com" for available rooms
    
    NSURL *queryURL = [NSURL URLWithString:@"http://pennstudyspaces.com/api?capacity=1&shr=20&smin=15&ehr=21&emin=15&date=1366344000000&format=json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:queryURL];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (connection) {
        self.connectionData = [NSMutableData data];
        [connection start];
    }
}

#pragma mark - NSURLConnection Delegate

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.connectionData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSDictionary *result = [self.connectionData objectFromJSONData];
    
    //
    //  Stop animating
    
    [self.activityIndicator stopAnimating];
    
    //
    //  Unregister delegates
    
    [self.loginView setDelegate:nil];
    
    //
    //  Hide network indicator
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //
    //  Show GVVoteViewController
    
    GVLocationViewController *controller = [[GVLocationViewController alloc] initWithBuildings:result];
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

#pragma mark - FBLoginViewDelegate

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"loginViewShowingLoggedInUser: %@", loginView);
}

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    
    if (user) {
        
        //
        //  Remember active user
        
        [[FBSession activeSession] setActiveUser:user];
        
        //
        //  Locate the device and load places around
        
        [self locatePlaces];
    }
}

- (void) loginView:(FBLoginView *)loginView :(NSError *)error {
    NSLog(@"loginView: %@ handleError: %@", loginView, [error localizedDescription]);
}

@end
