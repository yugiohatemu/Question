//
//  MainViewController.m
//  InklingChallenge
//
//  Copyright (c) 2011 Inkling Systems, Inc. All rights reserved.
//

#import "MainViewController.h"
const CGFloat IMAGE_HEIGHT = 155.0f;
const CGFloat IMAGE_DELTA = 15.0f;

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
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    //Scrollview
    if (isShowingLandscapeView) {
        scrollView.frame = CGRectMake(0, 60, size.height, size.width);
        scrollView.contentSize = CGSizeMake(size.height, size.width);
    }else{
        scrollView.frame = CGRectMake(0, 60, size.width, size.height);
        scrollView.contentSize = CGSizeMake(size.width, size.height);
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	return YES;
}


- (void)orientationChanged:(NSNotification *)notification{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    //Adjust size
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&!isShowingLandscapeView){
        isShowingLandscapeView = YES;
        self.searchBar.frame = CGRectMake(0.0f, 0.0f, size.height, 60.0f);
        scrollView.frame = CGRectMake(0, 60, size.height, size.width-60);
        [self loadImageView];
    }else if (UIDeviceOrientationIsPortrait(deviceOrientation) && isShowingLandscapeView){
        isShowingLandscapeView = NO;
        self.searchBar.frame = CGRectMake(0.0f, 0.0f, size.width, 60.0f);
        scrollView.frame = CGRectMake(0, 60, size.width, size.height-60);
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
    //NSLog(@"There was an error: %@", error);
    UIAlertView * alert = [[[UIAlertView alloc]initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil]autorelease];
    [alert show];
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
}


//Load image, resize image and handle button position dynamically
- (void) loadImageView{
    //based on orientation
    CGFloat bound;
    if (isShowingLandscapeView) {
        bound = [UIScreen mainScreen].bounds.size.height;
    }else{
        bound = [UIScreen mainScreen].bounds.size.width;
    }
    
    //int row = 0;
    for (int i = 0; i<[imageArray count]; i++) {
        UIImageView * aImageView = [imageArray objectAtIndex:i];
        CGFloat imageWidth = CGRectGetWidth(aImageView.frame);
        
        //Load image based on image ratio with respect to max image height,
        //if not > than max height, then mean we have already calculated or the image does not need resizse
        if (CGRectGetHeight( aImageView.frame) > IMAGE_HEIGHT) {
            CGFloat ratio = CGRectGetWidth(aImageView.frame)/CGRectGetHeight(aImageView.frame);
            imageWidth =  IMAGE_HEIGHT * ratio;
        }
        
        //One image's position is based on the previous one
        if (i == 0) {
            aImageView.frame = CGRectMake(IMAGE_DELTA , IMAGE_DELTA , imageWidth, IMAGE_HEIGHT);
        }else{
            UIImageView * prevImage = [imageArray objectAtIndex:i-1];
            //Check if exceeding the right boundary, 
            if (IMAGE_DELTA +CGRectGetMaxX(prevImage.frame)+ imageWidth > bound) {
                aImageView.frame = CGRectMake(IMAGE_DELTA , IMAGE_DELTA+CGRectGetMaxY(prevImage.frame), imageWidth, IMAGE_HEIGHT);
            }else{
                aImageView.frame = CGRectMake(IMAGE_DELTA +CGRectGetMaxX(prevImage.frame), CGRectGetMinY(prevImage.frame) , imageWidth, IMAGE_HEIGHT);
            }
        }
        
    }
    
    //Adjust buton and spinner position based on the lowest image
    UIImageView * lastImage = [imageArray lastObject];
    searchButton.center = CGPointMake(bound/2, CGRectGetMaxY(lastImage.frame)+IMAGE_DELTA *2);
    searchSpinner.center = searchButton.center;
    scrollView.contentSize = CGSizeMake(bound, CGRectGetMaxY(searchButton.frame)+IMAGE_DELTA*2);

}


@end
