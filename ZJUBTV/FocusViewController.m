//
//  FocusViewController.m
//  ZJUBTV
//
//  Created by GreysTone on 5/21/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "FocusViewController.h"

static NSString * const BaseURLString =@"https://api.zjubtv.com/";
static NSString * const BaseSiteURLString = @"http://www.zjubtv.com/";

@interface FocusViewController ()

@end

@implementation FocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.FocusTable.delegate = self;
    self.FocusTable.dataSource = self;
    self.focusData = [[NSMutableArray alloc] init];
    self.nearbyData = [[NSMutableArray alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [[self locationManager] setDelegate:self];
    
    // we have to setup the location maanager with permission in later iOS versions
    if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    [[self locationManager] startUpdatingLocation];
    
//    if ([CLLocationManager locationServicesEnabled]) {

//    }else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"无法进行定位操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self locationManager] stopUpdatingLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = locations.lastObject;
    NSLog(@"la:%f, long:%f", location.coordinate.latitude, location.coordinate.longitude);
    
    // TODO: Get From Server
    
//    NSLog(@"j>la:%d",location.coordinate.latitude > 22.0f);
//    NSLog(@"j<la:%d",location.coordinate.latitude < 23.0f);
    
    if(location.coordinate.latitude > 22.0f && location.coordinate.latitude < 23.0f) {
        NSString *string = [[NSString stringWithString:BaseURLString] stringByAppendingString:@"Video/"];
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
            
            [self.nearbyData removeAllObjects];
            
            for (NSDictionary *tuple in responseObject) {
                ProgramItem *item = [[ProgramItem alloc] init];
                item.title = [tuple objectForKey:@"title"];
                item.subtitle = [tuple objectForKey:@"subtitle"];
                item.columnid = [tuple objectForKey:@"columnid"];
                item.coverid = [tuple objectForKey:@"cover"];
                item.createtime = [tuple objectForKey:@"createtime"];
                item.pid = [tuple objectForKey:@"id"];
                item.view = [tuple objectForKey:@"view"];
                NSDictionary *cover = [tuple objectForKey:@"cover_url"];
                NSString *path = [cover objectForKey:@"path"];
                item.coverpath = [path substringFromIndex:1];
//                NSLog(@"%@", item.title);
                
                [self.nearbyData addObject: item];
            }
            
            [self.FocusTable reloadData];

            
        } failure:^(AFHTTPRequestOperation *operation, NSError*error){
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Error Retrieving NearBy"
                                                               message:[error localizedDescription]
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil];
            [alertView show];
        }];
        
        [operation start];
    }
    
    [[self locationManager] stopUpdatingLocation];
    [self.FocusTable reloadData];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
        return [self.nearbyData count];
//    }
//    if (section == 1) {
//        return [self.focusData count];
//    }
//    return 0;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
////    if (section == 0) {
//        return @"附近的播放";
////    }
////    if (section == 1) {
////        return @"我的关注";
////    }
////    return @"";
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    声明静态字符串型对象，用来标记重用单元格
    static NSString *TableIdentifier = @"FocusTableIdentifier";
    //    用GalleryTableIdentifier表示需要重用的单元
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    //    如果如果没有多余单元，则需要创建新的单元
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TableIdentifier];
    }else {
        while ([cell.contentView.subviews lastObject ]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    
    //    获取当前行信息值
    NSUInteger row = [indexPath row];
    //  设置Style
    
    //    把数组中的值赋给单元格显示出来
    ProgramItem *item = [self.nearbyData objectAtIndex:row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subtitle;
    
    //    表视图单元提供的UILabel属性，设置字体大小
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    NSString *coverURL = [[NSString stringWithString:BaseSiteURLString] stringByAppendingString:item.coverpath];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:coverURL]]];
    cell.imageView.image=image;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    首先是用indexPath获取当前行的内容
    NSInteger row = [indexPath row];
    //    从数组中取出当前行内容
    ProgramItem* item = [self.nearbyData objectAtIndex:row];
    
    NSNumber* videoId = item.pid;
    NSString* api = @"Video/Detail?";
    NSString* accessUrl = [[NSString stringWithString:api] stringByAppendingFormat:@"%@", videoId];
    NSString *string = [[NSString stringWithString:BaseURLString] stringByAppendingString:accessUrl];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSString* targetURL = [[NSString alloc] initWithString:[responseObject objectForKey:@"local"]];
        NSURL *videoURL = [NSURL URLWithString:targetURL];
        
        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Error Retrieving Program"
                                                           message:[error localizedDescription]
                                                          delegate:nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
    
    
    //    DetailViewController* details = [[DetailViewController alloc] init];
    //    [self presentViewController:details animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
    
}


@end
