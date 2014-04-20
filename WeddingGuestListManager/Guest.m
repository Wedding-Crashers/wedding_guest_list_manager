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
    self.rsvpStatus             = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"rsvpStatus"]];
    self.phoneNumber            = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"phoneNumber"]];
    self.email                  = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"email"]];;
    self.invitedStatus          = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"invitedStatus"]];;
    self.guestType              = [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"guestType"]];
    self.encodedRsvpStatus      = [[self.guestPFObject objectForKey:@"rsvpStatus"] intValue];
    self.encodedInvitedStatus   = [[self.guestPFObject objectForKey:@"invitedStatus"] intValue];
    self.encodedGuestType       = [[self.guestPFObject objectForKey:@"guestType"] intValue];
}

-(void) updateGuestWithGuest: (Guest*) updateGuest withBlock:(PFBooleanResultBlock)resultBlock{
    PFObject *currentPfObject = self.guestPFObject;
    
    //parse cannot accept nil for values
    currentPfObject[@"firstName"]       = updateGuest.firstName                 ? updateGuest.firstName : [NSNull null];
    currentPfObject[@"lastName"]        = updateGuest.lastName                  ? updateGuest.lastName: [NSNull null];
    currentPfObject[@"addressOne"]      = updateGuest.addressLineOne            ? updateGuest.addressLineOne: [NSNull null];
    currentPfObject[@"addressTwo"]      = updateGuest.addressLineTwo            ? updateGuest.addressLineTwo: [NSNull null];
    currentPfObject[@"city"]            = updateGuest.city                      ? updateGuest.city: [NSNull null];
    currentPfObject[@"state"]           = updateGuest.state                     ? updateGuest.state: [NSNull null];
    currentPfObject[@"zipCode"]         = updateGuest.zip                       ? updateGuest.zip: [NSNull null];
    currentPfObject[@"phoneNumber"]     = updateGuest.phoneNumber               ? updateGuest.phoneNumber: [NSNull null];
    currentPfObject[@"email"]           = updateGuest.email                     ? updateGuest.email: [NSNull null];
    currentPfObject[@"rsvpStatus"]      = [NSNumber numberWithInt:updateGuest.encodedRsvpStatus];
    currentPfObject[@"invitedStatus"]   = [NSNumber numberWithInt:updateGuest.encodedInvitedStatus];
    currentPfObject[@"guestType"]       = [NSNumber numberWithInt:updateGuest.encodedGuestType];
    
    [currentPfObject saveInBackgroundWithBlock:resultBlock];
    
}



@end
