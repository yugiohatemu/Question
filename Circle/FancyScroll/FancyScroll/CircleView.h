//
//  Circle
//  FancyScroll
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView <UIGestureRecognizerDelegate>{
    NSMutableArray * myCircleList;
    BOOL isScrollBegin;
    CGPoint currentPoint;
    CGRect innerCircle;
    CGRect outterCircle;
}

@end
