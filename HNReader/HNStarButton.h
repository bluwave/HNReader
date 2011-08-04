//
//  HNStarButton.h
//  HNReader
//
//  Created by slim on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HNStarButtonProtocol;

@interface HNStarButton : UIButton {
    BOOL _checked;
}

@property (retain,nonatomic) UIImage * _off;
@property (retain,nonatomic) UIImage * _on;
@property (retain,nonatomic) id<HNStarButtonProtocol> delegate;
-(void) toggleChecked:(BOOL) isChecked;

@end

@protocol HNStarButtonProtocol <NSObject>
-(void) HNStarButton:(HNStarButton*) button toggled:(BOOL) isChecked;
@end
