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
    CGFloat dis;
    CGFloat childAngle;
}
- (id) initWithCenterRect:(CGRect) frame andOrder:(int)order;

- (CGRect) getRect;
- (CGFloat) getDis;
- (CGFloat) getRadius;
- (CGPoint) getChildCenter;
- (void) spin:(BOOL) clockWise;
@end
