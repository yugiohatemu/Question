//
//  Pie.m
//  FancyScroll
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import "CircleView.h"
#import "CircleObject.h"
@implementation CircleView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Supper 12 for all, but only use 8 slice for now
        myCircleList = [[NSMutableArray alloc]init];
        
        CGFloat radius = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*0.6;
        centerCircle = CGRectMake(CGRectGetMidX(frame), CGRectGetMidY(frame)-radius*0.9, radius, radius);
        //NSLog(@"%f",radius);
        for (int i = 0; i <8; i+=1) {
            CircleObject * aCircle = [[CircleObject alloc]initWithCenterRect:centerCircle andOrder:i];
            [myCircleList addObject:aCircle];
        }
        isScrollBegin = false;
        currentPoint = CGPointMake(0, 0);
    }
    return self;
}

#pragma mark - Algebra
//Be careful about radius, it is half of the width or height

- (BOOL) isPointOnCircleList:(CGPoint) point{
    //Want the circle to scoll when touch the outer part
    //but do not want it to scroll when touch the inner big circle
    
    CircleObject * aCircle = [myCircleList objectAtIndex:0];
    CGFloat outerRadius = [aCircle getDis] + [aCircle getRadius];
    CGPoint center = CGPointMake(CGRectGetMidX(centerCircle), CGRectGetMidY(centerCircle));
    CGFloat dis  = sqrtf((point.x - center.x)*(point.x - center.x)+ (point.y - center.y)*(point.y - center.y));
    
    BOOL onOuter = (dis <= outerRadius); //dis + small radius
    BOOL onInner = (dis <= CGRectGetWidth(centerCircle)*0.5);
    return  (onOuter && !onInner);
}

- (BOOL) isClockWise:(CGPoint) from:(CGPoint) to{
   //Check which area the points are in
    
    
    return YES;
}


#pragma mark - Touch Screen Control

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //THis is how to get touch
    NSArray *touchesArray = [touches allObjects];
    UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    
    //Check if the point is inside the circle view frame else ignore
    if ([self isPointOnCircleList:point]) {
        isScrollBegin = true;
        currentPoint = point;
        //NSLog(@"On");
    }/*else{
        NSLog(@"Not On");
    }*/
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (isScrollBegin) {
        NSArray *touchesArray = [touches allObjects];
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
        CGPoint point = [touch locationInView:self];
        
        for (CircleObject * aCircle in myCircleList) {
            //check which area we are doing
        }
        //[self drawRect:self.frame];
    }
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (isScrollBegin) {
        NSArray *touchesArray = [touches allObjects];
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
        CGPoint point = [touch locationInView:self];
        
        //Check if the point passed the limit point then need to bounce
        
        //If so, need animation
        
        //[self drawRect:self.frame];
        isScrollBegin = false;
    }
    //Check last point see if need to bounce
    
    
    //redraw with blcok animation maybe
}


- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //Do nothing
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation

#pragma mark - Draw Screen

- (void)drawRect:(CGRect)rect{
    self.backgroundColor = [UIColor clearColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, centerCircle);
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor blueColor] CGColor]));
    CGContextFillPath(context);
    
    //NSLog(@"%f %f",CGRectGetMidX(centerCircle),CGRectGetMidY(centerCircle));
   
    for (CircleObject * aCircle in myCircleList) {
       // NSLog(@"%f %f",[aCircle getRect].origin.x,[aCircle getRect].origin.y);
        CGContextAddEllipseInRect(context,[aCircle getRect]);
        CGContextSetFillColor(context, CGColorGetComponents([[UIColor greenColor] CGColor]));
        CGContextFillPath(context);
        
    }
}


@end
