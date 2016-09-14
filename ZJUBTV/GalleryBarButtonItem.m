//
//  GalleryBarButtionItem.m
//  ZJUBTV
//
//  Created by GreysTone on 9/26/15.
//  Copyright © 2015 GreysTone. All rights reserved.
//

#import "GalleryBarButtonItem.h"
@implementation GalleryBarButtonItem

- (void) activateButton {
    self.tintColor = [[UIColor alloc] initWithRed: (0.0/255) green: (177.0/255) blue: (252.0/255) alpha: 1];
}

- (void) deactivateButton {
    self.tintColor = [UIColor blackColor];
}


@end
