//
//  HNReaderViewController.h
//  HNReader
//
//  Created by slim on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HNBaseViewController;

@interface HNReaderViewController : UIViewController {
    
}

@property(retain, nonatomic) IBOutlet UIView * _left;
@property(retain, nonatomic) IBOutlet UIView * _right;
-(void) pushView:(HNBaseViewController*) view;
-(void) reloadList;
@end
