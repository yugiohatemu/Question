//
//  ImageSearchController.m
//  InklingChallenge
//
//  Copyright (c) 2011 Inkling Systems, Inc. All rights reserved.
//

#import "ImageSearchController.h"

@interface ImageSearchController ()
@property (nonatomic, retain) NSMutableData *searchResultsData;
@end

@implementation ImageSearchController

@synthesize delegate = _delegate;
@synthesize searchResultsData = _searchResultsData;

- (void)performSearch:(NSString *)searchTerm
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&resultFormat=text", searchTerm]]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - Perform search with start

- (void)performNextSearch:(NSString *)searchTerm withStart:(int)start{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&resultFormat=text&start=%d", searchTerm,start]]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)dealloc
{
    [_searchResultsData release];
    [super dealloc];
}

#pragma mark NSURLConnnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.searchResultsData = [[[NSMutableData alloc] initWithCapacity:1024] autorelease];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self.delegate imageSearchController:self getError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.searchResultsData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:self.searchResultsData options:NSJSONReadingAllowFragments error:&error];
    if (!JSONObject) {
        [self.delegate imageSearchController:self getError:error];
        return ;
    }
    id responseData = [JSONObject objectForKey:@"responseData"];
    if ([responseData isKindOfClass:[NSDictionary class]]) {
        id results = [responseData objectForKey:@"results"];
        if ([results isKindOfClass:[NSArray class]]) {
            [self.delegate imageSearchController:self gotResults:results];
        }
    }
}

@end
