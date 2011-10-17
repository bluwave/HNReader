//
//  UIColor+HNColors.m
//  HNReader
//
//  Created by slim on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIColor+HNColors.h"


@implementation UIColor(HNColors)

+(UIColor*) HNLightBlue
{
    return [UIColor colorWithRed:33.0/255.0 green:163/255.0 blue:211/255.0 alpha:100];
}

+(UIColor*) HNDarkBlue
{
    return [UIColor colorWithRed:14/255.0 green:70/255.0 blue:120/255.0 alpha:100];
}

+(UIColor*) HNBlue
{
    return [UIColor colorWithRed:26/255.0 green:106/255.0 blue:178/255.0 alpha:100];
}


+(UIColor*) HNGreen
{
    return [UIColor colorWithRed:146/255.0 green:215/255.0 blue:42/255.0 alpha:100];
}

+(UIColor*) HNOrange
{
    return [UIColor colorWithRed:253/255.0 green:115/255.0 blue:4/255.0 alpha:100];
}
@end
