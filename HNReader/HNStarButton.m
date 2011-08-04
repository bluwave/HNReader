//
//  HNStarButton.m
//  HNReader
//
//  Created by slim on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HNStarButton.h"

#define OFF 0
#define ON 1


@interface HNStarButton()
-(UIImage*) getImage:(int) state;
-(void) starClicked;
-(void) _init;
@end

@implementation HNStarButton
@synthesize _on;
@synthesize _off;
@synthesize delegate;
- (void)dealloc
{
    [delegate release];
    [_on release];
    [_off release];
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
        [self _init];
	}
    
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self _init];
    }
    return self;
}

-(void) _init
{
    CGRect frame = self.frame;
    frame.size.width = 30;
    frame.size.height = 28;
    self.frame = frame;
    [self setImage:[self getImage:OFF] forState:UIControlStateNormal]; 
    [self addTarget:self action:@selector(starClicked) forControlEvents:UIControlEventTouchUpInside];
    _checked = NO;
    
}

-(void) starClicked
{
    if(!_checked)
    {
        _checked = YES;
        [self setImage:[self getImage:ON] forState:UIControlStateNormal];
    }
    else
    {
        _checked = NO;
        [self setImage:[self getImage:OFF] forState:UIControlStateNormal];
    }
    
    if(delegate && [delegate conformsToProtocol:@protocol(HNStarButtonProtocol) ] )
    {
        [delegate HNStarButton:self toggled:_checked];
    }
}

-(void) toggleChecked:(BOOL) isChecked
{
    if(isChecked)
    {
        _checked = YES;
        [self setImage:[self getImage:ON] forState:UIControlStateNormal];
    }
    else
    {
        _checked = NO;
        [self setImage:[self getImage:OFF] forState:UIControlStateNormal];
    } 
}

-(UIImage*) getImage:(int) state
{
    switch (state) {
        case ON:
            if(!_on)
            {
                self._on = [UIImage imageNamed:@"star_on.png"];
            }
            return _on;
            break;
        case OFF:
            if(!_off)
            {
                self._off = [UIImage imageNamed:@"star_off.png"];
            }
            return _off;
            break;
    }
    return nil;
}

@end
