//
//  HNClient.m
//  HNReader
//
//  Created by slim on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HNClient.h"
#import "NSURLConnection+Blocks.h"
#import "HTMLParser.h"

#define kBaseUrl @"http://news.ycombinator.com"

@interface HNClient()
-(NSURLRequest*) getRequestWithUrl:(NSString*) url;
@end

@implementation HNClient
-(void) dealloc
{
    [super dealloc];
}
-(id) init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

-(void) getPosts:(void(^)(HttpResponse * resp, NSDictionary* posts)) complete
{
    NSString * nextId = @"";
    NSString * url = [NSString stringWithFormat:@"%@/news%@",kBaseUrl, nextId];
    NSURLRequest * req = [self getRequestWithUrl:url];

    NSLog(@"[HNClient] URL: %@", url);

    [NSURLConnection sendRequest:req completeBlock:^(HttpResponse *apiResponse) {
        NSDictionary * data = nil;
        if(!apiResponse.hasError)
        {
            HTMLParser * parser = [[HTMLParser alloc] initWithString:[apiResponse getStringFromRecievedData]];
            data  = [parser parsePosts];
        }
        complete(apiResponse, data);
    }];
    
}
-(NSURLRequest*) getRequestWithUrl:(NSString*) url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]] ;
	[request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    return request;
}
@end
