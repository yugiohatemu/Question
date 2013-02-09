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
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 60.0f)] autorelease];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchButton.frame = CGRectMake(10, 300, 120 , 30);
    [searchButton setTitle:@"Search more" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchMore:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
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
        self.searchBar.frame = CGRectMake(0.0f, 0.0f, size.height, 60.0f);
        isShowingLandscapeView = YES;
    }else if (UIDeviceOrientationIsPortrait(deviceOrientation) && isShowingLandscapeView){
        self.searchBar.frame = CGRectMake(0.0f, 0.0f, size.width, 60.0f);
        isShowingLandscapeView = NO;
    }
}

#pragma mark UISearchBar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.imageSearchController performSearch:searchBar.text];
}

- (IBAction)searchMore:(id)sender{
    //NSLog(@"Button pressed");
    [self.imageSearchController performNextSearch:self.searchBar.text withStart:[imageArray count]];
    
}




#pragma mark ImageSearchController Delegate Methods

//Load image
//TODO: add load based on image ratio in the last
//TODO: show a spinner on the button?
//TODO: adjust button
//TODO: add scroll view
//TODO: show spinner and hide button when search, when not, show button and hide spinner
//TODO: add button to clear context

- (void) loadImageView{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat searbarOffset = 60.0f;
    CGFloat delta = 10.0f; //offset between images
    //based on orientation
    if (isShowingLandscapeView) { //horizontal, maybe 6 in a line?
        CGFloat imageWidth = size.height/6;
        CGFloat imageHeight = imageWidth;
        
        for (int i = 0; i<[imageArray count]; i++) {
            UIImageView * aImageView = [imageArray objectAtIndex:i];
            aImageView.frame = CGRectMake(delta+imageWidth * (i % 6), delta+searbarOffset+imageHeight*(i / 6) , imageWidth, imageHeight);
        }
        
    }else{
        //portatit, about 4 in a line
        CGFloat imageWidth = size.width / 5;
        CGFloat imageHeight = imageWidth;
        
        for (int i = 0; i<[imageArray count]; i++) {
            UIImageView * aImageView = [imageArray objectAtIndex:i];
            aImageView.frame = CGRectMake(delta+imageWidth * (i % 4), delta+searbarOffset+imageHeight*(i / 4) , imageWidth, imageHeight);
        }
    }
}


- (void)imageSearchController:(id)searchController gotResults:(NSArray *)results{
    
    //TODO: asynchoronous result
   // NSLog(@"%d in result",[results count]);
    
    
    for (NSDictionary * imageInfo in results) {
        NSString * url = [imageInfo objectForKey:@"url"];
        //Only one pair in the array
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
        UIImage * aImage = [UIImage imageWithData:imageData];
    
        UIImageView * aImageView = [[UIImageView alloc]initWithImage:aImage];
        [imageArray addObject:aImageView];
        [self.view addSubview:aImageView];
        
    }
    
    //As soon as we have an image, show it
    [self loadImageView];
    
    //}
    
    //TODO: load based on size and format nicely?
    
    // TODO: Google only sends a few images at a time.  Add a control to allow the user to fetch more images.
    // You will need to append the parameter "start" to the request made by the ImageSearchController.
    // Results are zero-indexed.  Be careful not to violate the Google API TOS!  The user must initiate
    // fetching each set of results with a "user action."  Automated requests are not allowed.
}

@end
