//
//  Blondie+Extensions.m
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import "Blondie+Extensions.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSMutableArray (Extensions)

- (id)dequeue {
	if (self.count > 0) {
		id headObject = [self objectAtIndex:0];
		if (headObject != nil) {
			[self removeObjectAtIndex:0];
		}
		return headObject;
	}
	return nil;
}
	
- (void)enqueue:(id)anObject {
	[self addObject:anObject];
}

@end

@implementation NSString (Extensions)

- (NSString *)MD5String {
	const char *cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
	
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}
	
@end

@implementation NSDate (Extensions)

- (NSString *)uid {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateStyle = NSDateFormatterFullStyle;
	formatter.timeStyle = NSDateFormatterFullStyle;
	NSString *string = [formatter stringFromDate:self];
	return [string MD5String];
}
	
@end
