//
//  SBImageAPIClient.h
//  DemoProject
//
//  Created by Austin Louden on 8/5/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface SBImageAPIClient : AFHTTPClient
@property (nonatomic, strong) NSString *apiKey;
+ (SBImageAPIClient *)sharedClient;
- (void)uploadImageWithData:(NSData*)imageData success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
@end
