//
//  HNStoryDetailViewController.m
//  HNReader
//
//  Created by slim on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HNStoryDetailViewController.h"
#import "HNReaderAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define k_xOrigin 200

@interface HNStoryDetailViewController()
@property (retain, nonatomic) NSString * _currentTitle;
@property (retain, nonatomic) NSString * _currentUrl;
-(void) initView;
@end

@implementation HNStoryDetailViewController
@synthesize _webView;
@synthesize _titleBar;
@synthesize _spinner;
@synthesize _currentUrl, _currentTitle;
- (void)dealloc
{
    [_currentTitle release];
    [_currentUrl release];
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
    
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGesture.delegate = self;
    [_webView setUserInteractionEnabled:YES];
    [_webView addGestureRecognizer:swipeGesture];
    [swipeGesture release];
    
    
    if( ![MFMailComposeViewController canSendMail] )
    {
        // get rid of the email button
    }
    
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

#pragma mark helpers
-(void) initView
{
    CGRect frame = self.view.frame;
    frame.origin.x = ( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) )  ? 768 : 1048;

    frame.size.width = frame.origin.x - k_xOrigin;
    frame.size.height = ( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) )  ? 1004 : 748;
    self.view.frame = frame;
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result == MFMailComposeResultSent) 
    {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) sendMail:(id) sender
{

    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:[NSString stringWithFormat:@"[HN] %@", _currentTitle]];
    [controller setMessageBody:_currentUrl isHTML:YES];
    if (controller) [self presentModalViewController:controller animated:YES];
    [controller release];
}

#pragma mark public 
-(void) slideInWithUrl:(NSString * )url withTitle:(NSString *) title
{
    [self loadUrl:url]; 
    self._currentUrl = url;
    self._currentTitle = title;
    
    CGRect frame = self.view.frame;
    frame.origin.x = k_xOrigin;
    
    self._titleBar.title = title;
    
    [UIView animateWithDuration:0.4 animations:^(void) 
    {
        self.view.frame = frame;   
        
    } completion:^(BOOL finished) 
    {
        [UIView animateWithDuration:0.2 animations:^(void) 
        {
            self.view.clipsToBounds = NO;
            self.view.layer.masksToBounds = NO;
            [self.view.layer setShadowColor:[[UIColor blackColor] CGColor]];
            [self.view.layer setShadowOffset:CGSizeMake(-10.0, 10.0)];
            [self.view.layer setShadowOpacity:1.0];
            [self.view.layer setShadowRadius:15];
        } completion:^(BOOL finished) {
        }];
        
    }];
    
}
-(IBAction) close:(id) sender
{
    CGRect frame = self.view.frame;
    frame.origin.x = ( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) )  ? 768 : 1048;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)swipeRightAction:(UISwipeGestureRecognizer *)gestureRecognizer
{
    [self close:nil];
}
-(void) loadUrl:(NSString * ) url
{
    [_webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


#pragma mark orientation
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
