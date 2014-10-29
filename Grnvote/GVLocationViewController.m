//
//  GVVoteViewController.m
//  Grnvote
//
//  Created by Benedikt Lotter on 4/20/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import "GVLocationViewController.h"
#import "GVVoteViewController.h"

typedef NS_ENUM(NSInteger, GVLocationStep) {
    GVLocationStepBuilding,
    GVLocationStepRoom
};

@interface GVLocationViewController ()

@property (nonatomic) GVLocationStep currentStep;
@property (nonatomic) NSInteger selectedBuilding;

- (NSArray*) roomsForBuilding:(NSInteger)index;

@end

@implementation GVLocationViewController

#pragma mark - Constructor

- (id) initWithBuildings:(NSDictionary*)dict {
    
    self = [super initWithNibName:@"GVLocationViewController" bundle:nil];
    if (self) {
        self.buildings = dict;
        self.currentStep = GVLocationStepBuilding;
    }
    return self;
}

- (void) dealloc {
    
    [_buildings release];
    [_locationTable release];
    [_mapView release];
    [_backButton release];
    [_logoView release];
    [super dealloc];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    //
    //  Prepare UI
    
    self.locationTable.backgroundColor = [UIColor colorWithWhite:25.0f/255.0f alpha:1.0f];
    self.locationTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.locationTable.separatorColor = [UIColor blackColor];

    self.logoView.clipsToBounds = NO;
    self.logoView.frame = CGRectMake(0.0f, -62.0f, 320.0f, 0.0f);
    
    self.locationTable.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.locationTable.layer.shadowRadius = 2.0f;

    self.backButton.transform = CGAffineTransformMakeRotation(M_PI);
    self.backButton.frame = CGRectMake(-60.0f, 25.0f, 50.0f, 50.0f);

    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [self.locationTable addSubview:self.logoView];
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setLocationTable:nil];
    [self setMapView:nil];
    [self setBackButton:nil];
    [self setLogoView:nil];
    [super viewDidUnload];
}

#pragma mark - Methods

- (NSArray*) roomsForBuilding:(NSInteger)index {
    
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *buildings = [self.buildings objectForKey:@"buildings"];
    NSDictionary *building = [buildings objectAtIndex:index];
    NSArray *roomkinds = [building objectForKey:@"roomkinds"];
    if (roomkinds) {
        for (NSDictionary *roomkind in roomkinds) {
            NSArray *rooms = [roomkind objectForKey:@"rooms"];
            [result addObjectsFromArray:rooms];
        }
    }
    
    return result;
}

- (IBAction) didTapBackButton:(id)sender {

    if (self.currentStep == GVLocationStepRoom) {
    
        [UIView beginAnimations:@"backButtonAnimation" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        
        self.backButton.transform = CGAffineTransformMakeRotation(M_PI);
        self.backButton.frame = CGRectMake(-60.0f, 25.0f, 50.0f, 50.0f);
        
        [UIView commitAnimations];
        
        self.selectedBuilding = -1;
        self.currentStep = GVLocationStepBuilding;
        
        [self.locationTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark - UITableView Delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.currentStep == GVLocationStepBuilding)
        return [[self.buildings objectForKey:@"buildings"] count];
    else
        return [[self roomsForBuilding:self.selectedBuilding] count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont fontWithName:@"BlenderPro-Book" size:24.0f];
    }
    
    if (self.currentStep == GVLocationStepBuilding) {
    
        NSDictionary *building = [[self.buildings objectForKey:@"buildings"] objectAtIndex:indexPath.row];
        if (building) {
            
            NSInteger roomCount = [[self roomsForBuilding:indexPath.row] count];
            
            cell.textLabel.text = [building objectForKey:@"name"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Rooms", roomCount];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (self.currentStep == GVLocationStepRoom) {
        
        NSDictionary *room = [[self roomsForBuilding:self.selectedBuilding] objectAtIndex:indexPath.row];
        cell.textLabel.text = [room objectForKey:@"name"];
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.currentStep == GVLocationStepBuilding)
        return 80.0f;
    else
        return 50.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.currentStep == GVLocationStepRoom) {
        
        //
        //  Call GVVoteViewController
        
        NSDictionary *room = [[self roomsForBuilding:self.selectedBuilding] objectAtIndex:indexPath.row];
        NSDictionary *building = [[self.buildings objectForKey:@"buildings"] objectAtIndex:self.selectedBuilding];
        
        GVLocation *location = [[GVLocation alloc] init];
        location.longitude = [[building objectForKey:@"longitude"] floatValue];
        location.latitude = [[building objectForKey:@"latitude"] floatValue];
        location.altitude = 0.0f;
        location.fullName = [NSString stringWithFormat:@"%@ - %@", [building objectForKey:@"name"], [room objectForKey:@"name"]];
        
        GVVoteViewController *controller = [[GVVoteViewController alloc] initWithLocation:location];
        [self presentModalViewController:controller animated:YES];
        [controller release];
        [location release];
    }
    else if (self.currentStep == GVLocationStepBuilding) {
    
        [UIView beginAnimations:@"backButtonAnimation" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        
        self.backButton.transform = CGAffineTransformMakeRotation(0.0f);
        self.backButton.frame = CGRectMake(10.0f, 25.0f, 50.0f, 50.0f);
        
        [UIView commitAnimations];
        
        self.selectedBuilding = indexPath.row;
        self.currentStep = GVLocationStepRoom;
    
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        float alpha = MIN(1.0f, (-scrollView.contentOffset.y) / 125.0f);
        self.logoView.alpha = alpha;
    }
}

@end
