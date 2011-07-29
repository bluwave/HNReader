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
    
    // Release any cached data, images, etc that aren't in use.
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

@end
