//
//  InviteMessageViewController.m
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/13/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "InviteMessageViewController.h"
#import "MailgunHelperClient.h"
#import <Parse/Parse.h>
#import "MessageHelper.h"
#import "Event.h"

@interface InviteMessageViewController ()
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *headerTextLabel;
- (IBAction)onSendButton:(id)sender;

@property (strong,nonatomic) NSString *bodyText;

@end

@implementation InviteMessageViewController

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
    [self setTitle:@"Compose"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(onSendButton:)];
    
    self.messageTextView.delegate=self;
    
    if(!self.isInvite) {
        self.headerTextLabel.text = @"Compose 'Save The Date' reminder:";
    }
    else {
        self.headerTextLabel.text = @"Compose your wedding invitation:";
    }
    self.messageTextView.text = @"Message here...";
    
    [self.messageTextView becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSendButton:(id)sender {
    
    [self.messageTextView endEditing:YES];
    
    if (self.messageTextView.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter a message!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else {
        
        PFQuery *query = [PFQuery queryWithClassName:@"Guest"];
        [query whereKey:@"eventId" equalTo:[Event currentEvent].eventPFObject];
        [query findObjectsInBackgroundWithBlock:^(NSArray *guests, NSError *error) {
        
            MailgunHelperClient *mailgun= [MailgunHelperClient instance];
            if (self.isInvite) {
                [mailgun sendMessageTo:[MessageHelper getDictionaryOfUrls:guests forProfile:NO]
                           withSubject:@"Wedding Invitation"
                              withBody:self.messageTextView.text];
            }
            else {
                [mailgun sendMessageTo:[MessageHelper getDictionaryOfUrls:guests forProfile:NO]
                           withSubject:@"Reminder: Save the Date!"
                              withBody:self.messageTextView.text];
            }
        
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
