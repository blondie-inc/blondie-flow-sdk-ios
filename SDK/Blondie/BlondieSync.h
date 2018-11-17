//
//  BlondieSync.h
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BlondieTypes.h"

NS_ASSUME_NONNULL_BEGIN

@class BlondieEvent;

@interface BlondieSync : NSObject

- (void)setupApiKey:(NSString *)apiKey;
- (void)setupEnvironment:(BlondieEnvironmentType)environment;
- (void)useCustomUrl:(NSString *)url;
- (void)disableOfflineMode;
- (void)disableAutoRetries;
- (void)addEvent:(BlondieEvent *)event;
	
@end

NS_ASSUME_NONNULL_END
