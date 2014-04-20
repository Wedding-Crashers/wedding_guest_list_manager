//
//  Guest.h
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/19/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Guest : NSObject

@property(strong, nonatomic) PFObject* guestPFObject;

-(void) initWithObject: (PFObject*)guestPFObject;

-(NSString*) firstName;
-(NSString*) lastName;
-(NSString*) addressLineOne;
-(NSString*) addressLineTwo;
-(NSString*) city;
-(NSString*) state;
-(NSString*) zip;
-(NSString*) rsvpStatus;
-(NSString*) phoneNumber;
-(NSString*) email;
-(NSString*) invitedStatus;
-(NSString*) guestType;

@end
