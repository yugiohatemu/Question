//
//  CircleObject.m
//  FancyScroll
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import "CircleObject.h"

@implementation CircleObject

- (id) initWithCenterRect:(CGRect)frame andOrder:(int)order{
    if (self = [super init]) {
        parentCenter = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        parentRadius = CGRectGetWidth(frame)/2.0;
        childRadius = parentRadius * 0.3;
        dis = parentRadius+childRadius+5;
        //5 is offset between small circle and big circle
        childAngle = 40*order+ 90;
        CGFloat angle = (40*order+ 90)*M_PI/180.0;
        childCenter = CGPointMake(parentCenter.x+dis*cos(angle),parentCenter.y+dis*sin(angle));
        //childRect = CGRectMake(childCenter.x-childRadius, childCenter.y-childRadius, childRadius*2.0, childRadius*2);
    }
    return self;
}

- (CGRect) getRect{
    return CGRectMake(childCenter.x-childRadius, childCenter.y-childRadius, childRadius*2.0, childRadius*2);
}


- (CGFloat)getDis{
    return dis;
}

- (CGFloat) getRadius{
    return childRadius;
}


- (void) spin:(BOOL) clockWise{
    static int offset = 0;
    if (clockWise == YES) {
        offset += 1;
    }else{
        offset -= 1;
    }
    CGFloat angle = (childAngle + offset)*M_PI/180.0;
    childCenter = CGPointMake(parentCenter.x+dis*cos(angle),parentCenter.y+dis*sin(angle));
}

@end
