//
//  Guest.h
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/19/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define GUEST_INVITED 1
#define GUEST_NOT_INVITED 0
#define GUEST_RSVPED 1
#define GUEST_NOT_RSVPED 0
#define GUEST_TYPE_0 0
#define GUEST_TYPE_1 1
#define GUEST_TYPE_2 2

@interface Guest : NSObject

@property(strong, nonatomic) PFObject* guestPFObject;

-(void) initWithObject: (PFObject*)guestPFObject;
-(void) updateGuestWithGuest: (Guest*) updateGuest withBlock:(PFBooleanResultBlock)resultBlock;

@property(strong, nonatomic) NSString* firstName;
@property(strong, nonatomic) NSString* lastName;
@property(strong, nonatomic) NSString* addressLineOne;
@property(strong, nonatomic) NSString* addressLineTwo;
@property(strong, nonatomic) NSString* city;
@property(strong, nonatomic) NSString* state;
@property(strong, nonatomic) NSString* zip;
@property(strong, nonatomic) NSString* rsvpStatus;
@property(strong, nonatomic) NSString* phoneNumber;
@property(strong, nonatomic) NSString* email;
@property(strong, nonatomic) NSString* invitedStatus;
@property(strong, nonatomic) NSString* guestType;
@property(assign, nonatomic) int encodedInvitedStatus;
@property(assign, nonatomic) int encodedRsvpStatus;
@property(assign, nonatomic) int encodedGuestType;

+(NSString*) ModifyToBlankTextForObject: (id)object ;
+(NSString*) ModifyToBlankTextForString: (NSString*)string;
+(id) ModifyToNSNullForObject: (id)object;

@end
