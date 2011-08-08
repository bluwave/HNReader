//
//  HNClient.m
//  HNReader
//
//  Created by slim on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HNClient.h"
#import "NSURLConnection+Blocks.h"
@interface HNClient()
-(NSURLRequest*) getRequestWithUrl:(NSString*) url;
-(void) handleRequestWithUrl:(NSString*) url withCompleteBlock:(void (^)(ApiResponse * resp) )complete;
@end

@implementation HNClient

-(id) init
{
	self = [super init];
    if(self)
    {
        
    }
	return self;	
}

-(void) dealloc
{
	[super dealloc];
}


#pragma mark helpers
-(NSURLRequest*) getRequestWithUrl:(NSString*) url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]] retain];
    
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    return request;
}

-(void) handleRequestWithUrl:(NSString*) url withCompleteBlock:(void (^)(ApiResponse * resp) )complete
{
    NSURLRequest * request;
    request = [self getRequestWithUrl:url];        
    
    NSLog(@"%@", url);
    
    [NSURLConnection sendRequest:request completeBlock:complete ];
    [request release];
    
}

-(void) getNews:(NSString*) nextId withType:(int) whichType withCompleteBlock:(void (^)(ApiResponse * resp) )complete
{
    NSString * type = (whichType == 1) ? @"new" : @"page"; 
    
    NSString * next = (nextId) ? [NSString stringWithFormat:@"/%@", nextId] : @"";
    NSString * url = [NSString stringWithFormat:@"http://api.ihackernews.com/%@%@", type , next];
    [self handleRequestWithUrl:url withCompleteBlock:complete];
}
@end
