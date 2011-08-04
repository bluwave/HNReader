//
//  SavedStory.h
//  HNReader
//
//  Created by slim on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SavedStory : NSManagedObject {
    
}
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * postedAgo;

@end
