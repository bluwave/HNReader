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
    [client getPostsOfType:NEWS WithMoreId:nil completeBlock:^(HttpResponse *resp, NSDictionary *data) 
    {
        NSArray * posts = [data objectForKey:@"posts"];
        STAssertTrue([posts count] > 0, @"recieved no posts");
        
        NSString * next = [data objectForKey:@"more"];
        STAssertNotNil(next, @"could not parse next link");
        
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

-(void) testGetNewsArticlesUsingNextLink
{
    __block BOOL testCompleted = NO;
    HNClient * client = [[HNClient alloc] init];
    [client getPostsOfType:NEWS WithMoreId:nil  completeBlock:^(HttpResponse *resp, NSDictionary *data) 
     {
         NSArray * posts = [data objectForKey:@"posts"];
         STAssertTrue([posts count] > 0, @"recieved no posts");
         
         NSString * next = [data objectForKey:@"more"];
         STAssertNotNil(next, @"could not parse next link");
         
         HNClient * client2 = [[HNClient alloc] init];
         [client getPostsOfType:NEWS WithMoreId:next completeBlock:^(HttpResponse *resp2, NSDictionary *data2) 
          {
              NSArray * posts2 = [data2 objectForKey:@"posts"];
              STAssertTrue([posts2 count] > 0, @"recieved no posts");
              
              NSString * title = [[posts objectAtIndex:0] objectForKey:@"title"];
              NSString * title2 = [[posts2 objectAtIndex:0] objectForKey:@"title"];
              
              STAssertFalse([title isEqual:title2], @"titles should not be equal: %@ %@", title, title2);
              
              NSString * next2 = [data objectForKey:@"more"];
              STAssertNotNil(next2, @"could not parse next link");
              testCompleted = YES;
          }];
         [client2 release];
     }];
    
    int sleepCnt = 0;
    while (!testCompleted) 
    {
        // This executes another run loop.
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
        sleepCnt++;
        if(sleepCnt > kMAXSLEEPCOUNT*2)
        {
            testCompleted= YES;
            STFail(@"api not responding");
        }
        
    }
}


-(void) testGet_NEW_ArticlesUsingNextLink
{
    __block BOOL testCompleted = NO;
    HNClient * client = [[HNClient alloc] init];
    [client getPostsOfType:NEW WithMoreId:nil  completeBlock:^(HttpResponse *resp, NSDictionary *data) 
     {
         NSArray * posts = [data objectForKey:@"posts"];
         STAssertTrue([posts count] > 0, @"recieved no posts");
         
         NSString * next = [data objectForKey:@"more"];
         STAssertNotNil(next, @"could not parse next link");
         
         HNClient * client2 = [[HNClient alloc] init];
         [client getPostsOfType:NEW WithMoreId:next completeBlock:^(HttpResponse *resp2, NSDictionary *data2) 
          {
              NSArray * posts2 = [data2 objectForKey:@"posts"];
              STAssertTrue([posts2 count] > 0, @"recieved no posts");
              
              NSString * title = [[posts objectAtIndex:0] objectForKey:@"title"];
              NSString * title2 = [[posts2 objectAtIndex:0] objectForKey:@"title"];
              
              STAssertFalse([title isEqual:title2], @"titles should not be equal: %@ %@", title, title2);
              
              NSString * next2 = [data objectForKey:@"more"];
              STAssertNotNil(next2, @"could not parse next link");
              testCompleted = YES;
          }];
         [client2 release];
     }];
    
    int sleepCnt = 0;
    while (!testCompleted) 
    {
        // This executes another run loop.
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
        sleepCnt++;
        if(sleepCnt > kMAXSLEEPCOUNT*2)
        {
            testCompleted= YES;
            STFail(@"api not responding");
        }
        
    }
}
@end
