//
//  Blondie.h
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 Maksym Bilan. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Blondie.
FOUNDATION_EXPORT double BlondieVersionNumber;

//! Project version string for Blondie.
FOUNDATION_EXPORT const unsigned char BlondieVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Blondie/PublicHeader.h>

@interface Blondie : NSObject

+ (void)setApiKey:(NSString *)apiKey forFlowId:(NSString *)flowId;

+ (void)useDevelopmentEnvironment;

+ (void)useTestEnvironment;

+ (void)useProductionEnvironment;

+ (void)setBaseUrl:(NSString *)baseUrl;

+ (void)disableOfflineMode;

+ (void)triggerEventWithName:(NSString *)name metaData:(NSDictionary *)medaData;

@end
