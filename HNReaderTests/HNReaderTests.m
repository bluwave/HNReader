//
//  HNReaderTests.m
//  HNReaderTests
//
//  Created by slim on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HNReaderTests.h"
#import "HNClient.h"

#define kMAXSLEEPCOUNT 17

@implementation HNReaderTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


-(void) testGetNewsArticles
{
    __block BOOL testCompleted = NO;
    HNClient * client = [[HNClient alloc] init];
    [client getPosts:^(HttpResponse *resp, NSDictionary *data) 
    {
        NSArray * posts = [data objectForKey:@"posts"];
        STAssertTrue([posts count] > 0, @"recieved no posts");
        
        NSString * next = [data objectForKey:@"next"];
        STAssertNotNil(next, @"could not parse next link");
        
        //        NSLog(@"posts %@", posts);
        testCompleted = YES;
    }];
     
     int sleepCnt = 0;
     while (!testCompleted) 
     {
         // This executes another run loop.
         [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
         usleep(10000);
         sleepCnt++;
         if(sleepCnt > kMAXSLEEPCOUNT)
         {
             testCompleted= YES;
             STFail(@"api not responding");
         }
         
     }
}
@end
