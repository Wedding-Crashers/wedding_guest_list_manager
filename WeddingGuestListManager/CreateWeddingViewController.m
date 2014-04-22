//
//  CreateWeddingViewController.m
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/12/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "CreateWeddingViewController.h"
#import "Event.h"
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
    
    if(self.eventObject) {
        self.weddingNameTextField.text   = self.eventObject[@"title"];
        self.numberOfGuestTextField.text = self.eventObject[@"numberOfGuests"];
        self.locationTextField.text      = self.eventObject[@"location"];
        self.dateDatePicker.date         = self.eventObject[@"date"];
    }
}

- (void)onSaveButton {
    NSLog(@"Saving Wedding");
    
    // Create event
    PFObject *eventPFOject = [PFObject objectWithClassName:@"Event"];
    
    Event *event = [Event currentEvent];
    [event updateCurrentEventWithPFObject:eventPFOject];
    
    event.title          = self.weddingNameTextField.text;
    event.numberOfGuests = [self.numberOfGuestTextField.text intValue];
    event.location       = self.locationTextField.text;
    event.date           = self.dateDatePicker.date;
    
    // Add ownedBy Relation
    PFRelation *relation = [event.eventPFObject relationforKey:@"ownedBy"];
    [relation addObject:[PFUser currentUser]];

    
    // Save to Parse
    event.eventPFObject[@"title"]          = self.weddingNameTextField.text   ? self.weddingNameTextField.text: [NSNull null];
    event.eventPFObject[@"location"]       = self.locationTextField.text      ? self.locationTextField.text : 0;
    event.eventPFObject[@"date"]           = self.dateDatePicker.date         ? self.dateDatePicker.date: [NSNull null];
    event.eventPFObject[@"numberOfGuests"] = self.numberOfGuestTextField.text;

    [event.eventPFObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            NSLog(@"CreateWeddingViewController: Error on updating saving event: %@",error);
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
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
