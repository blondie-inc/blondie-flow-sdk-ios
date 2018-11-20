//
//  BlondieDevice.m
//  Blondie
//
//  Created by Maxim on 11/17/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import "BlondieDevice.h"

@import AdSupport;
@import UIKit;

NSString * const kBlondieDeviceIdentifier = @"BlondieDeviceIdentifier";

@implementation BlondieDevice

+ (BlondieDevice *)sharedInstance {
	static dispatch_once_t once_token;
	static BlondieDevice *instance = nil;
	dispatch_once(&once_token, ^{
		instance = [[self alloc] init];
	});
	return instance;
}

- (NSString * _Nonnull)identifier {
	NSString *identifier = [[NSUserDefaults standardUserDefaults] stringForKey:kBlondieDeviceIdentifier];
	if (!identifier) {
		identifier = [self identifierForAdvertising];
		if (!identifier) {
			identifier = [self uniqueIdentifier];
		}
	}
	
	if (identifier) {
		[[NSUserDefaults standardUserDefaults] setObject:identifier forKey:kBlondieDeviceIdentifier];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else {
		identifier = @"";
	}
	
	return identifier;
}

- (NSString *)identifierForAdvertising {
	// Check whether advertising tracking is enabled
	if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
		NSUUID *identifier = [[ASIdentifierManager sharedManager] advertisingIdentifier];
		return [identifier UUIDString];
	}
	// Get and return IDFA
	return nil;
}

- (NSString *)uniqueIdentifier {
	return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

@end
