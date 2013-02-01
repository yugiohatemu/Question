//
//  MyToolBar.h
//  CustomNav
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyToolbar: UIView{
    UIButton * myLeftButton;
    UIButton * myRightButton;
}

- (UIButton *)leftButton;
- (UIButton *)rightButton;

@end
