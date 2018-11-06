//
//  BlondieRequest.h
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BlondieEvent;

@interface BlondieRequest : NSObject

- (instancetype)initWithEvent:(BlondieEvent *)event;
	
- (void)performWithCompletion:(void (^)(BOOL success))completion;
	
@end

NS_ASSUME_NONNULL_END
