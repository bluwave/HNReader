//
//  DataManager.h
//  HNReader
//
//  Created by slim on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataManager : NSObject {
    
}
-(NSArray* ) getSavedPosts;

-(void) savePost:(NSDictionary*) post;
-(void) deletePost:(NSString*) url;
@end
