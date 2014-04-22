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
@property (nonatomic, assign) BOOL editMode;

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

- (id)initForEditing:(BOOL)forEditing {
    self = [super init];
    self.editMode = forEditing;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the Navigation Bar
    if(self.editMode) {
        self.navigationItem.title = @"Edit Event";
    }
    else {
        self.navigationItem.title = @"Create an Event";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveButton)];
    
    if([Event currentEvent].eventPFObject) {
        self.weddingNameTextField.text   = [Event currentEvent].eventPFObject[@"title"];
        self.numberOfGuestTextField.text = [Event currentEvent].eventPFObject[@"numberOfGuests"];
        self.locationTextField.text      = [Event currentEvent].eventPFObject[@"location"];
        self.dateDatePicker.date         = [Event currentEvent].eventPFObject[@"date"];
    }
}

- (void)onSaveButton {
    NSLog(@"Saving Wedding");

    PFObject *eventPFObject;
    
    if([Event currentEvent].eventPFObject) {
        eventPFObject = [Event currentEvent].eventPFObject;
    }
    else {
        eventPFObject = [PFObject objectWithClassName:@"Event"];
        PFRelation *relation = [eventPFObject relationforKey:@"ownedBy"];
        [relation addObject:[PFUser currentUser]];
    }
    
    // Save to Parse
    eventPFObject[@"title"]          = self.weddingNameTextField.text   ? self.weddingNameTextField.text: [NSNull null];
    eventPFObject[@"location"]       = self.locationTextField.text      ? self.locationTextField.text : 0;
    eventPFObject[@"date"]           = self.dateDatePicker.date         ? self.dateDatePicker.date: [NSNull null];
    eventPFObject[@"numberOfGuests"] = self.numberOfGuestTextField.text;
    
    [eventPFObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            NSLog(@"CreateWeddingViewController: Error on updating saving event: %@",error);
        }
        else {
            [Event updateCurrentEventWithPFObject:eventPFObject];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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
