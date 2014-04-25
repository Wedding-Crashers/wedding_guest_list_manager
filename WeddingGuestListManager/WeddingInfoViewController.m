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
    
    // Set Background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    
    // Create Guest List Button and View
    UIView *guestlistView = [[UIView alloc] initWithFrame:CGRectMake(10, 460, 300, 45)];
    guestlistView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
    
    UIButton *guestlistButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [guestlistButton addTarget:self
                        action:@selector(onGuestlistButton:)
              forControlEvents:UIControlEventTouchUpInside];
    [guestlistButton setTitle:@"Guest List" forState:UIControlStateNormal];
    guestlistButton.frame = CGRectMake(0.0, 0.0, 300, 45.0);
    [guestlistView addSubview:guestlistButton];
    [self.view addSubview:guestlistView];

    
    // Create Message Center Button and View
    UIView *messageCenterView = [[UIView alloc] initWithFrame:CGRectMake(10, 400, 300, 45)];
    messageCenterView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
    
    
    UIButton *messageCenterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageCenterButton addTarget:self
                        action:@selector(onMessageCenterButton:)
              forControlEvents:UIControlEventTouchUpInside];
    [messageCenterButton setTitle:@"Message Center" forState:UIControlStateNormal];
    messageCenterButton.frame = CGRectMake(0.0, 0.0, 300, 45.0);
    
    [messageCenterView addSubview:messageCenterButton];
    [self.view addSubview:messageCenterView];

    
    // Configure the Navigation Bar
    self.navigationItem.title = @"Wedding Details";
    
    

    
    
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditButton)];
    self.navigationItem.rightBarButtonItem = signOutButton;
    self.navigationItem.leftBarButtonItem = editButton;
    
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
    [guestsQuery whereKey:@"eventId" equalTo:[Event currentEvent].eventPFObject];

    [guestsQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        NSNumber *attendingCount = [NSNumber numberWithInt:0];
        NSNumber *decliningCount = [NSNumber numberWithInt:0];
        NSNumber *awaitingCount  = [NSNumber numberWithInt:0];
        
        for(PFObject *guest in results) {
            if([guest[@"invitedStatus"] intValue] == GUEST_INVITED) {
                if([guest[@"rsvpStatus"] intValue] == GUEST_NOT_RSVPED) {
                    awaitingCount = [NSNumber numberWithInt:[awaitingCount intValue] + 1 + [guest[@"extraGuests"] intValue]];
                }
                else if([guest[@"rsvpStatus"] intValue] == GUEST_RSVPED) {
                    attendingCount = [NSNumber numberWithInt:[attendingCount intValue] + 1 + [guest[@"extraGuests"] intValue]];
                }
                else if([guest[@"rsvpStatus"] intValue] == GUEST_DECLINED) {
                    decliningCount = [NSNumber numberWithInt:[decliningCount intValue] + 1 + [guest[@"extraGuests"] intValue]];
                }
            }
        }
        self.attendingLabel.text = [NSString stringWithFormat:@"%@", attendingCount];
        self.declinedLabel.text = [NSString stringWithFormat:@"%@", decliningCount];
        
    }];
}

-(void)onSignOutButton {
    NSLog(@"Logging Out from Parse");
    [PFUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

- (void)onEditButton {
    CreateWeddingViewController *createWeddingViewController = [[CreateWeddingViewController alloc] initForEditing:YES];
    [self.navigationController pushViewController:createWeddingViewController animated:YES];
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

@end
