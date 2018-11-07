//
//  ViewController.m
//  Blondie Example ObjC
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import "ViewController.h"
#import <Blondie/Blondie.h>

@interface ViewController ()
{
	NSInteger eventCounter;
}

@property (weak, nonatomic) IBOutlet UIButton *triggerEventButton;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	eventCounter = 0;
}

- (IBAction)triggerEventAction:(UIButton *)sender {
	[Blondie triggerEventWithName:[NSString stringWithFormat:@"Event%ld", eventCounter]
						 metaData:@{
									@"param1": @"value1",
									@"param2": @"value2"
									}];
	++eventCounter;
}

@end
