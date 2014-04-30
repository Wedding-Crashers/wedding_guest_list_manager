//
//  MailgunHelperClient.m
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/13/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "MailgunHelperClient.h"

@implementation MailgunHelperClient

+ (MailgunHelperClient*) instance {
    static MailgunHelperClient* instance=NULL;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^ {
        instance = [[MailgunHelperClient alloc] init];
        instance.mailgun = [Mailgun clientWithDomain:@"sandbox92662c6b943340579bb986e79b73d99b.mailgun.org" apiKey:@"key-7xnp1cl2c3phbhnj27tvi6al9dkx4499"];
    });
    
    return instance;
}

- (void)sendMessage:(MGMessage *)message withSuccess:(void (^)(NSString *messageId))success withFailure:(void (^)(NSError *error))failure {
    Mailgun *mg= [[MailgunHelperClient instance] mailgun];
    if(mg != NULL) {
        [mg sendMessage:message success:^(NSString *messageId) {
            NSLog(@"Message %@ sent successfully!", messageId);
        } failure:^(NSError *error) {
            NSLog(@"Error sending message. The error was: %@", [error userInfo]);
        }];
    }
 }

- (void)sendMessageTo:(NSDictionary *)recipientsList withSubject:(NSString*)subject withBody:(NSString*)bodyText {
    Mailgun *mg= [[MailgunHelperClient instance] mailgun];
    for(id email in recipientsList) {
        
        NSString *newBodyText;
        
//        if (![subject isEqualToString:@"Reminder: Save the Date!"] && ![subject isEqualToString:@"TEST: Reminder: Save the Date!"]) {
            newBodyText = [bodyText stringByAppendingString:[NSString stringWithFormat:@"\n\n%@", [recipientsList objectForKey:email]]];
//        } 
        
        [mg sendMessageTo:email
                     from:@"sample@sandbox92662c6b943340579bb986e79b73d99b.mailgun.org"
                  subject:subject
                     body:newBodyText];
    }
}

@end
