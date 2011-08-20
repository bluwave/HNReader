//
//  HNClient.h
//  HNReader
//
//  Created by slim on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponse.h"

typedef enum HNSubmissionType{ NEWS, NEW } HNSubmissionType;

@interface HNClient : NSObject {
    
}
-(void) getPostsOfType:(HNSubmissionType) type WithMoreId:(NSString*) nextId completeBlock:(void(^)(HttpResponse * resp, NSDictionary* posts)) complete;
@end
