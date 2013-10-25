//
//  BlahButton.m
//  MFPButton
//
//  Created by Nick Baicoianu on 8/6/13.
//  Copyright (c) 2013 MeanFreePath LLC. All rights reserved.
//

#import "BlahButton.h"

@implementation BlahButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextFillRect(context, rect);
}


@end
