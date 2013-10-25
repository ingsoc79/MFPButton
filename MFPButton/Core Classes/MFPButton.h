//
//  MFPButton.h
//  GlobalSupremacy
//
//  Created by Nick Baicoianu on 10/17/12.
//  Copyright (c) 2012 MeanFreePath LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MFPButtonProtocol <NSObject>

@required
- (void) drawForState:(UIControlState)state context:(CGContextRef) context;
- (NSString *) cacheSwitches; //override to set a unique caching key string based on the button's drawing-related variables
@end

@interface MFPButton : UIButton<MFPButtonProtocol>
+ (BOOL) cachingEnabled;
+ (void) setCachingEnabled:(BOOL) enabled;
+ (BOOL) removeAllCachedImages:(NSError **) error;
- (void) drawBackgroundImageForState:(UIControlState)state size:(CGSize)imgSize scale:(CGFloat) scale overwriteCache:(BOOL) overwriteCache;
@end
