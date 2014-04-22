//
//  AppDelegate.h
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/1/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomParseLoginViewController.h"
#import "CustomParseSignupViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
