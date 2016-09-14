//
//  FocusViewController.h
//  ZJUBTV
//
//  Created by GreysTone on 5/21/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@import CoreLocation;

#import "ProgramItem.h"


@interface FocusViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;


@property (weak, nonatomic) IBOutlet UITableView *FocusTable;

@property (strong, nonatomic) NSMutableArray *nearbyData;
@property (strong, nonatomic) NSMutableArray *focusData;

@end
