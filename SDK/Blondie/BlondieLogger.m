//
//  BlondieLogger.m
//  Blondie
//
//  Created by Maxim on 11/7/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import "BlondieLogger.h"

@implementation BlondieLogger

+ (BlondieLogger *)sharedInstance {
	static dispatch_once_t once_token;
	static BlondieLogger *instance = nil;
	dispatch_once(&once_token, ^{
		instance = [[self alloc] init];
	});
	return instance;
}

- (instancetype)init {
	if (self = [super init]) {
		self.enabled = NO;
	}
	return self;
}

- (void)print:(NSString *)message {
	if (self.enabled) {
		NSLog(@"Blondie ### %@", message);
	}
}

@end
