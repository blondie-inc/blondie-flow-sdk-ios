//
//  BlondieStorage.h
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BlondieEvent;

@interface BlondieStorage : NSObject

- (BlondieEvent *)dequeueEvent;
- (void)enqueueEvent:(BlondieEvent *)event;
- (void)removeEvent:(BlondieEvent *)event;
	
@end

NS_ASSUME_NONNULL_END
