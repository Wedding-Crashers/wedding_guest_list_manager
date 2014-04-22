//
//  Event.m
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/20/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "Event.h"

@implementation Event

// Creates a singleton for the twitter client
+ (Event *)currentEvent {
    static Event *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        // Creates a singleton of Event
        instance = [[Event alloc] init];
    });
    
    return instance;
}

+ (void) updateCurrentEventWithPFObject:(PFObject *)eventPFOject {
    [Event currentEvent].eventPFObject  = eventPFOject;
    [Event currentEvent].title          = [NSString stringWithFormat:@"%@",[eventPFOject objectForKey:@"title"]];
    [Event currentEvent].location       = [NSString stringWithFormat:@"%@",[eventPFOject objectForKey:@"location"]];
    [Event currentEvent].date           = [eventPFOject objectForKey:@"date"];
    [Event currentEvent].numberOfGuests = [[eventPFOject objectForKey:@"numberOfGuests"] intValue];
}

+ (void) updateEventWithEvent:(Event *)updateEvent withBlock:(PFBooleanResultBlock)resultBlock {
    PFObject *currentPFObject = [Event currentEvent].eventPFObject;
    currentPFObject[@"title"]          = updateEvent.title        ? updateEvent.title: [NSNull null];
    currentPFObject[@"location"]       = updateEvent.location     ? updateEvent.location: [NSNull null];
    currentPFObject[@"date"]           = updateEvent.date         ? updateEvent.date: [NSNull null];
    currentPFObject[@"numberOfGuests"] = [NSNumber numberWithInt:updateEvent.numberOfGuests];
    
    [currentPFObject saveInBackgroundWithBlock:resultBlock];
}

@end
