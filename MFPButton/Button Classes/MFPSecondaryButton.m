//
//  MFPSecondaryButton.m
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

#import "MFPSecondaryButton.h"

@implementation MFPSecondaryButton

- (void) generateBorderPaths:(CGMutablePathRef) outerBorderPath fillPath:(CGMutablePathRef) fillPath {
	CGRect boundsRect = self.bounds;
	
	CGFloat boundsRadius = 0.5f * boundsRect.size.height;

	CGFloat minx = CGRectGetMinX(boundsRect), midx = CGRectGetMidX(boundsRect), maxx = CGRectGetMaxX(boundsRect);
	CGFloat miny = CGRectGetMinY(boundsRect), midy = CGRectGetMidY(boundsRect), maxy = CGRectGetMaxY(boundsRect);
	CGPathMoveToPoint(outerBorderPath, NULL, midx, miny);
	CGPathAddArcToPoint(outerBorderPath, NULL, maxx, miny, maxx, midy, boundsRadius);
	CGPathAddArcToPoint(outerBorderPath, NULL, maxx, maxy, midx, maxy, boundsRadius);
	CGPathAddArcToPoint(outerBorderPath, NULL, minx, maxy, minx, midy, boundsRadius);
	CGPathAddArcToPoint(outerBorderPath, NULL, minx, miny, midx, miny, boundsRadius);
	CGPathCloseSubpath(outerBorderPath);
	
	
	CGFloat centerBorderFactor = 0.055555555555556f * boundsRect.size.height;
	CGRect centerRect = CGRectInset(boundsRect, centerBorderFactor, centerBorderFactor);
	CGFloat centerBorderRadius = 0.5f * centerRect.size.height;
	
	minx = CGRectGetMinX(centerRect), midx = CGRectGetMidX(centerRect), maxx = CGRectGetMaxX(centerRect);
	miny = CGRectGetMinY(centerRect), midy = CGRectGetMidY(centerRect), maxy = CGRectGetMaxY(centerRect);
	CGPathMoveToPoint(fillPath, NULL, midx, miny);
	CGPathAddArcToPoint(fillPath, NULL, maxx, miny, maxx, midy, centerBorderRadius);
	CGPathAddArcToPoint(fillPath, NULL, maxx, maxy, midx, maxy, centerBorderRadius);
	CGPathAddArcToPoint(fillPath, NULL, minx, maxy, minx, midy, centerBorderRadius);
	CGPathAddArcToPoint(fillPath, NULL, minx, miny, midx, miny, centerBorderRadius);
	CGPathCloseSubpath(fillPath);
}
- (void) drawForState:(UIControlState)state context:(CGContextRef)context {
	//generate the background path
	CGMutablePathRef outerBorderPath = CGPathCreateMutable();
	CGMutablePathRef centerPath = CGPathCreateMutable();
	
	//populate the paths
	[self generateBorderPaths:outerBorderPath fillPath:centerPath];
	
	CGContextAddPath(context, outerBorderPath);
	CGContextFillPath(context);
	CGPathRelease(outerBorderPath);
	
	//and the button body fill & gradient
	CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
	CGContextAddPath(context, centerPath);
	CGContextFillPath(context);
	
	CGContextSaveGState(context);
	CGContextAddPath(context, centerPath);
	CGContextClip(context);
	CGRect centerRect = CGPathGetBoundingBox(centerPath);
	CGFloat midx = CGRectGetMidX(centerRect);
	CGContextDrawLinearGradient(context, [[super class] fillGradient], CGPointMake(midx, CGRectGetMinY(centerRect)), CGPointMake(midx, CGRectGetMaxY(centerRect)), 0);
	CGContextRestoreGState(context);
	
	//add a color mask if the button has been selected
	if(state & UIControlStateSelected) {
		[self addSelectionMaskForPath:centerPath context:context];
	} else if (state & UIControlStateHighlighted) {
		[self addHighlightMaskForPath:centerPath context:context];
	}
	
	CGPathRelease(centerPath);
}


@end
