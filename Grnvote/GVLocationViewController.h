//
//  GVVoteViewController.h
//  Grnvote
//
//  Created by Benedikt Lotter on 4/20/13.
//  Copyright (c) 2013 Greenvote Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GVLocationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSDictionary *buildings;
@property (retain, nonatomic) IBOutlet UITableView *locationTable;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UIImageView *logoView;

- (id) initWithBuildings:(NSDictionary*)dict;
- (IBAction) didTapBackButton:(id)sender;

@end
