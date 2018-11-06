//
//  Blondie.m
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import <Blondie.h>

typedef NS_ENUM(NSUInteger, BlondieEnvironmentType) {
	kDevelopment,
	kTest,
	kProduction
};

@interface Blondie ()

@property (strong, readwrite, nonatomic) NSString *apiKey;
@property (strong, readwrite, nonatomic) NSString *flowId;
@property (strong, readwrite, nonatomic) NSString *baseUrl;
@property (readwrite, nonatomic) BlondieEnvironmentType environment;
@property (readwrite, nonatomic) BOOL useOfflineMode;
@property (readwrite, nonatomic) BOOL useAutoRetries;
	
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
		self.environment = kProduction;
		self.useOfflineMode = YES;
		self.useAutoRetries = YES;
	}
	return self;
}
	
+ (void)setApiKey:(NSString *)apiKey forFlowId:(NSString *)flowId {
	[Blondie sharedInstance].apiKey = apiKey;
	[Blondie sharedInstance].flowId = flowId;
}

+ (void)useDevelopmentEnvironment {
	[Blondie sharedInstance].environment = kDevelopment;
}

+ (void)useTestEnvironment {
	[Blondie sharedInstance].environment = kTest;
}

+ (void)useProductionEnvironment {
	[Blondie sharedInstance].environment = kProduction;
}

+ (void)setBaseUrl:(NSString *)baseUrl {
	[Blondie sharedInstance].baseUrl = baseUrl;
}

+ (void)disableOfflineMode {
	[Blondie sharedInstance].useOfflineMode = NO;
}

+ (void)disableAutoRetries {
	[Blondie sharedInstance].useAutoRetries = NO;
}
	
+ (void)triggerEventWithName:(NSString *)name metaData:(NSDictionary *)medaData {
	
}

@end
