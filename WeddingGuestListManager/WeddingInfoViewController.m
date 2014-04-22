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
#import "CreateWeddingViewController.h"
#import "MessageCenterViewController.h"
#import "Guest.h"
#import "Event.h"

NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"ownedBy" equalTo: [PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // If an event is found set the IBOutlets with event properties
        if(!error && objects && objects.count > 0) {
            [Event currentEvent];
            [Event updateCurrentEventWithPFObject:objects[0]];
            [self updateInfo];
            
        } else {
            CreateWeddingViewController *createWeddingViewController = [[CreateWeddingViewController alloc] init];
            [self.navigationController pushViewController:createWeddingViewController animated:NO];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([Event currentEvent].eventPFObject) {
        [self updateInfo];
    }
}

- (void)updateInfo {
    self.weddingNameTextField.text    = [Event currentEvent].title;
    self.numberOfGuestsTextField.text = [NSString stringWithFormat:@"%i", [Event currentEvent].numberOfGuests];
    self.locationTextField.text       = [Event currentEvent].location;
    self.dateTextField.text           = [NSString stringWithFormat:@"%@",[Event currentEvent].date];

    // Get aggregate number of attending and declined RSVPs
    PFQuery *guestsQuery = [PFQuery queryWithClassName:@"Guest"];
    PFQuery *guestsAttendingQuery = [PFQuery queryWithClassName:@"Guest"];
    
    [guestsAttendingQuery whereKey:@"eventId" equalTo:[Event currentEvent].eventPFObject];
    [guestsAttendingQuery whereKey:@"rsvpStatus" equalTo:[NSNumber numberWithInt:1]];
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[guestsQuery,guestsAttendingQuery]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if(!error && results && results.count > 0) {
            self.attendingLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)results.count];
        } else {
            NSLog(@"%@", error);
        }
    }];
    
    PFQuery *guestsDecliningQuery = [PFQuery queryWithClassName:@"Guest"];
    [guestsDecliningQuery whereKey:@"rsvpStatus" equalTo:[NSNumber numberWithInt:2]];
    PFQuery *queryDecline = [PFQuery orQueryWithSubqueries:@[guestsQuery,guestsAttendingQuery]];
    [queryDecline findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if(!error && results && results.count > 0) {
            self.declinedLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)results.count];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

-(void)onSignOutButton {
    NSLog(@"Logging Out from Parse");
    [PFUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onGuestlistButton:(id)sender {
    if([Event currentEvent].eventPFObject) {
        GuestlistTableViewController *guestlistTableViewController = [[GuestlistTableViewController alloc] init];
        [self.navigationController pushViewController:guestlistTableViewController animated:YES];
    }
}

- (IBAction)onMessageCenterButton:(id)sender {
    MessageCenterViewController *messageCenterViewController = [[MessageCenterViewController alloc] init];
    [self.navigationController pushViewController:messageCenterViewController animated:YES];
}

- (IBAction)onWeddingDetailsButton:(id)sender {
    CreateWeddingViewController *createWeddingViewController = [[CreateWeddingViewController alloc] init];
    [self.navigationController pushViewController:createWeddingViewController animated:YES];
}
@end
