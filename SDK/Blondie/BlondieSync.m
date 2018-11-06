//
//  BlondieSync.m
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import "BlondieSync.h"
#import "BlondieStorage.h"
#import "BlondieReachability.h"
#import "BlondieRequest.h"
#import "BlondieEvent.h"

@interface BlondieSync ()

@property (strong, readwrite, nonatomic) NSString *apiKey;
@property (strong, readwrite, nonatomic) NSString *flowId;
@property (strong, readwrite, nonatomic) NSString *baseUrl;
@property (readwrite, nonatomic) BlondieEnvironmentType environment;
@property (readwrite, nonatomic) BOOL useOfflineMode;
@property (readwrite, nonatomic) BOOL useAutoRetries;
	
@property (strong, readwrite, nonatomic) BlondieStorage *storage;
@property (nonatomic) BlondieReachability *internetReachability;

@property (nonatomic) BOOL syncing;
@property (nonatomic) BOOL hasConnection;
	
@end

@implementation BlondieSync

- (instancetype)init {
	if (self = [super init]) {
		self.environment = kProduction;
		self.useOfflineMode = YES;
		self.useAutoRetries = YES;
		
		self.storage = [[BlondieStorage alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
		
		self.internetReachability = [BlondieReachability reachabilityForInternetConnection];
		[self.internetReachability startNotifier];
		
		self.syncing = NO;
		[self checkConnection];
	}
	return self;
}
	
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)setApiKey:(NSString *)apiKey forFlowId:(NSString *)flowId {
	self.apiKey = apiKey;
	self.flowId = flowId;
}
	
- (void)setupEnvironment:(BlondieEnvironmentType)environment {
	self.environment = environment;
}
	
- (void)useCustomUrl:(NSString *)url {
	self.baseUrl = url;
}
	
- (void)disableOfflineMode {
	self.useOfflineMode = NO;
}
	
- (void)disableAutoRetries {
	self.useAutoRetries = NO;
}

- (void)checkConnection {
	NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
	self.hasConnection = (netStatus != NotReachable);
}
	
- (void)addEvent:(BlondieEvent *)event {
	NSLog(@"addEvent");
	
	[self.storage enqueueEvent:event];
	[self sync];
}

- (void)sync {
	NSLog(@"sync");
	
	if (self.apiKey == nil || self.flowId == nil) {
		return;
	}
	
	if (self.hasConnection) {
		if (!self.syncing) {
			BlondieEvent *event = [self.storage dequeueEvent];
			if (event) {
				self.syncing = YES;
				[self syncEvent:event];
			}
		}
	}
}

- (void)syncEvent:(BlondieEvent *)event {
	NSLog(@"syncEvent");
	
	dispatch_group_t group = dispatch_group_create();
	dispatch_group_enter(group);
	
	__weak BlondieSync *weakSelf = self;
	
	BlondieRequest *request = [[BlondieRequest alloc] initWithEvent:event];
	[request performWithCompletion:^(BOOL success) {
		if (success) {
			NSLog(@"storage.removeEvent %@", [event name]);
			[weakSelf.storage save];
		} else {
			NSLog(@"storage.enqueueEvent %@", [event name]);
			[weakSelf.storage enqueueEvent:event];
		}
		
		dispatch_group_leave(group);
	}];
	
	dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		self.syncing = NO;
		[self sync];
	});
}
	
- (void)reachabilityChanged:(NSNotification *)note {
	BlondieReachability *curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[BlondieReachability class]]);
	
	if (curReach == self.internetReachability) {
		[self checkConnection];
		
		if (self.hasConnection) {
			[self sync];
		}
	}
}
	
@end
