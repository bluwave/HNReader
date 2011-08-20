//
//  HNReaderAppDelegate.h
//  HNReader
//
//  Created by slim on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressSpinner.h"

@class BaseViewContainer;

@interface HNReaderAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet BaseViewContainer *viewController;

@property(retain,nonatomic) ProgressSpinner * progressSpinner;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// core data selectors
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(HNReaderAppDelegate *) instance;
-(void) toggleSpinner:(BOOL)sFlag withView:(UIView*) view withLabel:(NSString*) label withDetailLabel:(NSString*) detail;
- (BOOL) isOrientationPortrait;
-(UIView*) getBaseView;
@end
