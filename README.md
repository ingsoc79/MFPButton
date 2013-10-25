# MFPButton

Simple UIButton subclass for generating background images using the standard iOS Quartz framework - no need to cut different-sized images for different devices and pixel densities.


## Integrating Into Your Project

MFPButton is compatible with iOS projects targeting iOS 2.0 and higher, and has been tested with iOS 7.0.

To integrate, just copy the MFPButton.h and MFPButton.m files into your project, then subclass to create custom buttons.

### Subclassing MFPButton
Each subclass should override the methods defined in the MFPButtonProtocol protocol.  Below is a barebones subclass, which implements the bare minimum needed.

MyMFPButtonSubclass.h:

	#import "MFPButton.h"
	@interface MyMFPButtonSubclass : MFPButton<MFPButtonProtocol>
	
	@end

MyMFPButtonSubclass.m:

	#import "MyMFPButtonSubclass.h"
	@implementation MyMFPButtonSubclass
	
	- (NSString *) cacheSwitches {
		return @""; //No need to change this unless you plan to change the background images based on your own criteria (e.g. a custom "badge" or something similar)
	}
	- (void) drawForState:(UIControlState)state context:(CGContextRef)context {
		CGContextFillRect(context, self.bounds); //black rectangular background - obviously you can be more creative than this!
	}

### Implementing In Your Code

#### Interface Builder
To create an MFPButton in Interface Builder, just add a standard UIButton to your view and set its Custom Class property to your custom MFPButton subclass.  Make sure to set its type to `Custom` to avoid the system-generated effects from being applied to your button.

#### In Code
You can also create MFPButtons in Objective-C, like any other button class:

	- (void)viewDidLoad {
		[super viewDidLoad];

		CGRect buttonFrame = CGRectMake(0.0, 0.0, 200.0, 80.0);
		MyMFPButtonSubclass *button = [[MyMFPButtonSubclass alloc] initWithFrame:buttonFrame]; //the background images are generated/loaded on init
		[button setTitle:@"My Button" forState:UIControlStateNormal];
		[self.view addSubView:button];
		[button release];
	}

### Customizing the Background Images
The real magic happens in the `drawForState:context:` method.  This is where you can draw the background images for your button’s states using Quartz/CoreGraphics, similar to the UIView’s `drawRect:` method:

	- (void) drawForState:(UIControlState)state context:(CGContextRef)context {
		CGContextFillRect(context, self.bounds); //black rectangular background - obviously you can be more creative than this!
	}

#### Caching
MFPButton includes an optional caching feature (disabled by default), which saves the generated images to your application’s tmp/ directory.  You can enable/disable this feature programattically by calling `[MFPButton setCachingEnabled:YES]` or `[MFPButton setCachingEnabled:NO]`, ideally in your application delegate’s `application:didFinishLaunchingWithOptions:` method.

In practice, it’s easier to develop with caching disabled, and enable for production builds.

