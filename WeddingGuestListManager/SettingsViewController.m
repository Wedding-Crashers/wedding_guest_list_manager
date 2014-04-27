//
//  SettingsViewController.m
//  WeddingGuestListManager
//
//  Created by THOMAS CHEN on 4/26/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIView *signOutButtonContainer;
- (IBAction)onSignOutButton:(id)sender;

@end

NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@implementation SettingsViewController

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
    // Do any additional setup after loading the view from its nib.
    self.signOutButtonContainer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignOutButton:(id)sender {
    NSLog(@"Logging Out from Parse");
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}
@end
