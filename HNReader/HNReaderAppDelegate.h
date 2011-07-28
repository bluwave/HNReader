//
//  HNReaderAppDelegate.h
//  HNReader
//
//  Created by slim on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressSpinner.h"

@class HNViewManagerController;

@interface HNReaderAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet HNViewManagerController * viewManager;

@property(retain,nonatomic) ProgressSpinner * progressSpinner;
+(HNReaderAppDelegate *) instance;
-(void) toggleSpinner:(BOOL)sFlag withView:(UIView*) view withLabel:(NSString*) label withDetailLabel:(NSString*) detail;
- (BOOL) isOrientationPortrait;
@end
