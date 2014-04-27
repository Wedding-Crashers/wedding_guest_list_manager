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
#import "Event.h"

@interface RequestInfoViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *addressSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *phoneSwitch;
@property (weak, nonatomic) IBOutlet UITextView *messageText;

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
    
    [self setTitle:@"Compose"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(onSendButton:)];
    
    [self.messageText becomeFirstResponder];
    
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
    
    [self.messageText endEditing:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Guest"];
    [query whereKey:@"eventId" equalTo:[Event currentEvent].eventPFObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray *guests, NSError *error) {
        guests = [self filterGuests:guests];
        MailgunHelperClient *mailgun = [MailgunHelperClient instance];
        [mailgun sendMessageTo:[MessageHelper getDictionaryOfUrls:guests forProfile:YES] withSubject:@"Request" withBody:self.messageText.text];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (NSArray *)filterGuests:(NSArray *)guests {
    
    NSMutableArray *newGuests = [[NSMutableArray alloc] init];
    
    if (self.phoneSwitch.on && self.addressSwitch.on) {
        for (PFObject *guest in guests) {
            NSString *phoneNumber = guest[@"phoneNumber"];
            NSString *address = guest[@"addressOne"];
            if ([phoneNumber isEqualToString:@""] || [address isEqualToString:@""]) {
                [newGuests addObject:guest];
            }
        }
    }
    else if (self.phoneSwitch.on) {
        for (PFObject *guest in guests) {
                NSString *phoneNumber = guest[@"phoneNumber"];
            if ([phoneNumber isEqualToString:@""]) {
                [newGuests addObject:guest];
            }
        }
    }
    else if (self.addressSwitch.on) {
        for (PFObject *guest in guests) {
            NSString *address = guest[@"addressOne"];
            if ([address isEqualToString:@""]) {
                [newGuests addObject:guest];
            }
        }
    }
    return [newGuests mutableCopy];
}

@end
