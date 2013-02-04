//
//  Pie.m
//  FancyScroll
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import "CircleView.h"
#import "CircleObject.h"

BOOL dirtyDir;

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
       
        timer = nil;
    }
    return self;
}

#pragma mark - Algebra
//Warning:Be careful about radius, it is half of the width or height

//Want the circle to scoll when touch the outer ring
//but do not want it to scroll when touch the inner big circle
- (BOOL) isPointOnCircleList:(CGPoint) point{

    CGPoint center = CGPointMake(CGRectGetMidX(innerCircle), CGRectGetMidY(innerCircle));
    CGFloat dis  = sqrtf((point.x - center.x)*(point.x - center.x)+ (point.y - center.y)*(point.y - center.y));
    
    BOOL onOuter = (dis <= CGRectGetHeight(outterCircle)*0.5); 
    BOOL onInner = (dis <= CGRectGetWidth(innerCircle)*0.5);
    
    return  (onOuter && !onInner);
}

//Divide the outterCircle area by 4 part
//1 0
//2 3
- (int) pointInArea:(CGPoint) point{
    
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
    //-1 for invalid
    return -1;
}

//Check the sprint condition based on area the point difference
- (BOOL) isClockWiseFrom:(CGPoint) from to:(CGPoint) to{
    
    int fromArea = [self pointInArea:from];
    int toArea = [self pointInArea:to];
    BOOL result = YES;
    if (fromArea == toArea) {
        
        if (fromArea == 0) {
            result = (from.x < to.x) || (from.y < to.y) ;
        }else if(fromArea == 1){
            result = (from.x < to.x) || (from.y > to.y) ;
        }else if(fromArea == 2){
            result = (from.x > to.x) || (from.y > to.y) ;
        }else{ //3
            result = (from.x > to.x) || (from.y < to.y) ;
        }
        
    }else{
        if (fromArea == 0 && toArea == 3) {
            result = YES;
        }else if(fromArea == 3 && toArea == 0){
            result = NO;
        }else{
            result = (fromArea < toArea);
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
    
    //Check if the point is inside the ring area 
    if ([self isPointOnCircleList:point]) {
        isScrollBegin = YES;
        currentPoint = point;
    }

}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"MOve");
    
    if (isScrollBegin == YES) {
        NSArray *touchesArray = [touches allObjects];
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
        CGPoint point = [touch locationInView:self];
        
        //Cancel the touch if scroll in the big circle
       /*if (![self isPointOnCircleList:point]) {
            isScrollBegin = NO;
            return ;
        }*/
       
        BOOL direction = [self isClockWiseFrom:currentPoint to:point];
        
        for (CircleObject * aCircle in myCircleList) {
            [aCircle spin:direction];
        }
        
        currentPoint = point;
        [self setNeedsDisplay];
   }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    static CGFloat delta = 10.0f;
    
    if (isScrollBegin == YES) {    
    
        CGFloat startX = CGRectGetMaxX([[myCircleList objectAtIndex:0] getRect]);
        CGFloat endX = CGRectGetMaxX([[myCircleList lastObject] getRect]);
       
        //First check if first circle or last circle are shown in the scren
        if (startX<320 || endX<320) {
            //Then check if they exceeds the delta offset
            if (startX<320 - delta ) {
                
                dirtyDir = NO;
                timer = [NSTimer timerWithTimeInterval:1.0f/60 target:self selector:@selector(bounceTimer:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
            
            }else if(endX<320 - delta){
                
                dirtyDir = YES;
                timer = [NSTimer timerWithTimeInterval:1.0f/60 target:self selector:@selector(bounceTimer:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
            }
        
        }
        isScrollBegin = NO;
                
    }
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

    //If possible, I think shold pop graphic context when redraw, but clear is good for now
    //UIGraphicsPopContext();
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, innerCircle);
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor blueColor] CGColor]));
    CGContextFillPath(context);
          
    for (CircleObject * aCircle in myCircleList) {
      
        CGContextAddEllipseInRect(context,[aCircle getRect]);
        CGContextSetFillColor(context, CGColorGetComponents([[UIColor greenColor] CGColor]));
        CGContextFillPath(context);
        
    }
    UIGraphicsPushContext(context);
    
}

//Use a dirty BOOL value for direction
- (void) bounceTimer:(NSTimer *) myTimer{
    //Check if the first or last circle hits the bound of screen
    if(dirtyDir == NO && CGRectGetMaxX([[myCircleList objectAtIndex:0] getRect]) >= 310){ //width - delta
            [timer invalidate];
            timer = nil;
            return ;

    }else if(dirtyDir == YES &&CGRectGetMaxX([[myCircleList lastObject] getRect]) >= 310){
            [timer invalidate];
            timer = nil;
            return ;

        
    }
    
    for (CircleObject * aCircle in myCircleList) {
        [aCircle spin:dirtyDir];
    }
    
    [self setNeedsDisplay];
}

@end
