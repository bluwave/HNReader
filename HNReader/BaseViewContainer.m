//
//  BaseViewContainer.m
//  PanViews
//
//  Created by slim on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewContainer.h"


@interface BaseViewContainer()
@property(retain, nonatomic) ViewManager * _viewManager;
@end

@implementation BaseViewContainer
@synthesize _viewManager;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_viewManager dealloc];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self._viewManager= [[ViewManager alloc] initWithBaseView:self.view];
    
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
    [self performSelector:@selector(rotateTheScreen) withObject:nil afterDelay:0];
}

- (void) rotateTheScreen
{
    [_viewManager notifyViewsOfOrientationChange];
}

-(ViewManager*) getViewManager
{
    return _viewManager;
}

@end
