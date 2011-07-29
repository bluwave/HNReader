//
//  HNStoryDetailViewController.m
//  HNReader
//
//  Created by slim on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HNStoryDetailViewController.h"
#import "HNReaderAppDelegate.h"

#define k_xOrigin 200

@interface HNStoryDetailViewController()
-(void) initView;
@end

@implementation HNStoryDetailViewController
@synthesize _webView;
@synthesize _titleBar;
@synthesize _spinner;
- (void)dealloc
{
    [_spinner release];
    [_titleBar release];
    [_webView release];
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
    
    [self initView];
    self._webView.contentMode = UIViewContentModeScaleAspectFit;
    self._webView.scalesPageToFit = YES;
    _spinner.hidden = NO;
    
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

#pragma mark webview delegates
-(void)webViewDidFinishLoad:(UIWebView *)wv
{
    _spinner.hidden = YES;
    [[HNReaderAppDelegate instance] toggleSpinner:NO withView:nil withLabel:nil withDetailLabel:nil];    
}

-(void) initView
{
    CGRect frame = self.view.frame;
    frame.origin.x = ( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) )  ? 768 : 1048;

    frame.size.width = frame.origin.x - k_xOrigin;
    frame.size.height = ( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) )  ? 1004 : 748;
    self.view.frame = frame;
}

-(void) slideInWithUrl:(NSString * )url withTitle:(NSString *) title
{
    [self loadUrl:url];

    CGRect frame = self.view.frame;
    frame.origin.x = k_xOrigin;
    
    self._titleBar.title = title;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^(void) {
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}
-(void) loadUrl:(NSString * ) url
{
    [_webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

-(void) rotate:(UIInterfaceOrientation) orientation
{
    CGRect frame = self.view.frame;
    if( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) )
    {
        frame.size.width = 768 - k_xOrigin;
        frame.size.height = 1004;
    }
    else
    {
        frame.size.width = 1048 - k_xOrigin;;
        frame.size.height = 748;
    }
    self.view.frame = frame;
}


@end
