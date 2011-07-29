//
//  HNReaderAppDelegate.m
//  HNReader
//
//  Created by slim on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HNReaderAppDelegate.h"

#import "HNReaderViewController.h"

@implementation HNReaderAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

@synthesize progressSpinner;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [progressSpinner release];
    [_window release];
    [_viewController release];
    [super dealloc];
}
+(HNReaderAppDelegate *) instance
{
    return (HNReaderAppDelegate*) [[UIApplication sharedApplication] delegate];
}
-(void) toggleSpinner:(BOOL)sFlag withView:(UIView*) view withLabel:(NSString*) label withDetailLabel:(NSString*) detail
{
    if(self.progressSpinner == nil && view != nil)
    {
        self.progressSpinner = [[ProgressSpinner alloc] initWithView:view];
        
        // Add theSpinner to screen
        [_window addSubview:self.progressSpinner];
    }
    
    if(label != nil)
        self.progressSpinner.labelText = label;
    if(detail != nil)
        self.progressSpinner.detailsLabelText = detail;
    
    if(sFlag)
        [self.progressSpinner show:YES];
    else if(progressSpinner != nil)
    {
        [self.progressSpinner show:NO];
        
        [self.progressSpinner hide:YES];
        
        [self.progressSpinner removeFromSuperview];
        [self.progressSpinner release];
        self.progressSpinner = nil;
    }
    
    
}

- (BOOL) isOrientationPortrait
{
    
    if(([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft )||
       ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ))
        return NO;
    else
        return YES;
}
@end
