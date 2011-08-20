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
-(NSString* ) getSubmissionTypeStringFromType:(HNSubmissionType) type;
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

#pragma mark public request selectors
-(void) getPostsOfType:(HNSubmissionType) type WithMoreId:(NSString*) moreLink completeBlock:(void(^)(HttpResponse * resp, NSDictionary* posts)) complete;
{
    NSString * submissionType = nil;
    // if we don't have a moreLink (news.ycombinator.com/x?fnid=hkTVS5G4OD), then use the url like (i.e. news.ycombinator.com/newest , /news)
    if( ! moreLink )
        submissionType = [self getSubmissionTypeStringFromType:type];
    
    NSString * listTypeAndSection = (moreLink) ? moreLink : submissionType;
    NSString * url = [NSString stringWithFormat:@"%@%@",kBaseUrl, listTypeAndSection];
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
#pragma mark private helpers
-(NSURLRequest*) getRequestWithUrl:(NSString*) url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]] ;
	[request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    return request;
}


-(NSString* ) getSubmissionTypeStringFromType:(HNSubmissionType) type
{
    NSString * urlPiece = nil;
    switch (type) {
        case NEWS:
            urlPiece = @"/news";
            break;
        case NEW:
            urlPiece =@"/newest";
            break;
    }
    return urlPiece;
}
@end
