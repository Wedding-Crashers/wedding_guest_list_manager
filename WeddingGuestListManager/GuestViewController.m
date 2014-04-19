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
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField  resignFirstResponder];
    [self.emailTextField     resignFirstResponder];
    [self.phoneTextField     resignFirstResponder];
    [self.addressTextField   resignFirstResponder];
    [self.cityTextField      resignFirstResponder];
    [self.stateTextField     resignFirstResponder];
}

- (void)onSaveButton
{
    NSLog(@"saving guest");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
