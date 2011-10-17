//
//  PannableViewController.m
//  PanViews
//
//  Created by slim on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PannableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HNReaderAppDelegate.h"

#define kMaxLeft_X 150
#define kStackSizeIncrement 10
#define kWiggleRoom 20

@interface PannableViewController()
-(void) handlePan:(UIGestureRecognizer *) gesture ;
@end

@implementation PannableViewController
@synthesize viewIndexInStack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        viewIndexInStack = -1;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void) loadView
{
    [super loadView];
    
    NSLog(@"[PannableVC] loadView");
    self.view.layer.cornerRadius = 20;
    
    self.view.clipsToBounds = NO;
    self.view.layer.masksToBounds = NO;
    [self.view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.view.layer setShadowOffset:CGSizeMake(1, 1) ];
    [self.view.layer setShadowOpacity:  0.65];
    [self.view.layer setShadowRadius: 8 ];
    
    
    CGRect orFrame = [UIView getOrientationSizing];
    NSLog(@"[PannableVC]=>initWithNib %@ %f %f", [UIView isOrienationPortait] ? @"portrait" : @"landscape", orFrame.size.width, orFrame.size.height);
    CGRect frame = self.view.frame;
    
    frame.origin.x = orFrame.size.width + 500; // in case of any shadows or unclipped bounds we are unaware of 

    frame.size.height= orFrame.size.height;
    frame.size.width = 320;
    
    
    self.view.frame = frame;
    
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setDelegate:self];
    [self.view addGestureRecognizer:panGesture];    
    [panGesture release];
    

}


- (void)viewDidLoad
{
    NSLog(@"[PannableVC] viewDidLoad");
    [super viewDidLoad];

    CGRect frame = self.view.frame;
    NSLog(@"[PannableVC]=>viewDidLoad x: %f", frame.origin.x);
    frame.origin.x = 318;
    [UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        self.view.frame = frame;
    } completion:^(BOOL finished) {
       
    }];
    
    
    
    
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
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect oFrame = [UIView getOrientationSizing];
    CGRect frame =self.view.frame;
    frame.size.height = oFrame.size.height;
    self.view.frame = frame;
}

-(CGRect) updateBounds:(CGRect) frame
{
    CGRect oFrame = [UIView getOrientationSizing];
    frame.size.width = oFrame.size.width - frame.origin.x;
    frame.size.height = oFrame.size.height;
    return frame;
}

-(void) didFinishSlidingIn
{
    
}


#pragma mark panning handler
-(void) handlePan:(UIPanGestureRecognizer *) gesture 
{

    [[[gesture view] layer] removeAllAnimations];    

    CGFloat half = [gesture view].frame.size.width / 2;
    CGFloat pointToNotCross = kMaxLeft_X + half;
    
//	[self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
	CGPoint translatedPoint = [gesture translationInView:self.view];
    
	if([gesture state] == UIGestureRecognizerStateBegan) {
        
		firstX = [[gesture view] center].x;
		firstY = [[gesture view] center].y;
	}

    CGFloat intermediatePoint = firstX + translatedPoint.x;
    if(intermediatePoint < pointToNotCross)
        intermediatePoint = pointToNotCross + kWiggleRoom;
    
	translatedPoint = CGPointMake(intermediatePoint, firstY);
    
	[[gesture view] setCenter:translatedPoint];
    
	if([gesture state] == UIGestureRecognizerStateEnded) 
    {
        
		CGFloat finalX = translatedPoint.x + (.18*[gesture velocityInView:self.view].x);
		CGFloat finalY = translatedPoint.y ;

        CGFloat virtualPoint = (kStackSizeIncrement * viewIndexInStack);
        if(finalX < pointToNotCross +  virtualPoint )
        {
            finalX = pointToNotCross + virtualPoint;
        }
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.18];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[[gesture view] setCenter:CGPointMake(finalX, finalY)];
		[UIView commitAnimations];
	}

    
}

#pragma mark private helpers


@end
