//
//  HNClient.h
//  HNReader
//
//  Created by slim on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiResponse.h"

@interface HNClient : NSObject {
    
}


-(void) getNews:(NSString*) nextId withType:(int) whichType withCompleteBlock:(void (^)(ApiResponse * resp) )complete;

@end
