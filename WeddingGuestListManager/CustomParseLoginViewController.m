//
//  CustomParseLoginViewController.m
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/18/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "CustomParseLoginViewController.h"

@interface CustomParseLoginViewController ()

@end

@implementation CustomParseLoginViewController

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
    
    self.logInView.usernameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.25];
    self.logInView.usernameField.layer.shadowColor = [UIColor clearColor].CGColor;
    self.logInView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.logInView.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    self.logInView.passwordField.layer.shadowColor = [UIColor clearColor].CGColor;
    self.logInView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    
    [self.logInView.usernameField setTextColor:[UIColor whiteColor]];
    [self.logInView.usernameField setTintColor:[UIColor whiteColor]];

    self.logInView.dismissButton.hidden = YES;

    self.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginLogo"]];
    self.logInView.signUpLabel.text = @"";

    
    [self.logInView.logInButton setBackgroundColor:[UIColor lightGrayColor]];    
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.logInView.logInButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    
    [self.logInView.signUpButton setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:.25]];
    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
