//
//  Created by slim on 8/19/11.
//
//  To change this template use File | Settings | File Templates.
//


#import "ViewManager.h"
#import "LeftViewController.h"


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

-(void) pushView:(PannableViewController *) view
{
    
    NSLog(@"[push] %@", view);
    [_views addObject:view];
    view.viewIndexInStack = [_views count];
    [_baseView addSubview:view.view];

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
@end