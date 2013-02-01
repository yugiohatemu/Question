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
        parentCenter = CGPointMake(frame.size.width/2, frame.size.width/2);
        parentRadius = frame.size.width/2;
        
        
        
        //Need to make parent view smaller to keep 
        
        //Calculate the center
    }
}

- (CGRect) getRect{
    return CGRectMake(0, 0, childRadius, childRadius);
}

- (void) scrollClockWise{
    
}

- (void) scrollConterClockWise{
    
}

@end
