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

+ (SBImageAPIClient *)sharedClient;
- (void)uploadImageWithData:(NSData*)imageData;
@end
