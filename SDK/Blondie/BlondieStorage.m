//
//  BlondieStorage.m
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import "BlondieStorage.h"
#import "BlondieEvent.h"
#import "Blondie+Extensions.h"
#import "BlondieLogger.h"

@interface BlondieStorage ()

@property (strong, readwrite, nonatomic) NSMutableArray *events;
	
@end

@implementation BlondieStorage

- (instancetype)init {
	if (self = [super init]) {
		self.events = [NSMutableArray array];
		[self loadData];
	}
	return self;
}

- (NSString *)storagePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"BlondieEvents.plist"];
	return plistPath;
}
	
- (void)loadData {
	NSString *storagePath = [self storagePath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:storagePath]) {
		NSArray *events = [NSKeyedUnarchiver unarchiveObjectWithFile:storagePath];
		if (events && [events count] != 0) {
			[self.events addObjectsFromArray:events];
			
			[[BlondieLogger sharedInstance] print:@"Cached events:"];
			for (BlondieEvent *e in self.events) {
				[[BlondieLogger sharedInstance] print:e.name];
			}
		}
	} else {
		[self saveData];
	}
}

- (void)saveData {
	NSString *storagePath = [self storagePath];
	[NSKeyedArchiver archiveRootObject:self.events toFile:storagePath];
}

- (BlondieEvent *)dequeueEvent {
	return [self.events dequeue];
}
	
- (void)enqueueEvent:(BlondieEvent *)event {
	[self.events enqueue:event];
	[self saveData];
}
	
- (void)save {
	[self saveData];
}
	
@end
