//
//  MenuItemView.h
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/26/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemView : UIView

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *barView;

@end
