//
//  SBImageAPIClient.m
//  DemoProject
//
//  Created by Austin Louden on 8/5/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import "SBImageAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kImageShackAPIBaseURLString = @"https://post.imageshack.us/";

@implementation SBImageAPIClient
@synthesize apiKey = _apiKey;

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
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    return self;
}

- (void)uploadImageWithData:(NSData*)imageData success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{@"key": _apiKey,
                             @"format" : @"json",
                             @"public" : @"no"
                             };
    
    NSURLRequest *request = [self multipartFormRequestWithMethod:@"POST"
                                                            path:@"upload_api.php"
                                                      parameters:params
                                       constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
                                           [formData appendPartWithFileData:imageData
                                                                       name:@"fileupload"
                                                                   fileName:@"image.png"
                                                                   mimeType:@"image/png"];
    }];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        success(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure(error);
    }];
    
    [operation start];

}

@end
