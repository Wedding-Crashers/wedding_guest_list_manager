//
//  MessageHelper.m
//  WeddingGuestListManager
//
//  Created by THOMAS CHEN on 4/20/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "MessageHelper.h"
#import <Parse/Parse.h>

NSString *const domain = @"http://nebraskatom.com/guest";
NSString *const profilePath = @"/profile/";
NSString *const invitePath = @"/invite/";

@implementation MessageHelper

+ (NSDictionary*)getDictionaryOfUrls:(NSArray *)guests forProfile:(BOOL)forProfile{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    for(PFObject* guest in guests) {
        NSString *url;
        if(forProfile) {
            url = [NSString stringWithFormat:@"%@%@%@", domain, profilePath, guest.objectId];
        }
        else {
            url = [NSString stringWithFormat:@"%@%@%@", domain, invitePath, guest.objectId];
        }
        [dictionary setObject:url forKey:guest[@"email"]];
    }
    return [dictionary mutableCopy];
}

+ (NSDictionary*)getDictionaryForTestForProfile:(BOOL)forProfile {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSString *url;
    if(forProfile) {
        url = [NSString stringWithFormat:@"%@%@GUESTID", domain, profilePath];
    }
    else {
        url = [NSString stringWithFormat:@"%@%@GUESTID", domain, invitePath];
    }
    [dictionary setObject:url forKey:[PFUser currentUser].email];
    
    return [dictionary mutableCopy];
    
}

@end
