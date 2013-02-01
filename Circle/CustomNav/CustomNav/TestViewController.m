//
//  TestViewController.m
//  CustomNav
//
//  Created by Yue on 1/31/13.
//  Copyright (c) 2013 Yue. All rights reserved.
//

#import "TestViewController.h"

@implementation TestViewController

- (id) initWithMyNav:(MyNavigationController *) myNavController{
    if(self = [super init]){
        myNav = myNavController;
        button = [[UIButton alloc]initWithFrame:CGRectMake(0, 160, 320, 50)];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:button];
    [button setTitle:@"Press to push new page" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventAllTouchEvents];
	// Do any additional setup after loading the view.
}

- (IBAction)test:(id)sender{
    UIViewController * aTestView = [[UIViewController alloc]init];
    [myNav pushViewController:aTestView animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
