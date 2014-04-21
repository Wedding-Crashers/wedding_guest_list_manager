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


+ (void)findAllObjectsWithQuery:(PFQuery *)query withBlock:(void (^)(NSArray *objects, NSError *error))block
{
    __block NSMutableArray *allObjects = [NSMutableArray array];
    __block NSUInteger limit = 1000;
    __block NSUInteger skip = 0;
    
    typedef void  (^FetchNextPage)(void);
    FetchNextPage __weak __block weakPointer;
    
    FetchNextPage strongBlock = ^(void)
    {
        [query setLimit: limit];
        [query setSkip: skip];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error)
            {
                // The find succeeded. Add the returned objects to allObjects
                [allObjects addObjectsFromArray:objects];
                
                if (objects.count == limit) {
                    // There might be more objects in the table. Update the skip value and execute the query again.
                    skip += limit;
                    [query setSkip: skip];
                    // Go get more results
                    weakPointer();
                }
                else
                {
                    // We are done so return the objects
                    block(allObjects, nil);
                }
                
            }
            else
            {
                block(nil,error);
            }
        }];
    };
    
    weakPointer = strongBlock;
    strongBlock();
    
}

@end
