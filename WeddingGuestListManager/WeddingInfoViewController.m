//
//  WeddingInfoViewController.m
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/5/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "WeddingInfoViewController.h"
#import "CreateWeddingViewController.h"
#import "GuestlistTableViewController.h"
#import <Parse/Parse.h>
#import "CustomParseLoginViewController.h"
#import "CustomParseSignupViewController.h"
#import "CreateWeddingViewController.h"
#import "MessageCenterViewController.h"

@interface WeddingInfoViewController ()
@property (weak,nonatomic) NSString *currentTitle;
@property (weak, nonatomic) IBOutlet UILabel *weddingNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGuestsTextField;
@property (weak, nonatomic) IBOutlet UILabel *locationTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateTextField;
@property (weak, nonatomic) IBOutlet UILabel *attendingLabel;
@property (weak, nonatomic) IBOutlet UILabel *declinedLabel;
@property (strong, nonatomic) id eventObject;

- (IBAction)onGuestlistButton:(id)sender;
- (IBAction)onMessageCenterButton:(id)sender;
- (IBAction)onWeddingDetailsButton:(id)sender;


@end

@implementation WeddingInfoViewController

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
    
    // Configure the Navigation Bar
    self.navigationItem.title = @"Wedding Details";
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    self.navigationItem.rightBarButtonItem = signOutButton;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"View Did Load");
    
    // No user logged in
    if (![PFUser currentUser]) {
        // Create the log in view controller
        CustomParseLoginViewController *logInViewController = [[CustomParseLoginViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        CustomParseSignupViewController *signUpViewController = [[CustomParseSignupViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    // User logged in
    else {
        // Look for Events owned by user
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        [query whereKey:@"ownedBy" equalTo: [PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            // If an event is found set the IBOutlets with event properties
            if(!error && objects && objects.count > 0) {
                self.eventObject = objects[0];
                self.weddingNameTextField.text    = [self.eventObject objectForKey:@"title"];
                self.numberOfGuestsTextField.text = [self.eventObject objectForKey:@"numberOfGuests"];
                self.locationTextField.text       = [self.eventObject objectForKey:@"location"];
                self.dateTextField.text           = [NSString stringWithFormat:@"%@",[self.eventObject objectForKey:@"date"]];
                // If no event found, go to CreateWeddingViewController
            } else {
                
                CreateWeddingViewController *createWeddingViewController = [[CreateWeddingViewController alloc] init];
                UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController: createWeddingViewController];
                
                // Present the log in view controller
                [self presentViewController:navigationViewController animated:YES completion:NULL];
            }
        }];
    }
}

-(void)onSignOutButton {
    NSLog(@"Logging Out from Parse");
    [PFUser logOut];
    
    // Create the log in view controller
    CustomParseLoginViewController *logInViewController = [[CustomParseLoginViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Create the sign up view controller
    CustomParseSignupViewController *signUpViewController = [[CustomParseSignupViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"User Logged in Correctly!");
    [self dismissViewControllerAnimated:YES completion:^{} ];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"User Signed Up in Correctly!");
    [self dismissViewControllerAnimated:YES completion:^{} ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onGuestlistButton:(id)sender {
    if(self.eventObject) {
        GuestlistTableViewController *guestlistTableViewController = [[GuestlistTableViewController alloc] init];
        guestlistTableViewController.eventObject = self.eventObject;
        
        [self.navigationController pushViewController:guestlistTableViewController animated:YES];
    }
}

- (IBAction)onMessageCenterButton:(id)sender {
    MessageCenterViewController *messageCenterViewController = [[MessageCenterViewController alloc] init];
    [self.navigationController pushViewController:messageCenterViewController animated:YES];
}

- (IBAction)onWeddingDetailsButton:(id)sender {
    CreateWeddingViewController *createWeddingViewController = [[CreateWeddingViewController alloc] init];
    createWeddingViewController.eventObject = self.eventObject;
    
    [self.navigationController pushViewController:createWeddingViewController animated:YES];
}
@end
