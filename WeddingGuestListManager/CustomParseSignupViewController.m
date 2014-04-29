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
    
    self.signUpView.usernameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    self.signUpView.usernameField.layer.shadowColor = [UIColor clearColor].CGColor;
    self.signUpView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.signUpView.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    self.signUpView.passwordField.layer.shadowColor = [UIColor clearColor].CGColor;
    self.signUpView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.signUpView.emailField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    self.signUpView.emailField.layer.shadowColor = [UIColor clearColor].CGColor;
    self.signUpView.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.signUpView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginLogo"]];
    
    [self.signUpView.signUpButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.signUpView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
