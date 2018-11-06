//
//  NSObject+Extensions.h
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Extensions)

- (id)dequeue;
- (void)enqueue:(id)obj;

@end

@interface NSString (Extensions)

- (NSString *)MD5String;
	
@end

@interface NSDate (Extensions)
	
- (NSString *)uid;
	
@end

NS_ASSUME_NONNULL_END
