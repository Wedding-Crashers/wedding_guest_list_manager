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
    self.logInView.usernameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.logInView.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"None"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
