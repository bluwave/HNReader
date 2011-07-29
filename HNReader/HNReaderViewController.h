//
//  HNReaderViewController.h
//  HNReader
//
//  Created by slim on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNReaderViewController : UIViewController {
    
}

@property(retain, nonatomic) IBOutlet UIView * _left;
@property(retain, nonatomic) IBOutlet UIView * _right;
-(void) showUrl:(NSString*) url withTitle:(NSString *) title;
@end
