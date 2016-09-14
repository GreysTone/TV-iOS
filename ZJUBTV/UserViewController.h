//
//  UserViewController.h
//  ZJUBTV
//
//  Created by GreysTone on 5/21/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *UserTable;
@property (strong, nonatomic) NSMutableArray *userData;

@property bool isLogin;

@end
