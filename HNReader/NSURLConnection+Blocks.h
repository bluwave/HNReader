//
//  NSURLConnection+Blocks.h
//  aramarkCustomer
//
//  Created by slim on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiResponse.h"

@interface NSURLConnection (BlocksAddition)

+ (void)sendRequest:(NSURLRequest *)request completeBlock:( void (^)( ApiResponse *receivedData ) )complete;


@end
