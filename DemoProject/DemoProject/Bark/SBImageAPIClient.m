//
//  SBImageAPIClient.m
//  DemoProject
//
//  Created by Austin Louden on 8/5/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import "SBImageAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kImageShackAPIBaseURLString = @"https://post.imageshack.us/upload_api.php";
static NSString * const kImageShackAPIKey = @"";

@implementation SBImageAPIClient

+ (SBImageAPIClient *)sharedClient {
    static SBImageAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SBImageAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kImageShackAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    
    return self;
}

@end
