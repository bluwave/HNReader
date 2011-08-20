//
//  UIColor+SWColors.m
//  SeamlessHD
//
//  Created by slim on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+Orientation.h"

@implementation UIView (SWColors)
+(CGRect) getOrientationSizing
{
    // portrait
    CGRect rect = CGRectMake(0, 0, 768, 1004);
    if(([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft )||
       ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ))
    {
        // landscape
        rect = CGRectMake(0, 0, 1024, 748);
    }
    return rect;
}
+(BOOL) isOrienationPortait
{
    if(([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft )||
       ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ))
        return NO;
    return YES;
}
@end
