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
static const NSInteger BlondieSyncBackendErrorLimit = 3;
static const NSInteger BlondieSyncAutoRetryLimit = 3;

@interface BlondieSync ()

@property (strong, readwrite, nonatomic) NSString *apiKey;
@property (strong, readwrite, nonatomic) NSString *flowId;
@property (strong, readwrite, nonatomic) NSString *customUrl;
@property (readwrite, nonatomic) BlondieEnvironmentType environment;
@property (readwrite, nonatomic) BOOL useAutoRetries;
	
@property (strong, readwrite, nonatomic) BlondieStorage *storage;
@property (strong, readwrite, nonatomic) BlondieReachability *internetReachability;

@property (strong, readwrite, nonatomic) NSTimer *timer;

@property (nonatomic, readwrite) BOOL syncing;
@property (nonatomic, readwrite) BOOL hasConnection;
@property (nonatomic, readwrite) BOOL paused;

@property (nonatomic, readwrite) NSInteger threshold;
@property (nonatomic, readwrite) NSInteger errorCounter;

@end

@implementation BlondieSync

- (instancetype)init {
	if (self = [super init]) {
		self.environment = kProduction;
		self.useAutoRetries = YES;
		
		self.storage = [[BlondieStorage alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
		
		self.internetReachability = [BlondieReachability reachabilityForInternetConnection];
		[self.internetReachability startNotifier];
		
		self.syncing = NO;
		self.threshold = 0;
		self.errorCounter = 0;
		[self checkConnection];
		
		self.timer = [NSTimer scheduledTimerWithTimeInterval:BlondieSyncLaunchDelay target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
		self.paused = YES;
	}
	return self;
}
	
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

+ (NSArray *)intervals {
	static NSArray *_intervals;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_intervals = @[@(10), @(30), @(60), @(300), @(1800), @(3600)];
	});
	return _intervals;
}

- (NSTimeInterval)pauseInterval {
	NSArray *intervals = [[self class] intervals];
	if (self.threshold < [intervals count]) {
		return [intervals[self.threshold] doubleValue];
	} else {
		return [[intervals lastObject] doubleValue];
	}
}

- (void)setApiKey:(NSString *)apiKey forFlowId:(NSString *)flowId {
	self.apiKey = apiKey;
	self.flowId = flowId;
}
	
- (void)setupEnvironment:(BlondieEnvironmentType)environment {
	self.environment = environment;
}
	
- (void)useCustomUrl:(NSString *)url {
	self.customUrl = url;
}
	
- (void)disableOfflineMode {
	[self.storage disableSaveOnDisk];
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
		[[BlondieLogger sharedInstance] print:@"Please call setApiKey:forFlowId: method first."];
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
	__block BOOL retry = NO;
	
	BlondieRequest *request = [[BlondieRequest alloc] initWithEvent:event environment:self.environment];
	[request useCustomUrl:self.customUrl];
	[request performWithCompletion:^(BOOL success) {
		if (success) {
			weakSelf.errorCounter = 0;
			weakSelf.threshold = 0;
			
			[[BlondieLogger sharedInstance] print:[NSString stringWithFormat:@"Removed event: %@", event.name]];
			[weakSelf.storage save];
		} else {
			weakSelf.errorCounter++;
			
			if (weakSelf.errorCounter < BlondieSyncAutoRetryLimit && weakSelf.useAutoRetries) {
				retry = YES;
			} else {
				[[BlondieLogger sharedInstance] print:[NSString stringWithFormat:@"Enqueue event: %@", event.name]];
				[weakSelf.storage enqueueEvent:event];
			}
			
			[weakSelf pauseSyncing];
		}
		
		dispatch_group_leave(group);
	}];
	
	dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		self.syncing = NO;
		if (retry) {
			[self syncEvent:event];
		} else {
			[self sync];
		}
	});
}

- (void)pauseSyncing {
	if (self.errorCounter == BlondieSyncBackendErrorLimit) {
		NSTimeInterval interval = [self pauseInterval];
		++self.threshold;
		
		[[BlondieLogger sharedInstance] print:[NSString stringWithFormat:@"Paused syncing on %.0f seconds", interval]];
		
		self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
		self.paused = YES;
	}
}

- (void)handleTimer:(NSTimer *)timer {
	[self.timer invalidate];
	self.timer = nil;
	self.paused = NO;
	self.errorCounter = 0;
	[self sync];
}

- (void)reachabilityChanged:(NSNotification *)note {
	BlondieReachability *curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[BlondieReachability class]]);
	
	if (curReach == self.internetReachability) {
		[self checkConnection];
		
		self.errorCounter = 0;
		self.threshold = 0;
		
		if (self.hasConnection) {
			[self sync];
		}
	}
}
	
@end
