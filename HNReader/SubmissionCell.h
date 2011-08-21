//
//  SubmissionCell.h
//  HNReader
//
//  Created by slim on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubmissionCell : UITableViewCell {
    
}


@property(retain,nonatomic) IBOutlet UILabel * title;
@property(retain,nonatomic) IBOutlet UILabel * url;
@property(retain,nonatomic) IBOutlet UILabel * points;
@property(retain,nonatomic) IBOutlet UILabel * submitter;
@property(retain,nonatomic) IBOutlet UILabel * comments;
@property(retain,nonatomic) IBOutlet UILabel * timeSubmitted;
-(void) loadWithDictionary:(NSDictionary*) dict;
@end
