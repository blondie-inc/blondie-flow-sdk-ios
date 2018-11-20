//
//  BlondieDevice.h
//  Blondie
//
//  Created by Maxim on 11/17/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlondieDevice : NSObject

+ (instancetype)sharedInstance;

- (NSString * _Nonnull)identifier;

@end

NS_ASSUME_NONNULL_END
