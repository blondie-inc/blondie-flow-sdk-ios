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
#import "BlondieLogger.h"

static const NSTimeInterval BlondieSyncLaunchDelay = 5.0f;

@interface BlondieSync ()

@property (strong, readwrite, nonatomic) NSString *apiKey;
@property (strong, readwrite, nonatomic) NSString *flowId;
@property (strong, readwrite, nonatomic) NSString *baseUrl;
@property (readwrite, nonatomic) BlondieEnvironmentType environment;
@property (readwrite, nonatomic) BOOL useOfflineMode;
@property (readwrite, nonatomic) BOOL useAutoRetries;
	
@property (strong, readwrite, nonatomic) BlondieStorage *storage;
@property (strong, readwrite, nonatomic) BlondieReachability *internetReachability;

@property (strong, readwrite, nonatomic) NSTimer *timer;

@property (nonatomic) BOOL syncing;
@property (nonatomic) BOOL hasConnection;
@property (nonatomic) BOOL paused;
	
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
		
		self.timer = [NSTimer scheduledTimerWithTimeInterval:BlondieSyncLaunchDelay target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
		self.paused = YES;
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
	[[BlondieLogger sharedInstance] print:[NSString stringWithFormat:@"Added event: %@", event.name]];
	
	[self.storage enqueueEvent:event];
	[self sync];
}

- (void)sync {
	if (self.paused) {
		return;
	}
	
	if (self.apiKey == nil || self.flowId == nil) {
		[[BlondieLogger sharedInstance] print:@"Please call setApiKey:forFlowId: method."];
		return;
	}
	
	if (self.hasConnection) {
		if (!self.syncing) {
			[[BlondieLogger sharedInstance] print:@"Start sync"];
			
			BlondieEvent *event = [self.storage dequeueEvent];
			if (event) {
				self.syncing = YES;
				[self syncEvent:event];
			} else {
				[[BlondieLogger sharedInstance] print:@"There are no events to sync."];
			}
		}
	} else {
		[[BlondieLogger sharedInstance] print:@"No internet connection"];
	}
}

- (void)syncEvent:(BlondieEvent *)event {
	[[BlondieLogger sharedInstance] print:[NSString stringWithFormat:@"Sync event: %@", event.name]];
	
	dispatch_group_t group = dispatch_group_create();
	dispatch_group_enter(group);
	
	__weak BlondieSync *weakSelf = self;
	
	BlondieRequest *request = [[BlondieRequest alloc] initWithEvent:event];
	[request performWithCompletion:^(BOOL success) {
		if (success) {
			[[BlondieLogger sharedInstance] print:[NSString stringWithFormat:@"Removed event: %@", event.name]];
			[weakSelf.storage save];
		} else {
			[[BlondieLogger sharedInstance] print:[NSString stringWithFormat:@"Wnqueue event: %@", event.name]];
			[weakSelf.storage enqueueEvent:event];
		}
		
		dispatch_group_leave(group);
	}];
	
	dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		self.syncing = NO;
		[self sync];
	});
}

- (void)handleTimer:(NSTimer *)timer {
	[self.timer invalidate];
	self.timer = nil;
	self.paused = NO;
	[self sync];
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
