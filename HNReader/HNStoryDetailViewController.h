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
#import "HNNewsListViewController.h"
#import "HNStarButton.h"

@interface HNStoryDetailViewController : HNBaseViewController<MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate, HNStarButtonProtocol> {
    BOOL _isFullScreen;
    BOOL _closed;
}
@property(retain, nonatomic) IBOutlet UIWebView * _webView;
@property(retain, nonatomic) IBOutlet UINavigationItem * _titleBar;
@property(retain, nonatomic) IBOutlet UIActivityIndicatorView * _spinner;
@property(retain, nonatomic) IBOutlet UIImageView * _tab;
@property(retain, nonatomic) IBOutlet UILabel * _tabText;
@property(retain, nonatomic) IBOutlet UIBarButtonItem * _spacer;
@property(retain, nonatomic) HNNewsListViewController * delegate;
@property(retain,nonatomic) IBOutlet HNStarButton * star;
-(void) loadUrl:(NSString * ) url;
-(void) slideInWithUrl:(NSString * )url withTitle:(NSString *) title;
-(IBAction) close:(id) sender;
-(IBAction) sendMail:(id) sender;
-(IBAction) toggleFullScreen:(id) sender;
@end
