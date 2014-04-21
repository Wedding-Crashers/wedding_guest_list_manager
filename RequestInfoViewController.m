//
//  RequestInfoViewController.m
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/14/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "RequestInfoViewController.h"
#import "MailgunHelperClient.h"
#import <Parse/Parse.h>
#import "MessageHelper.h"

@interface RequestInfoViewController ()
- (IBAction)onAddressSwitch:(id)sender;
- (IBAction)onPhoneNumberSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *messageText;

@property (assign,nonatomic) BOOL isPhoneRequested;
@property (assign,nonatomic) BOOL isAddressRequested;


@end

@implementation RequestInfoViewController

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
    
    self.isPhoneRequested = YES;
    self.isAddressRequested = YES;
    [self.messageText becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAddressSwitch:(id)sender {
    self.isAddressRequested = !self.isAddressRequested;
}

- (IBAction)onPhoneNumberSwitch:(id)sender {
    self.isPhoneRequested = !self.isPhoneRequested;
}

- (IBAction)onSendButton:(id)sender {
    
    [self.messageText endEditing:YES];
    
    // THIS IS USED TO GET THE LIST OF GUESTS FOR EVENT, REMOVE THIS LATER
    PFQuery *innerQuery = [PFQuery queryWithClassName:@"Event"];
    [innerQuery whereKey:@"ownedBy" equalTo:[PFUser currentUser]];
    innerQuery.limit = 1;
    PFQuery *query = [PFQuery queryWithClassName:@"Guest"];
    [query whereKey:@"eventId" matchesQuery:innerQuery];
    NSArray *guests = [query findObjects];
    
    // THIS FILTERS THE GUEST LIST
    guests = [self filterGuests:guests];

    MailgunHelperClient *mailgun = [MailgunHelperClient instance];
    [mailgun sendMessageTo:[MessageHelper getDictionaryOfUrls:guests forProfile:YES] withSubject:@"Request" withBody:self.messageText.text];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)filterGuests:(NSArray *)guests {
    
    NSMutableArray *newGuests = [[NSMutableArray alloc] init];
    
    if (self.isPhoneRequested && self.isAddressRequested) {
        for (PFObject *guest in guests) {
            NSString *phoneNumber = guest[@"phoneNumber"];
            NSString *address = guest[@"addressOne"];
            if ([phoneNumber isEqualToString:@""] || [address isEqualToString:@""]) {
                [newGuests addObject:guest];
            }
        }
    }
    else if (self.isPhoneRequested) {
        for (PFObject *guest in guests) {
                NSString *phoneNumber = guest[@"phoneNumber"];
            if ([phoneNumber isEqualToString:@""]) {
                [newGuests addObject:guest];
            }
        }
    }
    else if (self.isAddressRequested) {
        for (PFObject *guest in guests) {
            NSString *address = guest[@"addressOne"];
            if ([address isEqualToString:@""]) {
                [newGuests addObject:guest];
            }
        }
    }
    else if (!self.isPhoneRequested && !self.isAddressRequested) {
        
    }
    return [newGuests mutableCopy];
}

- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
