//
//  GuestlistTableViewCell.h
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/13/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GUEST_LIST_TABLE_CELL_HEIGHT 102.0f

@interface GuestlistTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *rsvpStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end
