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
}

-(NSString*) firstName {
    return [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"firstName"]];
}

-(NSString*) lastName {
    return [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"lastName"]];
}

-(NSString*) addressLineOne {
    return [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"addressOne"]];
}

-(NSString*) addressLineTwo {
    return [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"addressTwo"]];
}

-(NSString*) city {
    return [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"city"]];
}

-(NSString*) state {
    return [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"state"]];
}

-(NSString*) zip {
    return [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"zipCode"]];
}

-(NSString*) rsvpStatus {
    return [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"rsvpStatus"]];
}

-(NSString*) phoneNumber {
    return [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"phoneNumber"]];
}

-(NSString*) email {
    return [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"email"]];;
}

-(NSString*) invitedStatus {
    return [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"invitedStatus"]];;
}

-(NSString*) guestType {
    return [NSString stringWithFormat:@"%@",[self.guestPFObject objectForKey:@"guestType"]];
}

@end
