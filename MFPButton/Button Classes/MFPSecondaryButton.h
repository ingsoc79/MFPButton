//
//  MFPSecondaryButton.h
//  GlobalSupremacy
//
//  Created by Nick Baicoianu on 10/16/12.
//  Copyright (c) 2012 MeanFreePath LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFPGradientButton.h"

@interface MFPSecondaryButton : MFPGradientButton

- (void) generateBorderPaths:(CGMutablePathRef) outerBorderPath fillPath:(CGMutablePathRef) fillPath;
@end
