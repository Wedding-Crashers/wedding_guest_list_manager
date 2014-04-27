//
//  ComposeMessageViewController.m
//  WeddingGuestListManager
//
//  Created by THOMAS CHEN on 4/26/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "ComposeMessageViewController.h"
#import "MailgunHelperClient.h"
#import <Parse/Parse.h>
#import "MessageHelper.h"
#import "Event.h"

@interface ComposeMessageViewController ()
@property (weak, nonatomic) IBOutlet UIView *testMessageContainer;
@property (weak, nonatomic) IBOutlet UISwitch *testMessageSwitch;
@property (weak, nonatomic) IBOutlet UIView *messageViewContainer;
@property (weak, nonatomic) IBOutlet UITextView *messageView;
@property (strong, nonatomic) NSNumber *type;

@end

@implementation ComposeMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(NSNumber *)type {
    self = [super init];
    self.type = type;    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.testMessageContainer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
    self.messageViewContainer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.55];
    
    if([self.type isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [self setTitle:@"Request Information"];
        [self.messageView setText:@"Please follow the link below and fill out your contact information! "];
        
    }
    else if([self.type isEqualToNumber: [NSNumber numberWithInt:1]]) {
        [self setTitle:@"Save the Date"];
        [self.messageView setText:@"Please clear your schedules for the date: (Date here). "];
    }
    else {
        [self setTitle:@"Wedding Invitation"];
        [self.messageView setText:@"You're invited to (Name's here) wedding! "];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(onSendButton:)];
    
    self.messageView.delegate = self;
    
    [self.messageView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSendButton:(id)sender {
    
    [self.messageView endEditing:YES];
    
    if (self.messageView.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter a message!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else {
        if([self.type isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [self sendRequestInfo];
        }
        else if([self.type isEqualToNumber: [NSNumber numberWithInt:1]]) {
            [self sendSaveTheDate];
        }
        else {
            [self sendInvite];
        }
    }
}

- (void)sendRequestInfo {
    MailgunHelperClient *mailgun = [MailgunHelperClient instance];
    if (![self.testMessageSwitch isOn]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Guest"];
        [query whereKey:@"eventId" equalTo:[Event currentEvent].eventPFObject];
        [query findObjectsInBackgroundWithBlock:^(NSArray *guests, NSError *error) {
            guests = [self findGuestsWithIncompleteProfile:guests];
            [mailgun sendMessageTo:[MessageHelper getDictionaryOfUrls:guests forProfile:YES]
                       withSubject:@"Contact Information Request!"
                          withBody:self.messageView.text];
        }];
    }
    else {
        [mailgun sendMessageTo:[MessageHelper getDictionaryForTestForProfile:YES] withSubject:@"TEST: Contact Information Request!" withBody:self.messageView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendSaveTheDate {
    MailgunHelperClient *mailgun = [MailgunHelperClient instance];
    if (![self.testMessageSwitch isOn]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Guest"];
        [query whereKey:@"eventId" equalTo:[Event currentEvent].eventPFObject];
        [query findObjectsInBackgroundWithBlock:^(NSArray *guests, NSError *error) {
            guests = [self findGuestsOnInviteList:guests];
            [mailgun sendMessageTo:[MessageHelper getDictionaryOfUrls:guests forProfile:NO]
                       withSubject:@"Reminder: Save the Date!"
                          withBody:self.messageView.text];
        }];
    }
    else {
        [mailgun sendMessageTo:[MessageHelper getDictionaryForTestForProfile:NO] withSubject:@"TEST: Reminder: Save the Date!" withBody:self.messageView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendInvite {
    MailgunHelperClient *mailgun = [MailgunHelperClient instance];
    if (![self.testMessageSwitch isOn]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Guest"];
        [query whereKey:@"eventId" equalTo:[Event currentEvent].eventPFObject];
        [query findObjectsInBackgroundWithBlock:^(NSArray *guests, NSError *error) {
            guests = [self findGuestsOnInviteListAndNotInvited:guests];
            [mailgun sendMessageTo:[MessageHelper getDictionaryOfUrls:guests forProfile:NO]
                       withSubject:@"Wedding Invitation"
                          withBody:self.messageView.text];
            
            for (PFObject *guest in guests) {
                guest[@"invitedStatus"] = @1;
                [guest saveInBackground];
            }
            
        }];
    }
    else {
        [mailgun sendMessageTo:[MessageHelper getDictionaryForTestForProfile:NO] withSubject:@"TEST: Wedding Invitation" withBody:self.messageView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSArray *)findGuestsWithIncompleteProfile:(NSArray *)guests {
    
    NSMutableArray *newGuests = [[NSMutableArray alloc] init];
    
    for (PFObject *guest in guests) {
        NSString *firstName = guest[@"firstName"];
        NSString *lastName = guest[@"lastName"];
        NSString *phoneNumber = guest[@"phoneNumber"];
        NSString *email = guest[@"email"];
        NSString *addressOne = guest[@"addressOne"];
        NSString *zipCode = guest[@"zipCode"];
        NSString *city = guest[@"city"];
        NSString *state = guest[@"state"];
        
        if ([firstName isEqualToString:@""] ||
            [lastName isEqualToString:@""] ||
            [phoneNumber isEqualToString:@""] ||
            [email isEqualToString:@""] ||
            [addressOne isEqualToString:@""] ||
            [zipCode isEqualToString:@""] ||
            [city isEqualToString:@""] ||
            [state isEqualToString:@""]) {
            [newGuests addObject:guest];
        }
    }
    return [newGuests mutableCopy];
}

- (NSArray *)findGuestsOnInviteList:(NSArray *)guests {
    NSMutableArray *newGuests = [[NSMutableArray alloc] init];
    
    for (PFObject *guest in guests) {
        if([guest[@"guestType"] intValue] == 0) {
            [newGuests addObject:guest];
        }
    }
    return [newGuests mutableCopy];
}

- (NSArray *)findGuestsOnInviteListAndNotInvited:(NSArray *)guests {
    NSMutableArray *newGuests = [[NSMutableArray alloc] init];
    
    for (PFObject *guest in guests) {
        if([guest[@"guestType"] intValue] == 0 && [guest[@"invitedStatus"] intValue] == 0) {
            [newGuests addObject:guest];
        }
    }
    return [newGuests mutableCopy];
}

@end
