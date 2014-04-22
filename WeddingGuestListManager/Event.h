//
//  Event.h
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/20/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Event : NSObject

+ (Event *)currentEvent;

@property (strong, nonatomic) PFObject *eventPFObject;

@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *location;
@property(strong, nonatomic) NSDate    *date;
@property(assign, nonatomic) int       numberOfGuests;

+ (void) updateCurrentEventWithPFObject: (PFObject *)eventPFOject;
+ (void) updateEventWithEvent: (Event *) updateEvent withBlock:(PFBooleanResultBlock)resultBlock;

@end
