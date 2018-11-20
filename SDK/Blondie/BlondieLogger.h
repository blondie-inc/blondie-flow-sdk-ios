//
//  BlondieLogger.h
//  Blondie
//
//  Created by Maxim on 11/7/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlondieLogger : NSObject

@property (readwrite, nonatomic) BOOL enabled;

+ (instancetype)sharedInstance;

- (void)print:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
