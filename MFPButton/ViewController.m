//
//  ViewController.m
//  MFPButton
//
//  Created by Nick Baicoianu on 8/6/13.
//  Copyright (c) 2013 MeanFreePath LLC. All rights reserved.
//

#import "ViewController.h"
#import "MFPSecondaryButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	//[MFPButton removeAllCachedImages:nil];
	//Create a gradient button via code
	MFPSecondaryButton *codeButton = [[MFPSecondaryButton alloc] initWithFrame:CGRectMake(20.0f, 50.0f, 120.0f, 60.0f)];
	[codeButton setTitle:@"Code Button" forState:UIControlStateNormal];
	[self.view addSubview:codeButton];
	[codeButton release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
