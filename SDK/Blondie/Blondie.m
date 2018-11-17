//
//  Blondie.m
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import "Blondie.h"
#import "BlondieSync.h"
#import "BlondieEvent.h"
#import "Blondie+Extensions.h"
#import "BlondieLogger.h"

@interface Blondie ()

@property (strong, readwrite, nonatomic) BlondieSync *sync;
	
@end

@implementation Blondie

+ (Blondie *)sharedInstance {
	static dispatch_once_t once_token;
	static Blondie *instance = nil;
	dispatch_once(&once_token, ^{
		instance = [[self alloc] init];
	});
	return instance;
}

- (instancetype)init {
	if (self = [super init]) {
		self.sync = [[BlondieSync alloc] init];
	}
	return self;
}
	
+ (void)setApiKey:(NSString *)apiKey {
	[[Blondie sharedInstance].sync setupToken:apiKey];
}

+ (void)useDevelopmentEnvironment {
	[[Blondie sharedInstance].sync setupEnvironment:kDevelopment];
}

+ (void)useTestEnvironment {
	[[Blondie sharedInstance].sync setupEnvironment:kTest];
}

+ (void)useProductionEnvironment {
	[[Blondie sharedInstance].sync setupEnvironment:kProduction];
}

+ (void)setBaseUrl:(NSString *)baseUrl {
	[[Blondie sharedInstance].sync useCustomUrl:baseUrl];
}

+ (void)disableOfflineMode {
	[[Blondie sharedInstance].sync disableOfflineMode];
}

+ (void)disableAutoRetries {
	[[Blondie sharedInstance].sync disableAutoRetries];
}
	
+ (void)triggerEventWithName:(NSString *)name metaData:(NSDictionary *)metaData {
	BlondieEvent *event = [[BlondieEvent alloc] init];
	event.uid = [NSDate date].uid;
	event.name = name;
	event.metadata = metaData;
	[[Blondie sharedInstance].sync addEvent:event];
}

+ (void)enableLogging {
	[BlondieLogger sharedInstance].enabled = YES;
}

@end
