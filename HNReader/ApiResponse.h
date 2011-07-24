//
//  ApiResponse.h
//  aramarkCustomer
//
//  Created by slim on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ApiResponse : NSObject {

    int statusCode;
    BOOL hasError;
    int apiErrorCode;

}
@property(retain, nonatomic) NSData * receivedData;
@property int statusCode;
@property BOOL hasError;
@property int apiErrorCode;
@property(retain, nonatomic) NSError * error;
@property(retain, nonatomic) NSString * errorMessage;
-(void) evaluateError;
-(id) initWithStatusCode:(int) code withReceivedData:(NSData *) data;
-(void) setConnectionError:(NSError*) nserror;
-(NSArray*) getArrayFromReceivedData;
-(NSDictionary*) getDictionaryFromReceivedData;
@end
