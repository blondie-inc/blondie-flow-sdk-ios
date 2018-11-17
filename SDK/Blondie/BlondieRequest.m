//
//  BlondieRequest.m
//  Blondie
//
//  Created by Maxim on 11/6/18.
//  Copyright © 2018 blondie.lv. All rights reserved.
//

#import "BlondieRequest.h"
#import "BlondieLogger.h"

@interface BlondieRequest ()

@property (strong, readwrite, nonatomic) BlondieEvent *event;
@property (strong, readwrite, nonatomic) NSString *token;
@property (readwrite, nonatomic) BlondieEnvironmentType environment;
@property (strong, readwrite, nonatomic) NSString *customUrl;
	
@end

@implementation BlondieRequest

- (instancetype)initWithEvent:(BlondieEvent *)event token:(NSString *)token environment:(BlondieEnvironmentType)environment {
	self = [super init];
	if (self) {
		self.event = event;
		self.token = token;
		self.environment = environment;
	}
	return self;
}

- (NSString *)baseUrl {
	NSString *url = nil;
	switch (self.environment) {
		case kDevelopment:
			url = @"https://flow-dev.blondie.lv/webhooks/events";
			break;
		case kTest:
			url = @"https://flow-test.blondie.lv/webhooks/events";
			break;
		case kProduction:
			url = @"https://flow.blondie.lv/webhooks/events";
			break;
		default:
			url = @"https://flow.blondie.lv/webhooks/events";
			break;
	}
	return url;
}

- (void)useCustomUrl:(NSString *)customUrl {
	self.customUrl = customUrl;
}

- (void)performWithCompletion:(void (^)(BOOL success))completion {
	NSURL *URL = [NSURL URLWithString:(self.customUrl ? self.customUrl : [self baseUrl])];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
	request.HTTPMethod = @"POST";
	[request addValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
	
	[[BlondieLogger sharedInstance] print:URL.absoluteString];
	
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
