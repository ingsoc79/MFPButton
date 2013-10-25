//
//  MFPButton.m
//  GlobalSupremacy
//
//  Created by Nick Baicoianu on 10/17/12.
//  Copyright (c) 2012 MeanFreePath LLC. All rights reserved.
//

#import "MFPButton.h"

@implementation MFPButton
static NSString *cachesDirectory = nil;
static BOOL cachingEnabled = YES;

#pragma mark - Class Methods
+ (void) load {

	//get a handle on the user's cache directory, falling back to their temporary directory if not found
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	BOOL cacheDirOK = YES;
	cachesDirectory = nil;
	if([pathList count]) {
		cachesDirectory = [[NSString alloc] initWithFormat:@"%@/%@/MFPButtonCaches/", [pathList objectAtIndex:0], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]];
		cacheDirOK = [[NSFileManager defaultManager] createDirectoryAtPath:cachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	if(!cacheDirOK) {
		[cachesDirectory release];
		cachesDirectory = [NSTemporaryDirectory() retain];
	}
	[pool drain];
}
#pragma mark - Caching Methods
+ (BOOL) cachingEnabled {
	return cachingEnabled;
}
+ (void) setCachingEnabled:(BOOL) enabled {
	cachingEnabled = enabled;
}
+ (BOOL) removeAllCachedImages:(NSError **) error {
	return [[NSFileManager defaultManager] removeItemAtPath:cachesDirectory error:error];
}
//include any additional cache switches here (optional)
- (NSString *) cacheSwitches {
	return @"";
}
#pragma mark - Overridden Methods
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self drawBackgroundStates:NO];
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if(self) {
		[self drawBackgroundStates:NO];
	}
	return self;
}
- (void) setFrame:(CGRect)frame {
	CGSize oldSize = self.bounds.size;
	[super setFrame:frame];
	CGSize newSize = self.bounds.size;

	//redraw the background images if the size has changed
	if((oldSize.width != newSize.width || oldSize.height != newSize.height)) {
		[self drawBackgroundStates:NO];
	}
}
#pragma mark - Image Generation Methods
/*generates the background images for the various states. If you don't need to implement a
 particular state in your project, you can remove its call here. */
- (void) drawBackgroundStates:(BOOL) overwriteCache {
	CGSize boundsSize = self.bounds.size;
	CGFloat scale = [[UIScreen mainScreen] scale];
	[self drawBackgroundImageForState:UIControlStateNormal size:boundsSize scale:scale overwriteCache:overwriteCache]; //normal button state
	[self drawBackgroundImageForState:UIControlStateHighlighted size:boundsSize scale:scale overwriteCache:overwriteCache]; //user is tapping button
	[self drawBackgroundImageForState:UIControlStateSelected size:boundsSize scale:scale overwriteCache:overwriteCache]; //button has been selected, i.e. selected property set to YES
	[self drawBackgroundImageForState:UIControlStateDisabled size:boundsSize scale:scale overwriteCache:overwriteCache]; //button has been disabled
}
- (UIImage *) generateImageForState:(UIControlState) state size:(CGSize)imgSize scale:(CGFloat) screenScale {
	//Create the context that the background image will be drawn in
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef imgContext = CGBitmapContextCreate(NULL, imgSize.width * screenScale, imgSize.height * screenScale, 8, 0, rgbColorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
	if(imgContext == NULL) { //can happen if one or more of the image dimensions is zero, or out of memory
		CGColorSpaceRelease(rgbColorSpace);
		return nil;
	}
	
	//images are drawn upside-down in iOS by default, so flip the context here
	CGContextScaleCTM(imgContext, screenScale, -screenScale);
	CGContextTranslateCTM(imgContext, 0.0f, -self.bounds.size.height);
	
	//draw the background image into the context and create a CGImage to hold the bitmap
	[self drawForState:state context:imgContext];
	CGImageRef cgImg = CGBitmapContextCreateImage(imgContext);
	CGContextRelease(imgContext);
	CGColorSpaceRelease(rgbColorSpace);
	
	//finally, reallocate as a UIImage and return
	if(cgImg) {
		UIImage *newImage = [[UIImage alloc] initWithCGImage:cgImg];
		CGImageRelease(cgImg);
		return [newImage autorelease];
	}
	return nil;
}
- (void) drawBackgroundImageForState:(UIControlState)state size:(CGSize)imgSize scale:(CGFloat) scale overwriteCache:(BOOL) overwriteCache {
	static NSString *const keyFormat = @"%@/ic%@_%d_%.0fx%.0f_%.1f_%@.png"; //cache directory, class name, button state, width, height, screen scale (i.e. Retina or not), optional cache switch string
	NSString *cachedImgPath = [[NSString alloc] initWithFormat:keyFormat, cachesDirectory, [[self class] description], state, imgSize.width, imgSize.height, scale, [self cacheSwitches]];
	UIImage *newImage;

	//if caching is enabled, check if there's a background image for the given state and size
	if(cachingEnabled && !overwriteCache) {
		newImage = [[UIImage alloc] initWithContentsOfFile:cachedImgPath];
		if(newImage == nil) { //generate the image if not cached
			newImage = [[self generateImageForState:state size:imgSize scale:scale] retain];
			[UIImagePNGRepresentation(newImage) writeToFile:cachedImgPath atomically:YES];
		}
	} else {
		newImage = [[self generateImageForState:state size:imgSize scale:scale] retain];
		if(overwriteCache) {
			[UIImagePNGRepresentation(newImage) writeToFile:cachedImgPath atomically:YES];
		}
	}

	//set the background image of this button
	[self setBackgroundImage:newImage forState:state];
	[newImage release];
	[cachedImgPath release];
}

/*use drawForState:context: to draw the background image(s) of the button.
 Drawing is essentially identical to drawing with drawRect – just use the
 provided context instead of using UIGraphicsGetCurrentContext().
 If your project includes multiple button types, create a new subclass for
 each type and implement drawForState:context: on them. */
- (void)drawForState:(UIControlState)state context:(CGContextRef)context {

}

/*no need to implement drawRect - use drawForState instead
- (void)drawRect:(CGRect)rect {

}
*/

@end
