//
//  PannableViewController.h
//  PanViews
//
//  Created by slim on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Orientation.h"


@interface PannableViewController : UIViewController<UIGestureRecognizerDelegate> {
    CGFloat firstX;
    CGFloat firstY;
    int viewIndexInStack;
}

@property int viewIndexInStack;
@end
