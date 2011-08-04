//
//  HNNewsListViewController.h
//  HNReader
//
//  Created by slim on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNBaseViewController.h"
#import "HNStarButton.h"
typedef enum VIEW{FRONTPAGE, NEW, SAVED } ViewState;

@interface HNNewsListViewController : HNBaseViewController <HNStarButtonProtocol>
{
    ViewState _viewState;
}
@property(retain, nonatomic) IBOutlet UITableView * _tableView;
-(void) reload;
-(IBAction) segmentIndexChanged:(id)sender;
@end
