//
//  HNClient.h
//  HNReader
//
//  Created by slim on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponse.h"

@interface HNClient : NSObject {
    
}
-(void) getPosts:(void(^)(HttpResponse * resp, NSDictionary* posts)) complete;
@end
