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
        
        //Get the center of the frame
        
        for (int i = 0; i <8; i+=1) {
            CircleObject * aCircle = [[CircleObject alloc]init];
            
            [myCircleList addObject:aCircle];
        }
        isScrollBegin = false;
        currentPoint = CGPointMake(0, 0);
    }
    return self;
}

- (BOOL) isTouchOnCircleList:(CGPoint) point{
    return true;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //THis is how to get touch
    NSArray *touchesArray = [touches allObjects];
    UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    
    //Check if the point is inside the circle view frame else ignore
    if ([self isTouchOnCircleList:point]) {
        isScrollBegin = true;
        currentPoint = point;
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (isScrollBegin) {
        NSArray *touchesArray = [touches allObjects];
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
        CGPoint point = [touch locationInView:self];
        
        for (CircleObject * aCircle in myCircleList) {
            //Update with point
        }
        [self drawRect:self.frame];
    }
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (isScrollBegin) {
        NSArray *touchesArray = [touches allObjects];
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
        CGPoint point = [touch locationInView:self];
        
        //Check if the point passed the limit point then need to bounce
        
        //If so, need animation
        
        [self drawRect:self.frame];
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

- (void)drawRect:(CGRect)rect{
    //NSLog(@"%f %f %f %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    self.backgroundColor = [UIColor clearColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //TODO: use a smaller rect for the center circle
    
    
    CGContextAddEllipseInRect(context, rect);
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor blueColor] CGColor]));
    CGContextFillPath(context);

    for (CircleObject * aCircle in myCircleList) {
        CGContextAddEllipseInRect(context,[aCircle getRect]);
    }
}


@end
