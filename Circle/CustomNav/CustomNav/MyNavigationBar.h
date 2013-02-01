//
//  MyNavigationBar.h
//  CustomNav
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNavigationBar : UIView{
    UIButton * myLeftButton;
    UIButton * myRightButton;
    UILabel * myTitle;
}
- (UIButton *)leftButton;
- (UIButton *)rightButton;
- (NSString *)title;
- (void)setTitle:(NSString *)title;


@end
