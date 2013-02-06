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
        imageArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc
{
    [_searchBar release];
    [_imageSearchController release];
    [imageArray release];
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
    if (interfaceOrientation == UIInterfaceOrientationMaskPortrait) { //portait
        self.searchBar.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 60.0f);
    }else{
        self.searchBar.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 60.0f);
    }
    
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
    //Since everytime we load 4 images, we could just divide the frame in twice or half
    //keep the alignement and easy to calculate the frame
    
    //TODO: Load each image listed in results and display them nicely
    //TODO: asynchoronous result
    NSLog(@"%d in result",[results count]);
    NSDictionary * imageInfo = [results objectAtIndex:0];
    
    //for (NSDictionary * imageInfo in results) {
        NSString * url = [imageInfo objectForKey:@"url"];
        //Only one pair in the array
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
        UIImage * aImage = [UIImage imageWithData:imageData];
   // CGFloat imageHeight = aImage.size.height;
    //CGFloat imageWidth = aImage.size.width;
    //Based on width and height, adjust accodringly
    
        UIImageView * aImageView = [[UIImageView alloc]initWithImage:aImage];
    [imageArray addObject:aImageView];
    /*
        aImageView.frame = CGRectMake(0, 0, 50, 50);
        //TODO: add size and location adjustment here
        [self.view addSubview:aImageView];*/
        
        [imageData release];
        [aImage release];
        [aImageView release];
    //}
    
    //TODO: load based on size and format nicely?
    
    // TODO: Google only sends a few images at a time.  Add a control to allow the user to fetch more images.
    // You will need to append the parameter "start" to the request made by the ImageSearchController.
    // Results are zero-indexed.  Be careful not to violate the Google API TOS!  The user must initiate
    // fetching each set of results with a "user action."  Automated requests are not allowed.
}

@end
