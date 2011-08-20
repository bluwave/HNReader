//
//  HTMLParser.h
//  HNReader
//
//  Created by slim on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTMLParser : NSObject {
    
}
-(id) initWithString:(NSString*) data;
-(NSMutableDictionary*) parsePosts;
@end
