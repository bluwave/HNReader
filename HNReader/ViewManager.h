//
//  Created by slim on 8/19/11.
//
//  To change this template use File | Settings | File Templates.
//


#import <Foundation/Foundation.h>
#import "PannableViewController.h"

@interface ViewManager : NSObject {

}
-(id) initWithBaseView:(UIView*) baseView;

-(void) pushView:(PannableViewController *) view;

-(void) notifyViewsOfOrientationChange;

-(int) getViewsInStack;
@end