//
//  BlondieEvent.h
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlondieEvent : NSObject <NSCoding>

@property (strong, readwrite, nonatomic) NSString *uid;
@property (strong, readwrite, nonatomic) NSString *name;
@property (strong, readwrite, nonatomic) NSDictionary *metadata;
	
@end

NS_ASSUME_NONNULL_END
