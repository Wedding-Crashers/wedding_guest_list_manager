//
//  FilterViewController.m
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/20/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *invitelistSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *waitlistSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *attendingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *declinedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *emailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *addressSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *phoneSwitch;

@end

@implementation FilterViewController

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
    
    // Adding Buttons to Navigation Bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveButton)];
    self.navigationItem.title = @"Filter Guests";
}


- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSaveButton {
    // Save filters and reload Guestlist
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
