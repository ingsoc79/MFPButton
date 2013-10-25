//
//  BlahButton.m
//  MFPButton
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 MeanFreePath LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "BlahButton.h"

@implementation BlahButton

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if(self) {
		[self setTitleColor:[UIColor colorWithRed:0.08627450980392f green:0.49411764705882f blue:0.9843137254902f alpha:0.9f] forState:UIControlStateNormal];
	}
	return self;
}

- (NSString *) cacheSwitches {
	return @"";
}
- (void) drawForState:(UIControlState)state context:(CGContextRef)context {

	//create a rounded rect path around the edges of the button
	CGFloat lineWidth = 2.0f;
	CGRect boundsRect = CGRectInset(self.bounds, 0.5f * lineWidth, 0.5f * lineWidth);
	CGFloat boundsRadius = 0.25f * boundsRect.size.height;
	CGFloat minx = CGRectGetMinX(boundsRect), midx = CGRectGetMidX(boundsRect), maxx = CGRectGetMaxX(boundsRect);
	CGFloat miny = CGRectGetMinY(boundsRect), midy = CGRectGetMidY(boundsRect), maxy = CGRectGetMaxY(boundsRect);
	CGMutablePathRef outerBorderPath = CGPathCreateMutable();
	CGPathMoveToPoint(outerBorderPath, NULL, midx, miny);
	CGPathAddArcToPoint(outerBorderPath, NULL, maxx, miny, maxx, midy, boundsRadius);
	CGPathAddArcToPoint(outerBorderPath, NULL, maxx, maxy, midx, maxy, boundsRadius);
	CGPathAddArcToPoint(outerBorderPath, NULL, minx, maxy, minx, midy, boundsRadius);
	CGPathAddArcToPoint(outerBorderPath, NULL, minx, miny, midx, miny, boundsRadius);
	CGPathCloseSubpath(outerBorderPath);

	//draw the outer border for all states
	CGContextAddPath(context, outerBorderPath);
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetRGBStrokeColor(context, 0.08627450980392f, 0.49411764705882f, 0.9843137254902f, 0.9f);
	CGContextStrokePath(context);

	//and define any desired per-state features
	switch (state) {
		case UIControlStateHighlighted: //add a light background shade effect when the user taps the button (i.e. button is in "highlighted" state)
			CGContextAddPath(context, outerBorderPath);
			CGContextSetRGBFillColor(context, 0.08627450980392f, 0.49411764705882f, 0.9843137254902f, 0.3f);
			CGContextFillPath(context);
			break;
		case UIControlStateDisabled: //add a dark background shade effect when the button is disabled
			CGContextAddPath(context, outerBorderPath);
			CGContextSetRGBFillColor(context, 0.25f, 0.25f, 0.25f, 0.3f);
			CGContextFillPath(context);
			break;
		default:
			break;
	}
	
	CGPathRelease(outerBorderPath);
}
@end
