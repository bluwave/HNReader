//
//  ApiResponse.m
//  aramarkCustomer
//
//  Created by slim on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//http://api.ihackernews.com/

#import "ApiResponse.h"
#import "SBJson.h"

@implementation ApiResponse
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
        
        NSString * errorDictStr = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSDictionary * errorDict = [errorDictStr JSONValue];
        
        if(errorDict)
		{
		
			NSString *detail = [errorDict objectForKey:@"Detail"];
			if (detail != nil) 
            {
				self.errorMessage = [[NSString alloc] initWithFormat:@"%@",detail];
                NSString * errorcode = [errorDict objectForKey:@"ErrorCode"];
                if(errorcode != nil)
                    self.apiErrorCode = [errorcode intValue];
			}   
		}
		else {
			switch (self.statusCode) {
				case 401:
					self.errorMessage = [[NSString alloc] initWithFormat:@"%d: Unauthorized error",self.statusCode];
					break;
				case 403:
					self.errorMessage = [[NSString alloc] initWithFormat:@"%d: Access Denied",self.statusCode];
					break;
				case 404:
					self.errorMessage = [[NSString alloc] initWithFormat:@"%d: Request Not Found",self.statusCode];
					break;
			}
		}
		self.errorMessage = [self.errorMessage stringByReplacingOccurrencesOfString:@"<BR>" withString:@"\n"];
	}
}
-(void) setConnectionError:(NSError*) nserror
{
    if(nserror != nil)
    {
        /*
         *  put this here b/c of the case where internet connection could bomb out 
         *  and status code could have already been set to 200, but there was an error 
         *  when recieving data or something... we don't want a status code of 200 and
         *  and error set
         */
        if(self.statusCode == 200)
            self.statusCode = 404;
        
        self.hasError = YES;
        self.error = nserror;
        self.errorMessage = [nserror localizedDescription];
    }
}

-(NSArray*) getArrayFromReceivedData
{

    NSString * str = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    return [str JSONValue];
}
-(NSDictionary*) getDictionaryFromReceivedData
{

    NSString * str = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    return [str JSONValue];
}

@end
