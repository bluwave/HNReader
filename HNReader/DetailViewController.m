//
//  DetailViewController.m
//  HNReader
//
//  Created by slim on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

#import "RootViewController.h"
#import "HNReaderAppDelegate.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize toolbar=_toolbar;

@synthesize detailItem=_detailItem;

@synthesize detailDescriptionLabel=_detailDescriptionLabel;

@synthesize popoverController=_myPopoverController;

@synthesize webView;

@synthesize containerView;
#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    [[HNReaderAppDelegate instance] toggleSpinner:YES withView:self.view withLabel:@"Loading..." withDetailLabel:@"Please wait"];
    NSURLRequest * requ = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_detailItem]];
    [self.webView loadRequest:requ];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.autoresizingMask =0;
    
    CGRect frame =  self.view.frame;
    frame.size.height = 300;
    self.view.frame = frame;
    
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    self.webView.scalesPageToFit = YES;
    
    NSLog(@"details viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Events";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
    
    self.containerView.autoresizingMask = 0;
    CGRect frame = self.containerView.frame;
    NSLog(@"PORTRAIT: width: %f height: %f", frame.size.width, frame.size.height);
    frame.size.height = 900;
    self.containerView.backgroundColor = [UIColor greenColor];
    self.containerView.frame = frame;

}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;

//    self.containerView.autoresizingMask = 0;
    CGRect frame = self.containerView.frame;
    NSLog(@"LANDSCAPE: width: %f height: %f", frame.size.width, frame.size.height);
    frame.size.height = 400;
    self.containerView.backgroundColor = [UIColor redColor];
    self.containerView.frame = frame;

}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
 */

- (void)viewDidUnload
{
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	self.containerView = nil;
    self.webView = nil;
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [containerView release];
    [webView release];
    [_myPopoverController release];
    [_toolbar release];
    [_detailItem release];
    [_detailDescriptionLabel release];
    [super dealloc];
}




-(void)webViewDidFinishLoad:(UIWebView *)wv
{
    [[HNReaderAppDelegate instance] toggleSpinner:NO withView:nil withLabel:nil withDetailLabel:nil];
}
@end
