//
//  BlondieEvent.m
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import "BlondieEvent.h"

@implementation BlondieEvent

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.uid = [decoder decodeObjectForKey:@"uid"];
		self.name = [decoder decodeObjectForKey:@"name"];
		self.metadata = [decoder decodeObjectForKey:@"metadata"];
	}
	return self;
}
	
- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.uid forKey:@"uid"];
	[encoder encodeObject:self.name forKey:@"name"];
	[encoder encodeObject:self.metadata forKey:@"metadata"];
}
	
@end
