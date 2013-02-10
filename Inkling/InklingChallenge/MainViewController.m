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
    [searchButton release];
    [searchSpinner release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    
    //Searchbar related
    self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 60.0f)] autorelease];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    //ScrollView related
    //Do don't want the searchbar to scroll
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    scrollView.contentSize = scrollView.bounds.size;
    [self.view addSubview:scrollView];
    
    //Everything will be add to scrollview instead
    
    //Searchbutton releatd
    searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchButton.frame = CGRectMake(10, 100, 120 , 40);
    searchButton.center = CGPointMake(self.view.bounds.size.width/2, 70);
    searchButton.hidden = YES;
    [searchButton setTitle:@"Search more" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchMore:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:searchButton];
    
    searchSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    searchSpinner.center = CGPointMake(self.view.bounds.size.width/2, 70);
    searchSpinner.hidesWhenStopped = YES;
    [scrollView addSubview:searchSpinner];
    
    
}

#pragma mark - Device rotation

- (void) viewDidLoad{
    [super viewDidLoad];
    
    //Check device rotation
    isShowingLandscapeView = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
    
    //Set up notification
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	return YES;
}


- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    //Adjust size
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&!isShowingLandscapeView){
        isShowingLandscapeView = YES;
        self.searchBar.frame = CGRectMake(0.0f, 0.0f, size.height, 60.0f);
        [self loadImageView];
    }else if (UIDeviceOrientationIsPortrait(deviceOrientation) && isShowingLandscapeView){
        self.searchBar.frame = CGRectMake(0.0f, 0.0f, size.width, 60.0f);
        isShowingLandscapeView = NO;
        [self loadImageView];
    }
}

#pragma mark UISearchBar Delegate Methods

//TODO: add clearn current context and reset ui
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //clear the current image
    if ([imageArray count] > 0) {
        for (UIImageView * aImageView in imageArray) {
            [aImageView removeFromSuperview];
        }
        [imageArray removeAllObjects];
    }
    
    //reset position and animation
    searchButton.center = CGPointMake(self.view.bounds.size.width/2, 170);
    searchSpinner.center = CGPointMake(self.view.bounds.size.width/2, 170);
    searchButton.hidden = YES;
    
    [self startSearchAnimation];
    [self.imageSearchController performSearch:searchBar.text];
    
    
}

- (IBAction)searchMore:(id)sender{
    [self startSearchAnimation];
    [self.imageSearchController performNextSearch:self.searchBar.text withStart:[imageArray count]];
}

#pragma mark ImageSearchController Delegate Methods

- (void)imageSearchController:(id)searchController gotResults:(NSArray *)results{
    
    //Asynchoronous downloading to avoid blocking UI
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        for (NSDictionary * imageInfo in results) {
            NSString * url = [imageInfo objectForKey:@"url"];
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
            
            if (imageData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage * aImage = [UIImage imageWithData:imageData];
                    
                    UIImageView * aImageView = [[UIImageView alloc]initWithImage:aImage];
                    [imageArray addObject:aImageView];
                    [scrollView addSubview:aImageView];
                    [self loadImageView];
                    
                });
            }
        }
            
    });
   [self finishDownloadAnimation];
    
}

//TODO:show a message when error downloading happens
- (void)imageSearchController:(id)searchController getError:(NSError *)error{
    NSLog(@"There was an error: %@", error);
    [self finishDownloadAnimation];
}


#pragma mark Detail UI related implementation


- (void) startSearchAnimation{
    searchButton.hidden = YES;
    [searchSpinner startAnimating];
}


//Hanlde event when finish downloading
- (void) finishDownloadAnimation{
    
    searchButton.hidden = NO;
    [searchSpinner stopAnimating];
    //TODO: adjust button and content offset
    searchButton.frame = CGRectOffset(searchButton.frame, 0, 100);
    searchSpinner.frame = CGRectOffset(searchSpinner.frame, 0, 100);
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(searchButton.frame))];
   
}


- (void) loadImageView{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat delta = 10.0f; //offset between images
    //based on orientation
    if (isShowingLandscapeView) { //horizontal, maybe 6 in a line?
        CGFloat imageWidth = size.height/6;
        CGFloat imageHeight = imageWidth;
        
        for (int i = 0; i<[imageArray count]; i++) {
            UIImageView * aImageView = [imageArray objectAtIndex:i];
            aImageView.frame = CGRectMake(delta+imageWidth * (i % 6), delta+imageHeight*(i / 6) , imageWidth, imageHeight);
        }
        
    }else{
        //portatit, about 4 in a line
        CGFloat imageWidth = size.width / 5;
        CGFloat imageHeight = imageWidth;
        
        for (int i = 0; i<[imageArray count]; i++) {
            UIImageView * aImageView = [imageArray objectAtIndex:i];
            aImageView.frame = CGRectMake(delta+imageWidth * (i % 4), delta+imageHeight*(i / 4) , imageWidth, imageHeight);
        }
    }
}


@end
