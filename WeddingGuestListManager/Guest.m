//
//  Guest.m
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/19/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "Guest.h"

@implementation Guest

-(void) initWithObject: (PFObject*)guestPFObject {
    self.guestPFObject = guestPFObject;
    
    self.firstName              = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"firstName"]];
    self.lastName               = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"lastName"]];
    self.addressLineOne         = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"addressOne"]];
    self.addressLineTwo         = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"addressTwo"]];
    self.city                   = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"city"]];
    self.state                  = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"state"]];
    self.zip                    = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"zipCode"]];
    self.phoneNumber            = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"phoneNumber"]];
    self.email                  = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"email"]];;
    
    self.extraGuests            = [[self.guestPFObject objectForKey:@"extraGuests"] intValue];
    self.encodedRsvpStatus      = [[self.guestPFObject objectForKey:@"rsvpStatus"] intValue];
    self.encodedInvitedStatus   = [[self.guestPFObject objectForKey:@"invitedStatus"] intValue];
    self.encodedGuestType       = [[self.guestPFObject objectForKey:@"guestType"] intValue];
    
    self.rsvpStatus             = ( self.encodedRsvpStatus == GUEST_RSVPED ) ? @"RSVP" : @"";
    self.invitedStatus          = ( self.encodedInvitedStatus == GUEST_INVITED ) ? @"Invited" : @"Not Invited";
    self.guestType              = ( self.encodedGuestType == GUEST_TYPE_INVITE_LIST ) ? @"Invite List" : @"Wait List";
}

-(void) updateGuestWithGuest: (Guest*) updateGuest withBlock:(PFBooleanResultBlock)resultBlock{
    PFObject *currentPfObject = self.guestPFObject;
    
    //parse cannot accept nil for values
    currentPfObject[@"firstName"]       = [HelperMethods ModifyToNSNullForObject:updateGuest.firstName];
    currentPfObject[@"lastName"]        = [HelperMethods ModifyToNSNullForObject:updateGuest.lastName];
    currentPfObject[@"addressOne"]      = [HelperMethods ModifyToNSNullForObject:updateGuest.addressLineOne];
    currentPfObject[@"addressTwo"]      = [HelperMethods ModifyToNSNullForObject:updateGuest.addressLineTwo];
    currentPfObject[@"city"]            = [HelperMethods ModifyToNSNullForObject:updateGuest.city];
    currentPfObject[@"state"]           = [HelperMethods ModifyToNSNullForObject:updateGuest.state];
    currentPfObject[@"zipCode"]         = [HelperMethods ModifyToNSNullForObject:updateGuest.zip];
    currentPfObject[@"phoneNumber"]     = [HelperMethods ModifyToNSNullForObject:updateGuest.phoneNumber];
    currentPfObject[@"email"]           = [HelperMethods ModifyToNSNullForObject:updateGuest.email];
    currentPfObject[@"rsvpStatus"]      = [NSNumber numberWithInt:updateGuest.encodedRsvpStatus];
    currentPfObject[@"invitedStatus"]   = [NSNumber numberWithInt:updateGuest.encodedInvitedStatus];
    currentPfObject[@"guestType"]       = [NSNumber numberWithInt:updateGuest.encodedGuestType];
    if(!currentPfObject[@"extraGuests"]) {
        currentPfObject[@"extraGuests"]     = [NSNumber numberWithInt:0];
    }
    
    [currentPfObject saveInBackgroundWithBlock:resultBlock];
    
}

-(NSString*) getMissingContactInfoText {
    NSMutableArray *missingInfoText= [[NSMutableArray alloc] init];
    
    if([HelperMethods isNullString:self.addressLineOne] || [self.addressLineOne isEqualToString:@""] ) {
        [missingInfoText addObject:@"Complete Address"];
    }
    
    if([HelperMethods isNullString:self.phoneNumber] || [self.addressLineOne isEqualToString:@""] ) {
        [missingInfoText addObject:@"Phone Number"];
    }
    
    if([missingInfoText count]>0) {
        NSString *missingText = @"Missing ";
        return [missingText stringByAppendingString:[missingInfoText componentsJoinedByString:@","]];
    }
    else {
        return NULL;
    }
}

-(BOOL)isMissingAddress  {
    return [HelperMethods isNullString:self.addressLineOne] || [self.addressLineOne isEqualToString:@""];
}

-(BOOL)isMissingPhone {
    return [HelperMethods isNullString:self.phoneNumber] || [self.phoneNumber isEqualToString:@""] ;
}


-(void)moveToGuestListWithResultBlock:(PFBooleanResultBlock)resultBlock {
    self.guestPFObject[@"guestType"]       = [NSNumber numberWithInt:GUEST_TYPE_INVITE_LIST];
    [self.guestPFObject saveInBackgroundWithBlock:resultBlock];
}

-(void)moveToWaitListWithResultBlock:(PFBooleanResultBlock)resultBlock  {
    self.guestPFObject[@"guestType"]       = [NSNumber numberWithInt:GUEST_TYPE_WAITLIST];
    [self.guestPFObject saveInBackgroundWithBlock:resultBlock];
}

-(void)deleteGuestWithResultBlock:(PFBooleanResultBlock)resultBlock {
    [self.guestPFObject deleteInBackgroundWithBlock:resultBlock];
}


@end
