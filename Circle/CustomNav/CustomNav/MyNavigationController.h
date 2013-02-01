//
//  MyNavigationController.h
//  CustomNav
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyToolBar.h"
#import "MyNavigationBar.h"

@interface MyNavigationController : UIView{
    NSMutableArray * viewControllers;
    MyNavigationBar * myNavigationBar;
    MyToolbar * myToolBar;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController;
- (void)popViewControllerAnimated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (MyToolbar *)toolbar;
- (MyNavigationBar *)navigationBar;

@end
