//
//  UserViewController.m
//  ZJUBTV
//
//  Created by GreysTone on 5/21/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "UserViewController.h"

#import "ProgramItem.h"

static NSString * const BaseURLString =@"https://api.zjubtv.com/";
static NSString * const BaseSiteURLString = @"http://www.zjubtv.com/";

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isLogin = false;
    
    self.UserTable.delegate = self;
    self.UserTable.dataSource = self;
    
    self.userData = [[NSMutableArray alloc] init];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.userData count];
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"个人设置";
    }
    if (section == 1) {
        return @"试验频道";
    }
    return @"";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    声明静态字符串型对象，用来标记重用单元格
    static NSString *TableIdentifier = @"UserTableIdentifier";
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
    
    NSInteger section = [indexPath section];
//    NSInteger row = [indexPath row];
    
    switch (section) {
        case 0:
            cell.textLabel.text = @"尚未登录";
            cell.detailTextLabel.text = @"";
            break;
        case 1:
            cell.textLabel.text = @"现场直播";
            cell.detailTextLabel.text = @"尚未检测到正在转播的信号";
            break;
        default:
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%@", indexPath);
    NSInteger section = [indexPath section];
    
    switch (section) {
        case 0:     // 登录
            
            break;
        case 1:     // 直播
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Default Alert View" message:@"Defalut" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}

@end
