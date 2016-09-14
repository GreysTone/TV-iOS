//
//  ProgramItem.h
//  ZJUBTV
//
//  Created by GreysTone on 10/31/15.
//  Copyright © 2015 GreysTone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgramItem : NSObject

@property NSString* title;
@property NSString* subtitle;
@property NSNumber* columnid;
@property NSNumber* coverid;
@property NSString* coverpath;
@property NSNumber* createtime;
@property NSNumber* pid;
@property NSNumber* view;

@end
