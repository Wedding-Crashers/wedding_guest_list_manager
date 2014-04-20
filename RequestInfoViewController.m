//
//  RequestInfoViewController.m
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/14/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "RequestInfoViewController.h"
#import "MailgunHelperClient.h"

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
    MailgunHelperClient *mailgun= [MailgunHelperClient instance];
    //do custom things for phone and address later.
    [mailgun sendMessageTo:[NSArray arrayWithObjects:@"david@ladowitz.com",nil] withSubject:@"invitation" withBody:self.messageText.text];
    
    
}

- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
