//
//  InviteMessageViewController.m
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/13/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "InviteMessageViewController.h"
#import "MailgunHelperClient.h"

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
    MailgunHelperClient *mailgun= [MailgunHelperClient instance];
    [mailgun sendMessageTo:[NSArray arrayWithObjects:@"sai.kante@hotmail.com",nil] withSubject:@"invitation" withBody:self.bodyText];
    
}

- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark UITextViewDelegate methods

// - (void)sendMessageTo:(NSArray *)recipientsList withSubject:(NSString*)subject withBody:(NSString*)bodyText;

- (void)textViewDidChange:(UITextView *)textView {
    self.bodyText= textView.text;
}

@end
