//
//  ImageSearchController.h
//  InklingChallenge
//
//  Copyright (c) 2011 Inkling Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//Add a method for getting failure notification and handling failure
@protocol ImageSearchControllerDelegate
- (void)imageSearchController:(id)searchController gotResults:(NSArray *)results;
- (void)imageSearchController:(id)searchController getError:(NSError *)error;
@end

@interface ImageSearchController : NSObject <NSURLConnectionDataDelegate>
- (void)performSearch:(NSString *)searchTerm;
- (void)performNextSearch:(NSString *)searchTerm withStart:(int)start;
@property (nonatomic, assign) id <ImageSearchControllerDelegate> delegate; // NOTE: Intentional weak reference
@end
