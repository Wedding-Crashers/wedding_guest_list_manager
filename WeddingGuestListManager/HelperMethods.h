//
//  HelperMethods.h
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/20/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface HelperMethods : NSObject

+(NSString*) ModifyToBlankTextForObject: (id)object ;
+(NSString*) ModifyToBlankTextForString: (NSString*)string;
+(id) ModifyToNSNullForObject: (id)object;
+(BOOL) isNullString:(NSString*)string;
+(void) SetFontSizeAndColorOfButton: (UIBarButtonItem*)button;
+(NSMutableArray*) checkAndDeleteObject: (id)object inArray: (NSMutableArray*)array;
+(NSMutableArray*) checkIfContainsAndAddObject: (id)object inArray: (NSMutableArray*)array;

@end
