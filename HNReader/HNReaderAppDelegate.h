//
//  HNReaderAppDelegate.h
//  HNReader
//
//  Created by slim on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressSpinner.h"

@class RootViewController;

@class DetailViewController;

@interface HNReaderAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property(retain,nonatomic) ProgressSpinner * progressSpinner;
+(HNReaderAppDelegate *) instance;
-(void) toggleSpinner:(BOOL)sFlag withView:(UIView*) view withLabel:(NSString*) label withDetailLabel:(NSString*) detail;
@end
