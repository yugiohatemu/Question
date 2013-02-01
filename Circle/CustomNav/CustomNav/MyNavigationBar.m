//
//  MyNavigationBar.m
//  CustomNav
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import "MyNavigationBar.h"

@implementation MyNavigationBar

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:102.0/255 green:52.0/255 blue:133.0/255 alpha:1];
    if (self) {
        myLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [myLeftButton setClipsToBounds:YES];
        [myLeftButton setTitle:@"Pop" forState:UIControlStateNormal];
        [myLeftButton setFrame:CGRectMake(10, 5, 35, 35)];
        
        myRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [myRightButton setClipsToBounds:YES];
        [myRightButton setTitle:@"Push" forState:UIControlStateNormal];
        [myRightButton setFrame:CGRectMake(270, 5, 40, 35)];
        
        myTitle = [[UILabel alloc]initWithFrame:CGRectMake(130, 5, 100, 35)];
        myTitle.text = @"MYNavBar";
        myTitle.backgroundColor = [UIColor clearColor];
        
        [self addSubview:myLeftButton];
        [self addSubview:myRightButton];
        [self addSubview:myTitle];
        
    }
    return self;
}

- (UIButton *)leftButton{
    return myLeftButton;
}
- (UIButton *)rightButton{
    return myRightButton;
}
- (NSString *)title{
    return  myTitle.text;
}

- (void)setTitle:(NSString *)title{
    myTitle.text = title;
}


@end
