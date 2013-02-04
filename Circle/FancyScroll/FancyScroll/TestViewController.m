//
//  TestViewController.m
//  FancyScroll
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import "TestViewController.h"


@implementation TestViewController

- (id)init{
    
    self = [super init];
    if(self){
        myCircle = [[CircleView alloc]initWithFrame:CGRectMake(0, 0, 320 , 500)];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:myCircle];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
