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
	
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[Blondie triggerEventWithName:@"event1" metaData:@{
													   @"param1": @"value1",
													   @"param2": @"value2"
													   }];
}


@end
