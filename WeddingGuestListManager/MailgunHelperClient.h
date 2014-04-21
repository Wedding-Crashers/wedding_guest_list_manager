//
//  MailgunHelperClient.h
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/13/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mailgun.h"
#import "MGMessage.h"

@interface MailgunHelperClient : NSObject

@property (retain, nonatomic) Mailgun *mailgun;

+ (MailgunHelperClient*) instance;

- (void)sendMessage:(MGMessage *)message withSuccess:(void (^)(NSString *messageId))success withFailure:(void (^)(NSError *error))failure;

- (void)sendMessageTo:(NSDictionary *)recipientsList withSubject:(NSString*)subject withBody:(NSString*)bodyText;


@end
