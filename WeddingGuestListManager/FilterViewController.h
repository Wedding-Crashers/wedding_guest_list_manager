//
//  FilterViewController.h
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/20/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewDelegate <NSObject>

-(void)processFilterSettingsData:(NSDictionary *)data;

@end

@interface FilterViewController : UIViewController

@property (nonatomic, assign) id<FilterViewDelegate> delegate;

@end
