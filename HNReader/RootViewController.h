//
//  RootViewController.h
//  HNReader
//
//  Created by slim on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {

}

		
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property(retain, nonatomic) NSMutableArray * newsPosts;
-(void) getNews;
@end
