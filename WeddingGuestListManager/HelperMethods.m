//
//  HelperMethods.m
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/20/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "HelperMethods.h"

@implementation HelperMethods

+(NSString*) ModifyToBlankTextForObject: (id)object {
    return object ? object : @"";
}

+(NSString*) ModifyToBlankTextForString: (NSString*)string {
    return [string isEqualToString:@"(null)"] ? @"" : string;
}

+(BOOL) isNullString:(NSString*)string {
    return [string isEqualToString:@"(null)"] || (string == NULL);
}

+(id) ModifyToNSNullForObject: (id)object {
    return object ? object : [NSNull null];
}

+(void) SetFontSizeAndColorOfButton: (UIBarButtonItem*)button {
    NSUInteger size = 13.0f;
    UIFont * font = [UIFont systemFontOfSize:size];
    NSDictionary * attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]};
    [button setTitleTextAttributes:attributes forState:UIControlStateNormal];
   
}

+(NSMutableArray*) checkAndDeleteObject: (id)object inArray: (NSMutableArray*)array {
    if([array containsObject:object]) {
        [array removeObject:object];
    }
    return array;
}

+(NSMutableArray*) checkIfContainsAndAddObject: (id)object inArray: (NSMutableArray*)array {
    if(![array containsObject:object]) {
        [array addObject:object];
    }
    return array;
}

@end
