//
//  TestViewController.h
//  CustomNav
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationController.h"

@interface TestViewController : UIViewController{
    MyNavigationController * myNav;
    UIButton * button;
}
- (id) initWithMyNav:(MyNavigationController *) myNavController;

@end
