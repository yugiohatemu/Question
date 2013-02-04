//
//  MainViewController.m
//  InklingChallenge
//
//  Copyright (c) 2011 Inkling Systems, Inc. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) ImageSearchController *imageSearchController;
@end

@implementation MainViewController

@synthesize searchBar = _searchBar;
@synthesize imageSearchController = _imageSearchController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imageSearchController = [[[ImageSearchController alloc] init] autorelease];
        self.imageSearchController.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [_searchBar release];
    [_imageSearchController release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 60.0f)] autorelease];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // TODO: Make sure everything resizes and/or reflows correctly on rotation.
	return YES;
}

#pragma mark UISearchBar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.imageSearchController performSearch:searchBar.text];
}

#pragma mark ImageSearchController Delegate Methods

- (void)imageSearchController:(id)searchController gotResults:(NSArray *)results
{
    // TODO: Load each image listed in results and display them nicely.

    // TODO: Google only sends a few images at a time.  Add a control to allow the user to fetch more images.
    // You will need to append the parameter "start" to the request made by the ImageSearchController.
    // Results are zero-indexed.  Be careful not to violate the Google API TOS!  The user must initiate
    // fetching each set of results with a "user action."  Automated requests are not allowed.
}

@end
