//
//  GuestViewController.m
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/19/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "GuestViewController.h"

@interface GuestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rsvpSegmentControl;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;

@property (assign, nonatomic) BOOL isBasicDetailsChanged;

- (void)basicDetailsChanged: (id)event;
@end

@implementation GuestViewController

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveButton)];
    
    self.isBasicDetailsChanged = NO;
    
    //initialize the details
    self.firstNameTextField.text = [self.currentGuest firstName];
    self.lastNameTextField.text = [self.currentGuest lastName];
    self.emailTextField.text = [self.currentGuest email];
    self.phoneTextField.text = [self.currentGuest phoneNumber];
    self.addressTextField.text = [self.currentGuest addressLineOne];
    self.cityTextField.text = [self.currentGuest city];
    self.stateTextField.text = [self.currentGuest state];
    
    [self.firstNameTextField addTarget:self
                  action:@selector(basicDetailsChanged:)
        forControlEvents:UIControlEventEditingChanged];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignResponders];
}

- (void)onSaveButton
{
    [self resignResponders];
    Guest *updateGuest = [[Guest alloc] init];
    updateGuest.firstName = self.firstNameTextField.text;
    updateGuest.lastName = self.lastNameTextField.text;
    updateGuest.email = self.emailTextField.text;
    updateGuest.phoneNumber = self.phoneTextField.text;
    updateGuest.addressLineOne = self.addressTextField.text;
    updateGuest.city = self.cityTextField.text;
    updateGuest.state = self.stateTextField.text;
    
    //update these values later accordingly
    updateGuest.encodedInvitedStatus = GUEST_NOT_INVITED;
    updateGuest.encodedRsvpStatus = GUEST_NOT_RSVPED;
    updateGuest.encodedGuestType = GUEST_TYPE_0;
    
    [self.currentGuest updateGuestWithGuest:updateGuest withBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            NSLog(@"GuestViewController: Error on updating guest: %@",error);
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)basicDetailsChanged: (id )event {
    self.isBasicDetailsChanged= YES;
}

-(void) resignResponders {
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField  resignFirstResponder];
    [self.emailTextField     resignFirstResponder];
    [self.phoneTextField     resignFirstResponder];
    [self.addressTextField   resignFirstResponder];
    [self.cityTextField      resignFirstResponder];
    [self.stateTextField     resignFirstResponder];
}


@end
