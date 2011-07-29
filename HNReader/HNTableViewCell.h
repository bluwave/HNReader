//
//  HNTableViewCell.h
//  HNReader
//
//  Created by slim on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HNTableViewCell : UITableViewCell {
    
}

@property(retain, nonatomic) IBOutlet UILabel * title;
@property(retain, nonatomic) IBOutlet UILabel * url;
@property(retain, nonatomic) IBOutlet UILabel * postDate;

@end
