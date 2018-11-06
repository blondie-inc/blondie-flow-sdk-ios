//
//  BlondieRequest.m
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import "BlondieRequest.h"

@interface BlondieRequest ()

@property (strong, readwrite, nonatomic) BlondieEvent *event;
	
@end

@implementation BlondieRequest

- (instancetype)initWithEvent:(BlondieEvent *)event {
	self = [super init];
	if (self) {
		self.event = event;
	}
	return self;
}

- (void)performWithCompletion:(void (^)(BOOL success))completion {
	NSURL *URL = [NSURL URLWithString:@"https://www.google.com"];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	
	NSURLSession *session = [NSURLSession sharedSession];
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request
											completionHandler:
								  ^(NSData *data, NSURLResponse *response, NSError *error) {
									  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
									  
									  dispatch_async(dispatch_get_main_queue(), ^{
										  if (httpResponse) {
											  completion(httpResponse.statusCode >= 200 && httpResponse.statusCode < 300);
										  } else {
											  completion(false);
										  }
									  });
								  }];
	
	[task resume];
}
	
@end
