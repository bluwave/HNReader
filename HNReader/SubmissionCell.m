//
//  SubmissionCell.m
//  HNReader
//
//  Created by slim on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubmissionCell.h"


@implementation SubmissionCell
@synthesize title, url, submitter,points, comments, timeSubmitted;
- (void)dealloc
{
    [title release];
    [url release];
    [submitter release];
    [points release];
    [comments release];
    [timeSubmitted release];
    [super dealloc];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.title.lineBreakMode = UILineBreakModeWordWrap;
        self.title.numberOfLines = 0;  
        self.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"brown_bg.png"]] autorelease];
    }
    return self;
}

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

    // Configure the view for the selected state
}

-(void) loadWithDictionary:(NSDictionary*) dict
{
    self.title.text = [dict objectForKey:@"title"];
    self.url.text = [dict objectForKey:@"url"];
    self.points.text = [NSString stringWithFormat:@"%d points", [[dict objectForKey:@"points"]intValue]];
    self.submitter.text = [NSString stringWithFormat:@"submitted by %@",  [dict objectForKey:@"user"]];
    self.comments.text =  [NSString stringWithFormat:@"%d comments",[[dict objectForKey:@"numchildren"] intValue]];
    self.timeSubmitted.text = [NSString stringWithFormat:@"%@ ago", [dict objectForKey:@"date"]];
}

@end
