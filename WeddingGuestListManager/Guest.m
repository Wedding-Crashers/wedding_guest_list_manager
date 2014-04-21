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
    self.encodedRsvpStatus      = [[self.guestPFObject objectForKey:@"rsvpStatus"] intValue];
    self.encodedInvitedStatus   = [[self.guestPFObject objectForKey:@"invitedStatus"] intValue];
    self.encodedGuestType       = [[self.guestPFObject objectForKey:@"guestType"] intValue];
    
    self.rsvpStatus             = ( self.encodedRsvpStatus == GUEST_RSVPED ) ? @"Rsvp'ed" : @"Not Rsvp'ed";
    self.invitedStatus          = ( self.encodedInvitedStatus == GUEST_INVITED ) ? @"Invited" : @"Not Invited";
    self.guestType              = ( self.encodedGuestType == GUEST_TYPE_INVITE_LIST ) ? @"Invite List" : @"Wait List";
}

-(void) updateGuestWithGuest: (Guest*) updateGuest withBlock:(PFBooleanResultBlock)resultBlock{
    PFObject *currentPfObject = self.guestPFObject;
    
    //parse cannot accept nil for values
    currentPfObject[@"firstName"]       = [Guest ModifyToNSNullForObject:updateGuest.firstName];
    currentPfObject[@"lastName"]        = [Guest ModifyToNSNullForObject:updateGuest.lastName];
    currentPfObject[@"addressOne"]      = [Guest ModifyToNSNullForObject:updateGuest.addressLineOne];
    currentPfObject[@"addressTwo"]      = [Guest ModifyToNSNullForObject:updateGuest.addressLineTwo];
    currentPfObject[@"city"]            = [Guest ModifyToNSNullForObject:updateGuest.city];
    currentPfObject[@"state"]           = [Guest ModifyToNSNullForObject:updateGuest.state];
    currentPfObject[@"zipCode"]         = [Guest ModifyToNSNullForObject:updateGuest.zip];
    currentPfObject[@"phoneNumber"]     = [Guest ModifyToNSNullForObject:updateGuest.phoneNumber];
    currentPfObject[@"email"]           = [Guest ModifyToNSNullForObject:updateGuest.email];
    currentPfObject[@"rsvpStatus"]      = [NSNumber numberWithInt:updateGuest.encodedRsvpStatus];
    currentPfObject[@"invitedStatus"]   = [NSNumber numberWithInt:updateGuest.encodedInvitedStatus];
    currentPfObject[@"guestType"]       = [NSNumber numberWithInt:updateGuest.encodedGuestType];
    
    [currentPfObject saveInBackgroundWithBlock:resultBlock];
    
}

-(NSString*) getMissingContactInfoText {
    NSMutableArray *missingInfoText= [[NSMutableArray alloc] init];
    
    if([Guest isNullString:self.addressLineOne]) {
        [missingInfoText addObject:@"Complete Address"];
    }
    
    if([Guest isNullString:self.phoneNumber]) {
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


@end
