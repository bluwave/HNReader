//
//  HNStoryDetailViewController.h
//  HNReader
//
//  Created by slim on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNBaseViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface HNStoryDetailViewController : HNBaseViewController<MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate> {
    BOOL _isFullScreen;
}
@property(retain, nonatomic) IBOutlet UIWebView * _webView;
@property(retain, nonatomic) IBOutlet UINavigationItem * _titleBar;
@property(retain, nonatomic) IBOutlet UIActivityIndicatorView * _spinner;
@property(retain, nonatomic) IBOutlet UIImageView * _tab;
@property(retain, nonatomic) IBOutlet UILabel * _tabText;
@property(retain, nonatomic) IBOutlet UIBarButtonItem * _spacer;

-(void) loadUrl:(NSString * ) url;
-(void) slideInWithUrl:(NSString * )url withTitle:(NSString *) title;
-(IBAction) close:(id) sender;
-(IBAction) sendMail:(id) sender;
-(IBAction) toggleFullScreen:(id) sender;
@end
