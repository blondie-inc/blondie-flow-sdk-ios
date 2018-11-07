//
//  Blondie.h
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Blondie.
FOUNDATION_EXPORT double BlondieVersionNumber;

//! Project version string for Blondie.
FOUNDATION_EXPORT const unsigned char BlondieVersionString[];

@interface Blondie : NSObject

+ (void)setApiKey:(NSString *)apiKey forFlowId:(NSString *)flowId;

+ (void)useDevelopmentEnvironment;

+ (void)useTestEnvironment;

+ (void)useProductionEnvironment;

+ (void)setBaseUrl:(NSString *)baseUrl;

+ (void)disableOfflineMode;
	
+ (void)disableAutoRetries;

+ (void)triggerEventWithName:(NSString *)name metaData:(NSDictionary *)metaData;

+ (void)enableLogging;

@end
