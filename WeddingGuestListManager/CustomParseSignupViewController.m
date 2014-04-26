//
//  CustomParseSignupViewController.m
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/19/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "CustomParseSignupViewController.h"

@interface CustomParseSignupViewController ()

@end

@implementation CustomParseSignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    self.signUpView.usernameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.signUpView.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.signUpView.emailField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.signUpView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"None"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
