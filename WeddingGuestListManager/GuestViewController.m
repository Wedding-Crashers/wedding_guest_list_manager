//
//  GuestViewController.m
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/19/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "GuestViewController.h"
#include <stdlib.h>
#include "HelperMethods.h"

@interface GuestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIView *nameContainerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *rsvpSegmentControl;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *address2TextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UIView *addressContainerView;

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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveButton)];
    
    self.nameContainerView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
    self.addressContainerView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
    
    //initialize the details
    self.firstNameTextField.text = [HelperMethods ModifyToBlankTextForString:[self.currentGuest firstName]];
    self.lastNameTextField.text = [HelperMethods ModifyToBlankTextForString:[self.currentGuest lastName]];
    self.emailTextField.text = [HelperMethods ModifyToBlankTextForString:[self.currentGuest email]];
    self.phoneTextField.text = [HelperMethods ModifyToBlankTextForString:[self.currentGuest phoneNumber]];
    self.addressTextField.text = [HelperMethods ModifyToBlankTextForString:[self.currentGuest addressLineOne]];
    self.address2TextField.text = [HelperMethods ModifyToBlankTextForString:[self.currentGuest addressLineTwo]];
    self.cityTextField.text = [HelperMethods ModifyToBlankTextForString:[self.currentGuest city]];
    self.stateTextField.text = [HelperMethods ModifyToBlankTextForString:[self.currentGuest state]];
    self.zipTextField.text = [HelperMethods ModifyToBlankTextForString:[self.currentGuest zip]];
    
    if([self.currentGuest encodedGuestType] == 1) {
        self.rsvpSegmentControl.selectedSegmentIndex = 1;
    }
    else {
        if([self.currentGuest encodedRsvpStatus] == 0) {
            self.rsvpSegmentControl.selectedSegmentIndex = 0;
        }
        else if([self.currentGuest encodedRsvpStatus] == 1) {
            self.rsvpSegmentControl.selectedSegmentIndex = 2;
        }
        else {
            self.rsvpSegmentControl.selectedSegmentIndex = 3;
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignResponders];
}

- (void)onSaveButton
{
    [self resignResponders];
    
    if(self.firstNameTextField.text && self.lastNameTextField.text && self.emailTextField.text) {
        Guest *updateGuest = [[Guest alloc] init];
        updateGuest.firstName = self.firstNameTextField.text;
        updateGuest.lastName = self.lastNameTextField.text;
        updateGuest.email = self.emailTextField.text;
        updateGuest.phoneNumber = self.phoneTextField.text;
        updateGuest.addressLineOne = self.addressTextField.text;
        updateGuest.addressLineTwo = self.address2TextField.text;
        updateGuest.city = self.cityTextField.text;
        updateGuest.state = self.stateTextField.text;
        updateGuest.zip = self.zipTextField.text;
        
        if(self.rsvpSegmentControl.selectedSegmentIndex == 0) {
            updateGuest.encodedGuestType = GUEST_TYPE_INVITE_LIST;
            updateGuest.encodedInvitedStatus = GUEST_NOT_INVITED;
            updateGuest.encodedRsvpStatus = GUEST_NOT_RSVPED;
        }
        else if (self.rsvpSegmentControl.selectedSegmentIndex == 1){
            updateGuest.encodedGuestType = GUEST_TYPE_WAITLIST;
            updateGuest.encodedInvitedStatus = GUEST_NOT_INVITED;
            updateGuest.encodedRsvpStatus = GUEST_NOT_RSVPED;
        }
        else if (self.rsvpSegmentControl.selectedSegmentIndex == 2) {
            updateGuest.encodedGuestType = GUEST_TYPE_INVITE_LIST;
            updateGuest.encodedInvitedStatus = GUEST_INVITED;
            updateGuest.encodedRsvpStatus = GUEST_RSVPED;
        }
        else {
            updateGuest.encodedGuestType = GUEST_TYPE_INVITE_LIST;
            updateGuest.encodedInvitedStatus = GUEST_INVITED;
            updateGuest.encodedRsvpStatus = GUEST_DECLINED;
        }
        
        [self.currentGuest updateGuestWithGuest:updateGuest withBlock:^(BOOL succeeded, NSError *error) {
            if(error) {
                NSLog(@"GuestViewController: Error on updating guest: %@",error);
            }
            else {
                NSLog(@"GuestViewController: updated guest successfully:");
            }
            if(self.delegate) {
                [self.delegate guestUpdatedInGuestViewController];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"You need to fill in name and email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) resignResponders {
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField  resignFirstResponder];
    [self.emailTextField     resignFirstResponder];
    [self.phoneTextField     resignFirstResponder];
    [self.addressTextField   resignFirstResponder];
    [self.address2TextField   resignFirstResponder];
    [self.cityTextField      resignFirstResponder];
    [self.stateTextField     resignFirstResponder];
    [self.zipTextField       resignFirstResponder];
}


@end
