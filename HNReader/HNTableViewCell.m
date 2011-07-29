//
//  HNTableViewCell.m
//  HNReader
//
//  Created by slim on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HNTableViewCell.h"


@implementation HNTableViewCell
@synthesize title, url, postDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.title.highlightedTextColor = [UIColor whiteColor];
    self.url.highlightedTextColor = [UIColor orangeColor];
    self.postDate.highlightedTextColor = [UIColor whiteColor];
}

- (void)dealloc
{
    [title release];
    [postDate release];
    [url release];
    [super dealloc];
}

@end
