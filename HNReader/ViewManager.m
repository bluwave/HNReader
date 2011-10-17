//
//  Created by slim on 8/19/11.
//
//  To change this template use File | Settings | File Templates.
//


#import "ViewManager.h"
#import "LeftViewController.h"
#import "UIView+Orientation.h"
#import "SubmissionListViewController.h"


@interface ViewManager()
@property(retain, nonatomic) NSMutableArray * _views;
@property(retain, nonatomic) UIView * _baseView;
@property(retain, nonatomic) UIViewController * _leftView;
@end
@implementation ViewManager
@synthesize _views;
@synthesize _baseView;
@synthesize _leftView;

-(void) dealloc
{
    [_views release];
    [_baseView release];
    [_leftView release];
    [super dealloc];
}
-(id) initWithBaseView:(UIView*) baseView
{
    self = [super init];
    if (self) 
    {
        self._views = [[NSMutableArray alloc] init];
        self._baseView = baseView;
        self._leftView = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
        [_baseView addSubview:_leftView.view];
    }
    return self;
}

#define kPaddingBetweenViews 40


-(void) pushView:(PannableViewController *) view
{
    
    NSLog(@"[push] %@", view);
    view.viewIndexInStack = [_views count];
    [_views addObject:view];
    
    CGRect frame = view.view.frame;
    
    frame.origin.x = 2000;
    view.view.frame = frame;
    
    int startPt = 320;
//    frame.origin.x = ([UIView isOrienationPortait]) ? 0 : 0 ;
    frame.origin.x = startPt + (view.viewIndexInStack * kPaddingBetweenViews);
    frame = [view updateBounds:frame];
    [_baseView addSubview:view.view];
    
    [UIView transitionWithView:view.view duration:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^
    {
        view.view.frame = frame;
    } completion:^(BOOL finished) 
    {
        [view didFinishSlidingIn];
    }];
}

-(void) notifyViewsOfOrientationChange
{
    [_leftView willRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.0];
    for(PannableViewController * pv in _views)
    {
        [pv willRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.0];
    }
}
-(int) getViewsInStack
{
    return [_views count];
}

-(void) openView:(int) view
{
    switch (view) 
    {
        case 0:
        {
            SubmissionListViewController * list = [[SubmissionListViewController alloc] initWithNibName:@"SubmissionListViewController" bundle:nil];
            [self pushView:list];
            [list release];
            break;
        }
        case 1:
            break;
    }
}
@end