//
//  MFPGradientButton.m
//  MFPButton
//
//  Created by Nick Baicoianu on 8/6/13.
//  Copyright (c) 2013 MeanFreePath LLC. All rights reserved.
//

#import "MFPGradientButton.h"
static CGGradientRef fillGradient, maskGradient;

@implementation MFPGradientButton

+ (void) load {
	//initialize the center fill gradient
	CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
	CGFloat locations[2] = { 0.0f, 1.0f };
	CGFloat components[8] = { 1.0f, 1.0f, 1.0f, 0.2f,  // Start color
		1.0f, 1.0f, 1.0f, 0.0f }; // End color
	fillGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, 2);
	
	CGFloat maskLocations[2] = {0.0f, 1.0f};
	CGFloat maskComponents[8] = {
		0.1921568627451f, 0.64313725490196f, 0.88627450980392f, 0.8f,
		0.1921568627451f, 0.64313725490196f, 0.88627450980392f, 0.2f
	};
	maskGradient = CGGradientCreateWithColorComponents(rgbColorspace, maskComponents, maskLocations, 2);
	CGColorSpaceRelease(rgbColorspace);
}
+ (CGGradientRef) fillGradient {
	return fillGradient;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) addMaskGradientToPath:(CGPathRef) path context:(CGContextRef) context {
	CGRect pathRect = CGPathGetPathBoundingBox(path);
	CGFloat midx = CGRectGetMidX(pathRect);
	
	CGContextSaveGState(context);
	CGContextAddPath(context, path);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, maskGradient, CGPointMake(midx, CGRectGetMinY(pathRect)), CGPointMake(midx, CGRectGetMaxY(pathRect)), 0);
	CGContextRestoreGState(context);
}
- (void) addHighlightMaskForPath:(CGPathRef) path context:(CGContextRef) context {
	CGContextSetRGBFillColor(context, 0.19607843137255f, 0.64705882352941f, 0.88627450980392f, 0.4f);
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	[self addMaskGradientToPath:path context:context];
}
- (void) addSelectionMaskForPath:(CGPathRef) path context:(CGContextRef) context {
	[self addMaskGradientToPath:path context:context];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
