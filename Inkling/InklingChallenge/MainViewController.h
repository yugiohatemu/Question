//
//  MainViewController.h
//  InklingChallenge
//
//  Copyright (c) 2011 Inkling Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageSearchController.h"

@interface MainViewController : UIViewController <UISearchBarDelegate,ImageSearchControllerDelegate>{
    NSMutableArray * imageArray;
    BOOL isShowingLandscapeView;
    UIButton * searchButton;
    UIScrollView * scrollView;
    UIActivityIndicatorView * searchSpinner;
    
}
@end
