//
//  NSURLConnection+Blocks.m
//  aramarkCustomer
//
//  Created by slim on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSURLConnection+Blocks.h"


@interface NSURLConnectionBlocksAddtionDelegate : NSObject 
{

@private
    NSMutableData *receivedData;
    void (^completeBlock)( HttpResponse *apiResponse );
    int statusCode;
}

- (id)initWithCompleteBlock:( void (^)( HttpResponse *resp) )compelete ;

@end

@implementation NSURLConnectionBlocksAddtionDelegate

- (id)initWithCompleteBlock:( void (^)( HttpResponse * resp ) )compelete
{
    self = [super init];
    if ( self ) 
    {
        receivedData = [[NSMutableData alloc] init];
        completeBlock = [compelete copy];
    }
    return self;
}

- (void)dealloc 
{

    [completeBlock release];
    [receivedData release];
    [super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{   
	if([response isKindOfClass:[NSHTTPURLResponse class]])
        statusCode = [(NSHTTPURLResponse*)response statusCode];
    
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    HttpResponse * resp = [[HttpResponse alloc] initWithStatusCode:statusCode withReceivedData:receivedData];
    completeBlock( resp );
    [resp release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

    HttpResponse * resp = [[HttpResponse alloc] initWithStatusCode:statusCode withReceivedData:receivedData];
    resp.statusCode = 400;
    resp.error = error;
    resp.errorMessage = [error localizedDescription];
    completeBlock( resp );
    [resp release];
}

@end

@implementation NSURLConnection (BlocksAddition)

+ (void)sendRequest:(NSURLRequest *)request completeBlock:( void (^)( HttpResponse *response ) )complete
{
    id delegate = [[[NSURLConnectionBlocksAddtionDelegate alloc] initWithCompleteBlock:complete ] autorelease];
    [self connectionWithRequest:request delegate:delegate];
}

@end
