//
//  WeddingInfoViewController.m
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/5/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "WeddingInfoViewController.h"
#import "CreateWeddingViewController.h"
#import "GuestlistViewController.h"
#import "GuestlistTableViewController.h"
#import <Parse/Parse.h>

@interface WeddingInfoViewController ()
@property (weak,nonatomic) NSString *currentTitle;
@property (weak, nonatomic) IBOutlet UILabel *weddingNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGuestsTextField;
@property (weak, nonatomic) IBOutlet UILabel *locationTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateTextField;

- (IBAction)onGuestlistButton:(id)sender;
- (IBAction)onMessageCenterButton:(id)sender;

//- (IBAction)titleTextChanged:(id)sender;
//- (IBAction)saveButtonClicked:(id)sender;


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
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
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
                
                self.weddingNameTextField.text = [objects[0] objectForKey:@"title"];
                self.numberOfGuestsTextField.text = [objects[0] objectForKey:@"numberOfGuests"];
                self.locationTextField.text       = [objects[0] objectForKey:@"location"];
                // self.dateTextField.text           = [objects[0] objectForKey:@"date"];
                
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
    
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
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


//- (IBAction)saveButtonClicked:(id)sender {
//    if([self.weddingNameTextField.text isEqualToString:self.currentTitle]) {
//       return;
//    }
//
//    PFQuery *query= [PFQuery queryWithClassName:@"Event"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if(!error && objects && objects.count > 0) {
//            
//            [objects[0] setObject:self.weddingNameTextField.text forKey:@"title"];
//            [objects[0] save];
//       }
//        else if(!error){  //no current object present. so create a new row
//            
//            PFObject *newEvent = [PFObject objectWithClassName:@"Event"];
//            newEvent[@"title"] = self.weddingNameTextField.text;
//            PFRelation *relation = [newEvent relationforKey:@"ownedBy"];
//            [relation addObject:[PFUser currentUser]];
//            [newEvent saveInBackground];
//        }
//    }];
//    
//    self.currentTitle=self.weddingNameTextField.text;
//}

- (IBAction)onGuestlistButton:(id)sender {
//    GuestlistViewController *guestlistViewController = [[GuestlistViewController alloc] init];
//    [self.navigationController pushViewController:guestlistViewController animated:YES];
    GuestlistTableViewController *guestlistTableViewController = [[GuestlistTableViewController alloc] init];
    [self.navigationController pushViewController:guestlistTableViewController animated:YES];
}

- (IBAction)onMessageCenterButton:(id)sender {
}
@end
