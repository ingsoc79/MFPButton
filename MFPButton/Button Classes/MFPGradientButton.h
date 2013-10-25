//
//  MFPGradientButton.h
//  MFPButton
//
//  Created by Nick Baicoianu on 8/6/13.
//  Copyright (c) 2013 MeanFreePath LLC. All rights reserved.
//

#import "MFPButton.h"

@interface MFPGradientButton : MFPButton

+ (CGGradientRef) fillGradient;
- (void) addHighlightMaskForPath:(CGPathRef) path context:(CGContextRef) context;
- (void) addSelectionMaskForPath:(CGPathRef) path context:(CGContextRef) context;
@end
