//
//  GalleryViewController.m
//  ZJUBTV
//
//  Created by GreysTone on 5/21/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "GalleryViewController.h"

static NSString * const BaseURLString = @"https://api.zjubtv.com/";
static NSString * const BaseSiteURLString = @"http://www.zjubtv.com/";

@interface GalleryViewController ()

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Banding TableView
    self.GalleryTable.dataSource = self;
    self.GalleryTable.delegate = self;
    self.tableData = [[NSMutableArray alloc] init];
    
    [self ActiveToolbar_Hot:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%lu", (unsigned long)[self.tableData count]);
    return [self.tableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    声明静态字符串型对象，用来标记重用单元格
    static NSString *TableIdentifier = @"GalleryTableIdentifier";
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
    ProgramItem *item = [self.tableData objectAtIndex:row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subtitle;
    
    //    表视图单元提供的UILabel属性，设置字体大小
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    NSString *coverURL = [[NSString stringWithString:BaseSiteURLString] stringByAppendingString:item.coverpath];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:coverURL]]];
    cell.imageView.image=image;
  
    return cell;  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    首先是用indexPath获取当前行的内容
    NSInteger row = [indexPath row];
    //    从数组中取出当前行内容
    ProgramItem* item = [self.tableData objectAtIndex:row];
    
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
    } failure:^(AFHTTPRequestOperation *operation, NSError*error){
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Error Retrieving Program"
                                                           message:[error localizedDescription]
                                                          delegate:nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
    
}

- (void)loadNetworkAccessWithDictionary:(NSDictionary *)list listType:(NSString*)type {
    [self.tableData removeAllObjects];
    
    for (NSDictionary *tuple in list) {
//        if ([type isEqual: @"Hot"]) {
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
            
            [self.tableData addObject: item];
//        }
//        
//        if ([type isEqual:@"News"]) {
//            
//        }
//        
//        if ([type isEqual:@"Broadcast"]) {
//            
//        }
//        
//        if ([type isEqual:@"Program"]) {
//            
//        }
        
        [self.GalleryTable reloadData];
    }
}

- (void) getInformationFromServerWithUrl:(NSString *)accessUrl sender:(NSString *)sender {
    
    NSString *string = [[NSString stringWithString:BaseURLString] stringByAppendingString:accessUrl];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        [self loadNetworkAccessWithDictionary:responseObject listType:sender];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError*error){
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Error Retrieving Hot"
                                                    message:[error localizedDescription]
                                                    delegate:nil
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:nil];
        [alertView show];
    }];

    [operation start];

    
}

- (IBAction)ActiveToolbar_Hot:(id)sender {
    [self.ToolbarButton_Hot activateButton];
    [self.ToolbarButton_News deactivateButton];
    [self.ToolbarButton_Broadcast deactivateButton];
    [self.ToolbarButton_Program deactivateButton];
    
    [self getInformationFromServerWithUrl:@"Video/" sender:@"Hot"];
    [self.GalleryTable reloadData];
    
}

- (IBAction)ActiveToolbar_News:(id)sender {
    [self.ToolbarButton_Hot deactivateButton];
    [self.ToolbarButton_News activateButton];
    [self.ToolbarButton_Broadcast deactivateButton];
    [self.ToolbarButton_Program deactivateButton];
    
    [self getInformationFromServerWithUrl:@"Video/" sender:@"News"];
    [self.GalleryTable reloadData];
}

- (IBAction)ActiveToolbar_Broadcast:(id)sender {
    [self.ToolbarButton_Hot deactivateButton];
    [self.ToolbarButton_News deactivateButton];
    [self.ToolbarButton_Broadcast activateButton];
    [self.ToolbarButton_Program deactivateButton];
    
    [self getInformationFromServerWithUrl:@"Video/" sender:@"Broadcast"];
    [self.GalleryTable reloadData];
}

- (IBAction)ActiveToolbar_Program:(id)sender {
    [self.ToolbarButton_Hot deactivateButton];
    [self.ToolbarButton_News deactivateButton];
    [self.ToolbarButton_Broadcast deactivateButton];
    [self.ToolbarButton_Program activateButton];
    
    [self getInformationFromServerWithUrl:@"Video/" sender:@"Program"];
    [self.GalleryTable reloadData];
}



@end
