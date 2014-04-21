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
@property (weak, nonatomic) IBOutlet UISwitch *awaitingResponseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *attendingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *declinedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notInvitedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *emailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *phoneSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *addressSwitch;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSaveButton {
    // Save filters and reload Guestlist
    
    NSDictionary *filterSettings = @{@"invitelistSwitch": [NSNumber numberWithBool: self.invitelistSwitch.on],
                                     @"waitlistSwitch": [NSNumber numberWithBool: self.waitlistSwitch.on],
                                     @"awaitingResponseSwitch": [NSNumber numberWithBool: self.awaitingResponseSwitch.on],
                                     @"attendingSwitch": [NSNumber numberWithBool: self.attendingSwitch.on],
                                     @"declinedSwitch": [NSNumber numberWithBool: self.declinedSwitch.on],
                                     @"notInvitedSwitch": [NSNumber numberWithBool: self.notInvitedSwitch.on],
                                     @"emailSwitch": [NSNumber numberWithBool: self.emailSwitch.on],
                                     @"phoneSwitch": [NSNumber numberWithBool: self.phoneSwitch.on],
                                     @"addressSwitch": [NSNumber numberWithBool: self.addressSwitch.on]};
    
    [self processFilterSettingsData:filterSettings];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)processFilterSettingsData:(NSDictionary *)data {
    if ([self.delegate respondsToSelector:@selector(processFilterSettingsData:)]) {
        [self.delegate processFilterSettingsData:data];
    }
}

@end
