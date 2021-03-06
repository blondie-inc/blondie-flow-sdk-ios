//
//  BlondieReachability.m
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>

#import <CoreFoundation/CoreFoundation.h>

#import "BlondieReachability.h"

NSString *kReachabilityChangedNotification = @"kNetworkReachabilityChangedNotification";

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target, flags)
	NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
	NSCAssert([(__bridge NSObject*) info isKindOfClass: [BlondieReachability class]], @"info was wrong class in ReachabilityCallback");
	
	BlondieReachability* noteObject = (__bridge BlondieReachability *)info;
	// Post a notification to notify the client that the network reachability changed.
	[[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object: noteObject];
}

@implementation BlondieReachability
{
	SCNetworkReachabilityRef _reachabilityRef;
}
	
+ (instancetype)reachabilityWithHostName:(NSString *)hostName {
	BlondieReachability* returnValue = NULL;
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
	if (reachability != NULL) {
		returnValue= [[self alloc] init];
		if (returnValue != NULL) {
			returnValue->_reachabilityRef = reachability;
		} else {
			CFRelease(reachability);
		}
	}
	return returnValue;
}
	
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress {
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, hostAddress);
	
	BlondieReachability* returnValue = NULL;
	
	if (reachability != NULL) {
		returnValue = [[self alloc] init];
		if (returnValue != NULL) {
			returnValue->_reachabilityRef = reachability;
		} else {
			CFRelease(reachability);
		}
	}
	return returnValue;
}
	
+ (instancetype)reachabilityForInternetConnection {
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	return [self reachabilityWithAddress: (const struct sockaddr *) &zeroAddress];
}

#pragma mark - Start and stop notifier
	
- (BOOL)startNotifier {
	BOOL returnValue = NO;
	SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
	
	if (SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context)) {
		if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {
			returnValue = YES;
		}
	}
	
	return returnValue;
}
	
- (void)stopNotifier {
	if (_reachabilityRef != NULL) {
		SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	}
}
	
- (void)dealloc {
	[self stopNotifier];
	if (_reachabilityRef != NULL) {
		CFRelease(_reachabilityRef);
	}
}
	
	
#pragma mark - Network Flag Handling
	
- (NetworkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags {
	if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
		// The target host is not reachable.
		return NotReachable;
	}
	
	NetworkStatus returnValue = NotReachable;
	
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
		/*
		 If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
		 */
		returnValue = ReachableViaWiFi;
	}
	
	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
		 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
		/*
		 ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
		 */
		
		if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
			/*
			 ... and no [user] intervention is needed...
			 */
			returnValue = ReachableViaWiFi;
		}
	}
	
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
		/*
		 ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
		 */
		returnValue = ReachableViaWWAN;
	}
	
	return returnValue;
}
	
	
- (BOOL)connectionRequired {
	NSAssert(_reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags)) {
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
	}
	
	return NO;
}
	
	
- (NetworkStatus)currentReachabilityStatus {
	NSAssert(_reachabilityRef != NULL, @"currentNetworkStatus called with NULL SCNetworkReachabilityRef");
	NetworkStatus returnValue = NotReachable;
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags)) {
		returnValue = [self networkStatusForFlags:flags];
	}
	
	return returnValue;
}
	
@end
