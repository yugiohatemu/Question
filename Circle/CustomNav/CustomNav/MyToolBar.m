//
//  MyToolBar.m
//  CustomNav
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import "MyToolBar.h"


@implementation MyToolbar

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:102.0/255 green:52.0/255 blue:133.0/255 alpha:1];
    
    if (self) {
        myLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [myLeftButton setClipsToBounds:YES];
        [myLeftButton setTitle:@"Left" forState:UIControlStateNormal];
        [myLeftButton setFrame:CGRectMake(0, 0, 140, 35)];
        
        myRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [myRightButton setClipsToBounds:YES];
        [myRightButton setTitle:@"Right" forState:UIControlStateNormal];
        [myRightButton setFrame:CGRectMake(140, 0, 140, 35)];
        
        [self addSubview:myLeftButton];
        [self addSubview:myRightButton];
        
    }
    return self;
}
- (UIButton *)leftButton{
    return myLeftButton;
}
- (UIButton *)rightButton{
    return myRightButton;
}



@end