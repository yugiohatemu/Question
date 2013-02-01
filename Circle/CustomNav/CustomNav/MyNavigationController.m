//
//  MyNavigationController.m
//  CustomNav
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import "MyNavigationController.h"


@implementation MyNavigationController


- (id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithFrame:rootViewController.view.frame];
    if (self) {
        viewControllers = [[NSMutableArray alloc]initWithObjects:rootViewController, nil];
        myNavigationBar = [[MyNavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        myToolBar = [[MyToolbar alloc]initWithFrame:CGRectMake(0, 420, 320, 44)];
        
        [self addSubview:rootViewController.view];
        [self addSubview:myNavigationBar];
        [self addSubview:myToolBar];
        [[myNavigationBar leftButton]addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventAllTouchEvents];
        [[myNavigationBar rightButton]addTarget:self action:@selector(pushViewController:animated:) forControlEvents:UIControlEventAllTouchEvents];

    }
    
    return self;
}

- (void)popViewControllerAnimated:(BOOL)animated{
    if ([viewControllers count] > 1){
        UIViewController * current = [viewControllers lastObject];
        UIViewController * previous = [viewControllers objectAtIndex:[viewControllers count]-2];
        
        if (animated) {
            [UIView transitionFromView:current.view toView:previous.view duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished){
                
            }];
        }
 
        [viewControllers removeLastObject];
        
        [self addSubview:previous.view];
        [self bringSubviewToFront:myNavigationBar];
        [self bringSubviewToFront:myToolBar];
    }
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[UIViewController class]]) {
        
        UIViewController * current = [viewControllers lastObject];
        if (animated) {
            [UIView transitionFromView:current.view toView:viewController.view duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished){
                
            }];
        }
        
        [viewControllers addObject:viewController];
        [self addSubview:viewController.view];
        [self bringSubviewToFront:myNavigationBar];
        [self bringSubviewToFront:myToolBar];
    }
   
}

- (MyToolbar *)toolbar{
    return  myToolBar;
}
- (MyNavigationBar *)navigationBar{
    return  myNavigationBar;
}


@end
