//
//  CircleObject.h
//  FancyScroll
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleObject : NSObject{
    CGPoint parentCenter;
    CGFloat parentRadius;
    CGPoint childCenter;
    CGFloat childRadius;
    CGRect childRect;
    CGFloat dis;
}
- (id) initWithCenterRect:(CGRect) frame andOrder:(int)order;
- (CGRect) getRect;
- (CGFloat) getDis;
- (CGFloat) getRadius;
- (BOOL) isPointOnCircle:(CGPoint) point;
@end
