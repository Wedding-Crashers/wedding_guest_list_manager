//
//  WeddingInfoViewController.m
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/5/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "WeddingInfoViewController.h"
#import <Parse/Parse.h>

@interface WeddingInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *title_tf;
@property (weak, nonatomic) IBOutlet UIButton *save_btn;
@property (weak,nonatomic) NSString *currentTitle;

- (IBAction)titleTextChanged:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;


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
    
    // Configure the sign out button
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    self.navigationItem.rightBarButtonItem = signOutButton;
    
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        ////////////// I don't think we need this
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    else {

        //Event Details
        self.currentTitle = self.title_tf.text;
        self.title_tf.delegate = self;
        
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        [query whereKey:@"ownedBy" equalTo: [PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error && objects && objects.count > 0) {
                self.title_tf.text = [objects[0] objectForKey:@"title"];
            }
        }];
        


    }
    
    
    // Do any additional setup after loading the view from its nib.
    //[self.navigationItem.leftBarButtonItem initWithTitle:@"back" style:UIBarButtonItemStylePlain    target:self action:@selector(onBackButtonClicked:)];
    

    
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"User Logged in Correctly!");
    [self dismissModalViewControllerAnimated:YES];
}


-(void)onSignOutButton {
    NSLog(@"Logging Out from Parse");
    [PFUser logOut];
    
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)titleTextChanged:(id)sender {
    
}

- (IBAction)saveButtonClicked:(id)sender {
    if([self.title_tf.text isEqualToString:self.currentTitle]) {
       return;
    }

    PFQuery *query= [PFQuery queryWithClassName:@"Event"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error && objects && objects.count > 0) {
            
            [objects[0] setObject:self.title_tf.text forKey:@"title"];
            [objects[0] save];
       }
        else if(!error){  //no current object present. so create a new row
            
            PFObject *newEvent = [PFObject objectWithClassName:@"Event"];
            newEvent[@"title"] = self.title_tf.text;
            PFRelation *relation = [newEvent relationforKey:@"ownedBy"];
            [relation addObject:[PFUser currentUser]];
            [newEvent saveInBackground];
        }
    }];
    
    self.currentTitle=self.title_tf.text;

}

- (IBAction)onBackButtonClicked:(id)sender {
    
}

#pragma mark UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
