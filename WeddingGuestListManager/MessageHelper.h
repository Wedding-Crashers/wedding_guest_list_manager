//
//  MessageHelper.h
//  WeddingGuestListManager
//
//  Created by THOMAS CHEN on 4/20/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageHelper : NSObject

+ (NSDictionary*)getDictionaryOfUrls:(NSArray *)guests forProfile:(BOOL)forProfile;
+ (NSDictionary*)getDictionaryForTestForProfile:(BOOL)forProfile;

@end
