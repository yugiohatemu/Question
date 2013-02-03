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
        //Set up inner circle
        CGFloat innerRadius = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*0.6;
        innerCircle = CGRectMake(CGRectGetMidX(frame), CGRectGetMidY(frame)-innerRadius*0.9, innerRadius, innerRadius);
        
        //Set up small circles
        myCircleList = [[NSMutableArray alloc]init];
        for (int i = 0; i <8; i+=1) {
            CircleObject * aCircle = [[CircleObject alloc]initWithCenterRect:innerCircle andOrder:i];
            [myCircleList addObject:aCircle];
        }
        
        //Set up outter circle
        CircleObject * aCircle = [myCircleList objectAtIndex:0];
        CGFloat outterRadius = [aCircle getDis] + [aCircle getRadius]; //dis + small r = big r + small r + offset
        outterCircle = CGRectMake(CGRectGetMidX(innerCircle) - outterRadius, CGRectGetMidY(innerCircle) - outterRadius,
                                  outterRadius*2, outterRadius*2);
        
        //Scroll
        isScrollBegin = NO;
        currentPoint = CGPointMake(0, 0);
    }
    return self;
}

#pragma mark - Algebra
//Be careful about radius, it is half of the width or height

- (BOOL) isPointOnCircleList:(CGPoint) point{
    //Want the circle to scoll when touch the outer part
    //but do not want it to scroll when touch the inner big circle

    CGPoint center = CGPointMake(CGRectGetMidX(innerCircle), CGRectGetMidY(innerCircle));
    CGFloat dis  = sqrtf((point.x - center.x)*(point.x - center.x)+ (point.y - center.y)*(point.y - center.y));
    
    BOOL onOuter = (dis <= CGRectGetHeight(outterCircle)*0.5); 
    BOOL onInner = (dis <= CGRectGetWidth(innerCircle)*0.5);
    
    return  (onOuter && !onInner);
}


- (int) pointInArea:(CGPoint) point{
    //1 0
    //2 3
    //TODO: replace center circle with outer circle
    
    CGFloat radius = CGRectGetHeight(outterCircle)/2.0;
    
    CGRect areas[4] = { CGRectMake(CGRectGetMidX(outterCircle), CGRectGetMinY(outterCircle),radius, radius),
                        CGRectMake(CGRectGetMinX(outterCircle), CGRectGetMinY(outterCircle),radius, radius),
                        CGRectMake(CGRectGetMinX(outterCircle), CGRectGetMidY(outterCircle),radius, radius),
                        CGRectMake(CGRectGetMidX(outterCircle), CGRectGetMidY(outterCircle),radius, radius)};
    
    for (int i = 0;i<4 ;i+=1 ) {
        if (CGRectContainsPoint(areas[i], point)) {
            return i;
        }
    }
    //-1 is invalid?
    return -1;
}


- (BOOL) isClockWiseFrom:(CGPoint) from to:(CGPoint) to{
    int fromArea = [self pointInArea:from];
    int toArea = [self pointInArea:to];
    BOOL result = YES;
    if (fromArea == toArea) {
        
        if (fromArea == 0) {
            result = (from.x < to.x) || (from.y > to.y) ;
        }else if(fromArea == 1){
            result = (from.x < to.x) || (from.y > to.y) ;
        }else if(fromArea == 2){
            result = (from.x > to.x) || (from.y < to.y) ;
        }else{ //3
            result = (from.x < to.x) || (from.y < to.y) ;
        }
        
    }else{
        if (fromArea == 0 && toArea == 3) {
            result = YES;
        }else if(fromArea == 3 && toArea == 0){
            result = NO;
        }else{
            result = (fromArea > toArea);
        }
    }
    
    
    return result;
}


#pragma mark - Touch Screen Control

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //THis is how to get touch
    NSArray *touchesArray = [touches allObjects];
    UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    
    //Check if the point is inside the circle view frame else ignore
    if ([self isPointOnCircleList:point]) {
        isScrollBegin = YES;
        currentPoint = point;
        //NSLog(@"Hit");
    }

    //[self drawRect:self.frame];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"MOve");
    
    if (isScrollBegin == YES) {
        NSArray *touchesArray = [touches allObjects];
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
        CGPoint point = [touch locationInView:self];
        
        //Cancel the touch if scroll in the big circle
       /* if (![self isPointOnCircleList:point]) {
            isScrollBegin = NO;
            return ;
        }*/
        //NSLog(@"A");
        BOOL direction = [self isClockWiseFrom:currentPoint to:point];
        
        for (CircleObject * aCircle in myCircleList) {
            [aCircle spin:direction];
        }
        
        currentPoint = point;
        //NSLog(@"Ddd draw");
        //[self drawRect:self.frame];
        [self setNeedsDisplay];
   }
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (isScrollBegin == YES) {
        NSArray *touchesArray = [touches allObjects];
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
        CGPoint point = [touch locationInView:self];
        
        //Check if the point passed the limit point then need to bounce
        
        //If so, need animation
        
        //[self drawRect:self.frame];
        //isScrollBegin = NO;
    }
    //Check last point see if need to bounce
    
    
    //redraw with blcok animation maybe
}


- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"Cancel");
    isScrollBegin = NO;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation

#pragma mark - Draw Screen

- (void)drawRect:(CGRect)rect{
    self.backgroundColor = [UIColor clearColor];
    
    //UIGraphicsPopContext();
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, innerCircle);
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor blueColor] CGColor]));
    CGContextFillPath(context);
          
    for (CircleObject * aCircle in myCircleList) {
       // NSLog(@"%f %f",[aCircle getRect].origin.x,[aCircle getRect].origin.y);
        CGContextAddEllipseInRect(context,[aCircle getRect]);
        CGContextSetFillColor(context, CGColorGetComponents([[UIColor greenColor] CGColor]));
        CGContextFillPath(context);
        
    }
    UIGraphicsPushContext(context);
    
}



@end
