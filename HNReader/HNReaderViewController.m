//
//  HNReaderViewController.m
//  HNReader
//
//  Created by slim on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HNReaderViewController.h"
#import "HNNewsListViewController.h"
@interface HNReaderViewController()
@property(retain, nonatomic) NSMutableArray * _viewsToNotifyOfOrientationChange;
@end


@implementation HNReaderViewController
@synthesize _left, _right;
@synthesize _viewsToNotifyOfOrientationChange;

- (void)dealloc
{
    [_viewsToNotifyOfOrientationChange release];
    [_right release];
    [_left release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];

    self._viewsToNotifyOfOrientationChange = [[NSMutableArray alloc] init ];
    
    HNNewsListViewController * list = [[HNNewsListViewController alloc] initWithNibName:@"HNNewsListViewController" bundle:nil];
    [self.view addSubview:list.view];
    [_viewsToNotifyOfOrientationChange addObject:list];
    [list release];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
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
    CGRect lf = self._left.frame;
    if( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) )
    {
        lf.size.width = 768;
        lf.size.height = 1004;
    }
    else
    {
        lf.size.width = 1024;
        lf.size.height = 748;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    self._left.frame = lf;
    [UIView commitAnimations];
    
    
    for(HNBaseViewController * v in _viewsToNotifyOfOrientationChange)
    {
        if([v respondsToSelector:@selector(rotate:)])
            [v rotate:[UIDevice currentDevice].orientation];
    }
}


@end
