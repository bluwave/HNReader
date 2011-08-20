//
//  ApiResponse.h
//  aramarkCustomer
//
//  Created by slim on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpResponse : NSObject {

    int statusCode;
    BOOL hasError;
    int apiErrorCode;

}

@property int statusCode;
@property BOOL hasError;
@property int apiErrorCode;
@property(retain, nonatomic) NSError * error;
@property(retain, nonatomic) NSString * errorMessage;
-(id) initWithStatusCode:(int) code withReceivedData:(NSData *) data;
-(NSString*) getStringFromRecievedData;
@end
