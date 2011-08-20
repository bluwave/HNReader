//
//  ApiResponse.m
//  aramarkCustomer
//
//  Created by slim on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "HttpResponse.h"
#import "CJSONDeserializer.h"

@interface HttpResponse ()
@property(retain, nonatomic) NSData * receivedData;
-(void) evaluateError;
@end

@implementation HttpResponse
@synthesize error, receivedData, statusCode, apiErrorCode, hasError, errorMessage;

-(id) init
{
	[super init];
	return self;	
}
-(id) initWithStatusCode:(int) code withReceivedData:(NSData *) data;
{
	[super init];
	if(self)
	{
		self.statusCode = code;
		self.receivedData = data;
        [self evaluateError];
	}
	return self;
}
-(void) dealloc
{
	[receivedData release];
	[error release];
    [errorMessage release];
	[super dealloc];
}

-(void) evaluateError
{
	if (self.statusCode >= 300 ) 
	{
		self.hasError = YES;
	}
}

-(NSString*) getStringFromRecievedData
{
    NSString *data = [[[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding] autorelease];
    return data;
}
@end
