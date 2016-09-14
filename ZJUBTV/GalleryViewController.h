//
//  GalleryViewController.h
//  ZJUBTV
//
//  Created by GreysTone on 5/21/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"

#import "GalleryBarButtonItem.h"
#import "ProgramItem.h"

@interface GalleryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet GalleryBarButtonItem *ToolbarButton_Hot;
@property (weak, nonatomic) IBOutlet GalleryBarButtonItem *ToolbarButton_News;
@property (weak, nonatomic) IBOutlet GalleryBarButtonItem *ToolbarButton_Broadcast;
@property (weak, nonatomic) IBOutlet GalleryBarButtonItem *ToolbarButton_Program;

@property (weak, nonatomic) IBOutlet UITableView *GalleryTable;
@property (strong, nonatomic) NSMutableArray *tableData;




- (void) getInformationFromServerWithUrl:(NSString *)accessUrl sender:(NSString *)sender;
- (void) loadNetworkAccessWithDictionary:(NSDictionary *)list listType:(NSString*)type;

@end
