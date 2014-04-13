//
//  CreateWeddingViewController.m
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/12/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "CreateWeddingViewController.h"
#import <Parse/Parse.h>

@interface CreateWeddingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *weddingNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberOfGuestTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateDatePicker;

@end

@implementation CreateWeddingViewController

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
    
    // Configure the Navigation Bar
    self.navigationItem.title = @"Create an Event";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveButton)];
}


- (void)onSaveButton {
    NSLog(@"Saving Wedding");
    
    // Create event
    PFObject *newEvent = [PFObject objectWithClassName:@"Event"];
    newEvent[@"title"]              = self.weddingNameTextField.text;
    newEvent[@"numberOfGuests"]     = self.numberOfGuestTextField.text;
    newEvent[@"location"]           = self.locationTextField.text;
    newEvent[@"date"]               = self.dateDatePicker.date;
    
    // Add ownedBy Relation
    PFRelation *relation = [newEvent relationforKey:@"ownedBy"];
    [relation addObject:[PFUser currentUser]];

    // Save to Parse
    [newEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Event Saved to Parse");
    }];
    
    // Dismiss and go back to WeddingInfoView
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.weddingNameTextField resignFirstResponder];
    [self.numberOfGuestTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
