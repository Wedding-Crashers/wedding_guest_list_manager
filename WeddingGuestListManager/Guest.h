//
//  Guest.h
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/19/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "HelperMethods.h"

#define GUEST_NOT_INVITED 0
#define GUEST_INVITED 1
#define GUEST_NOT_RSVPED 0
#define GUEST_RSVPED 1
#define GUEST_DECLINED 2
#define GUEST_TYPE_INVITE_LIST 0
#define GUEST_TYPE_WAITLIST 1

@interface Guest : NSObject

@property(strong, nonatomic) PFObject* guestPFObject;

-(void) initWithObject: (PFObject*)guestPFObject;
-(void) updateGuestWithGuest: (Guest*) updateGuest withBlock:(PFBooleanResultBlock)resultBlock;
-(NSString*) getMissingContactInfoText;
-(void)moveToGuestListWithResultBlock:(PFBooleanResultBlock)resultBlock ;
-(void)moveToWaitListWithResultBlock:(PFBooleanResultBlock)resultBlock  ;
-(void)deleteGuestWithResultBlock:(PFBooleanResultBlock)resultBlock ;
-(BOOL)isMissingAddress ;
-(BOOL)isMissingPhone ;

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
@property(strong, nonatomic) PFFile* profileImagePFFile;
@property(assign, nonatomic) int extraGuests;
@property(assign, nonatomic) int encodedInvitedStatus;
@property(assign, nonatomic) int encodedRsvpStatus;
@property(assign, nonatomic) int encodedGuestType;


@end
