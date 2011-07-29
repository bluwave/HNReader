//
//  HNStoryDetailViewController.h
//  HNReader
//
//  Created by slim on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNBaseViewController.h"

@interface HNStoryDetailViewController : HNBaseViewController {
    
}
@property(retain, nonatomic) IBOutlet UIWebView * _webView;

-(void) loadUrl:(NSString * ) url;
-(void) slideInWithUrl:(NSString *) url;
@end
