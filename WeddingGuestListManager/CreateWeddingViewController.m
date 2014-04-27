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
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UIView *weddingContainerView;
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
    // Set transparency on container views
    self.weddingContainerView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];

    // Configure the Navigation Bar
    if(self.editMode) {
        self.navigationItem.title = @"Edit Event";
    }
    else {
        self.navigationItem.title = @"Create an Event";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveButton)];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date;
    
    if([Event currentEvent].eventPFObject) {
        self.weddingNameTextField.text   = [Event currentEvent].eventPFObject[@"title"];
        self.locationTextField.text      = [Event currentEvent].eventPFObject[@"location"];
        
        date = [Event currentEvent].eventPFObject[@"date"];
    }
    else {
        date = [NSDate date];
    }
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.dateTextField.text = dateString;
    [datePicker setDate:date];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:datePicker];
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
    eventPFObject[@"title"]          = self.weddingNameTextField.text   ? self.weddingNameTextField.text : [NSNull null];
    eventPFObject[@"location"]       = self.locationTextField.text      ? self.locationTextField.text    : 0;
    
    // Converts textField string into a Date object
    NSString *dateString = self.dateTextField.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [dateFormatter dateFromString: dateString];
    eventPFObject[@"date"] = date ? date : [NSNull null];

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
    [self.locationTextField resignFirstResponder];
    [self.dateTextField resignFirstResponder];
}

-(void)updateTextField:(id)sender
{
    if([self.dateTextField isFirstResponder]){
        UIDatePicker *picker = (UIDatePicker*)self.dateTextField.inputView;

        // Saves to text field
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        
        NSString *dateString = [dateFormatter stringFromDate:picker.date];
        self.dateTextField.text = dateString;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
