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
    self.title=@"Message Center";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(onSendButton:)];
    
    self.messageTextView.delegate=self;
    
    if(!self.isInvite) {
        self.headerTextLabel.text = @"Compose 'Save The Date' reminder";
    }
    
    [self.messageTextView becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSendButton:(id)sender {
    
    [self.messageTextView endEditing:YES];
    
    // THIS IS USED TO GET THE LIST OF GUESTS FOR EVENT, REMOVE THIS LATER
    PFQuery *innerQuery = [PFQuery queryWithClassName:@"Event"];
    [innerQuery whereKey:@"ownedBy" equalTo:[PFUser currentUser]];
    innerQuery.limit = 1;
    PFQuery *query = [PFQuery queryWithClassName:@"Guest"];
    [query whereKey:@"eventId" matchesQuery:innerQuery];
    NSArray *guests = [query findObjects];
    
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
}

- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
