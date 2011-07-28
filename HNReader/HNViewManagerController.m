//
//  HNViewManagerController.m
//  HNReader
//
//  Created by slim on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HNViewManagerController.h"
#import "HNReaderAppDelegate.h"

@interface HNViewManagerController()
- (void)orientationChanged:(NSNotification *)notification;
- (void) rotateTheScreen;
@end

@implementation HNViewManagerController
@synthesize _leftContainer, _rightContainer;
- (void)dealloc
{
    [_leftContainer release];
    [_rightContainer release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (void)orientationChanged:(NSNotification *)notification
{
    // We must add a delay here, otherwise we'll swap in the new view
	// too quickly and we'll get an animation glitch
    [self performSelector:@selector(rotateTheScreen) withObject:nil afterDelay:0];
}

- (void) rotateTheScreen
{
//    [viewManager notifyOrientationChange:[UIApplication sharedApplication].statusBarOrientation];

    NSLog(@"rotateTheScreen");
    CGRect frame = self.view.frame;
    
    if([[HNReaderAppDelegate instance] isOrientationPortrait] )
    {
        frame.size.width = 768;
        frame.size.height = 1004;        
    }
    else
    {
        frame.size.width = 1024;
        frame.size.height = 748;
    }
    self.view.frame = frame;
}
@end
