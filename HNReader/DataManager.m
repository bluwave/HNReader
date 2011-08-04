//
//  DataManager.m
//  HNReader
//
//  Created by slim on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "HNReaderAppDelegate.h"
#import "SavedStory.h"
@interface DataManager()
@property(retain, nonatomic) NSManagedObjectContext * _ctx;
@property(retain, nonatomic) NSFetchRequest * _savedFetchReq;
@end

@implementation DataManager
@synthesize _ctx;
@synthesize _savedFetchReq;
-(void)dealloc
{
    [_ctx release];
    [_savedFetchReq release];
    [super dealloc];
}
-(id) init
{
    self = [super init];
    if (self) 
    {
        
        self._ctx = [HNReaderAppDelegate instance].managedObjectContext;
        self._savedFetchReq = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SavedStory" inManagedObjectContext:self._ctx];
        [self._savedFetchReq setEntity:entity];

    }
    return self;
}

-(NSArray* ) getSavedPosts
{
    NSError *error;
    NSMutableArray * posts = [NSMutableArray array];
    NSArray * saved = [_ctx executeFetchRequest:_savedFetchReq error:&error];
    for(NSManagedObject * mo in saved)
    {
        NSArray *keys = [[[mo entity] attributesByName] allKeys];
        NSDictionary *dict = [mo dictionaryWithValuesForKeys:keys];
        [posts addObject:dict];
    }
    return posts;    
}
-(void) savePost:(NSDictionary*) post
{
    
    NSError * error = nil;
    NSString * posturl = [post objectForKey:@"url"];
    NSPredicate * filter = [NSPredicate predicateWithFormat:@" url == %@ ", posturl];
    NSArray * savedPosts = [_ctx executeFetchRequest:_savedFetchReq error:&error];
    NSArray * starredAlreadyPosts = [savedPosts filteredArrayUsingPredicate:filter];
    
    if([starredAlreadyPosts count] == 0)
    {
        NSEntityDescription * desc = [NSEntityDescription entityForName:@"SavedStory" inManagedObjectContext:_ctx];
        SavedStory * story = [[SavedStory alloc] initWithEntity:desc insertIntoManagedObjectContext:_ctx];
        
       [story setValuesForKeysWithDictionary:post];
        
        if (![_ctx save:&error]) 
        {
            NSLog(@"error saving post, couldn't save: %@", [error localizedDescription]);
        }
    }
}
-(void) deletePost:(NSString*) url
{
    NSError * error = nil;
    NSArray * savedPosts = [_ctx executeFetchRequest:_savedFetchReq error:&error];
    NSPredicate * filter = [NSPredicate predicateWithFormat:@" url == %@ ", url];
    NSArray * starredAlreadyPosts = [savedPosts filteredArrayUsingPredicate:filter];
    if([starredAlreadyPosts count] == 1)
    {
        [_ctx deleteObject:[starredAlreadyPosts objectAtIndex:0]];
        if (![_ctx save:&error]) 
        {
            NSLog(@"could not delete object: %@", [error userInfo] );
        }
    }
}
@end
