//
//  GuestlistTableViewController.m
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/13/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "GuestlistTableViewController.h"
#import "GuestlistTableViewCell.h"
#import "GuestViewController.h"
#import "FilterViewController.h"
#include "REMenu.h"
#include "Guest.h"

@implementation UIImageView (setRoundedCorners)
-(void) setRoundedCorners {
    self.layer.cornerRadius = 9.0;
    self.layer.masksToBounds = YES;
}
@end

@interface GuestlistTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, readwrite, nonatomic) REMenu *menu;
@property (strong, nonatomic) NSMutableArray *totalList; //not sure if this is needed. but in case
@property (strong, nonatomic) NSMutableArray *guestList;
@property (strong, nonatomic) NSMutableArray *waitList;

-(void) showCreateNewGuestPage;

@end

@implementation GuestlistTableViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    UINib *guestTableViewCellNib = [UINib nibWithNibName:@"GuestlistTableViewCell" bundle:nil];
    [self.tableView registerNib:guestTableViewCellNib forCellReuseIdentifier:@"GuestlistTableViewCell"];
    
    REMenuItem *importItem = [[REMenuItem alloc] initWithTitle:@"Import Guest"
                                                    subtitle:@"From Contacts"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                          NSLog(@"Adding Guest");
                                                          ABPeoplePickerNavigationController *pickerNavigationController = [[ABPeoplePickerNavigationController alloc] init];
                                                          pickerNavigationController.peoplePickerDelegate = self;
                                                          [self presentViewController:pickerNavigationController animated:YES completion:NULL];
                                                      }];
    
    REMenuItem *addItem = [[REMenuItem alloc] initWithTitle:@"Add Guest"
                                                       subtitle:@"Add Details Manually"
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self showCreateNewGuestPage];
                                                         }];
    
    REMenuItem *editItem = [[REMenuItem alloc] initWithTitle:@"Edit Guest List"
                                                        subtitle:@"Toggle Guests from Invite List to Wait List"
                                                           image:[UIImage imageNamed:@"Icon_Activity"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                          }];
    
    REMenuItem *filterItem = [[REMenuItem alloc] initWithTitle:@"Filter Guests"
                                                       subtitle:@"Filter by RSVP and Contact Completeness"
                                                          image:[UIImage imageNamed:@"Icon_Profile"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             NSLog(@"Going to Filter");
                                                             FilterViewController *filterViewController = [[FilterViewController alloc] init];
                                                             UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:filterViewController];
                                                             [self presentViewController:navigationViewController animated:YES completion:NULL];
                                                         }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.totalList = [[NSMutableArray alloc] init];
    self.guestList = [[NSMutableArray alloc] init];
    self.waitList = [[NSMutableArray alloc] init];
    
    [self queryForGuests];
    
    self.menu = [[REMenu alloc] initWithItems:@[importItem, addItem, editItem, filterItem]];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        //self.parseClassName = @"Guest";
        
        // The key of the PFObject to display in the label of the default cell style
//        self.textKey = @"firstName";
        
        // The title for this table in the Navigation Controller.
        self.title = @"Guests";
        
        // Whether the built-in pull-to-refresh is enabled
        //self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        //self.paginationEnabled = YES;
        
        // The number of objects to show per page
        //self.objectsPerPage = 20;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:self action:@selector(onAddButton)];
    
    return self;
}

- (void)queryForGuests {
    
    PFQuery *guestQuery = [PFQuery queryWithClassName: @"Guest"];
    
    if(self.eventObject) {
        [guestQuery whereKey:@"eventId" equalTo:self.eventObject];
    }
    else {
        NSLog(@"ERROR: GuestlistTableViewController:  please set an eventID so that we can retrieve the guest list");
    }
    
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.totalList.count == 0) {
        guestQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [guestQuery orderByDescending:@"firstName"];
        
    [guestQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            // There was an error, do something with it.
        }
        else {
            [self.totalList removeAllObjects];
            [self.guestList removeAllObjects];
            [self.waitList removeAllObjects];
            for(id object in objects) {
                Guest *newGuest = [[Guest alloc] init];
                [newGuest initWithObject:object];
                [self.totalList addObject:newGuest];
            }
            for(Guest *guestObj in self.totalList) {
                if(guestObj.encodedGuestType == GUEST_TYPE_INVITE_LIST )
                    [self.guestList addObject:guestObj];
                else
                    [self.waitList addObject:guestObj];
            }

        }
        // Reload your tableView Data
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        }); 
    }];

}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GuestlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestlistTableViewCell" forIndexPath:indexPath];
    Guest *currentGuest = [[Guest alloc] init];
    
    if(indexPath.section==0) {
        currentGuest = self.guestList[indexPath.row];
    }
    else{
        currentGuest = self.waitList[indexPath.row];
    }
//    if(self.totalList.count > indexPath.row && self.objects[indexPath.row]) {
//        [currentGuest initWithObject:self.objects[indexPath.row]];
//    }
    
    // Configure the cell
    cell.firstNameLabel.text = [currentGuest firstName];
    cell.lastNameLabel.text = [currentGuest lastName];
    cell.rsvpStatusLabel.text = [currentGuest rsvpStatus];
    cell.contactStatusLabel.text = [currentGuest getMissingContactInfoText];
    
    cell.profileImage.image = [UIImage imageNamed:@"MissingProfile.png"];
    //[cell.profileImage setImageWithURL:[NSURL URLWithString:@"url"] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    [cell.profileImage setRoundedCorners];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GUEST_LIST_TABLE_CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section==0) ? self.guestList.count: self.waitList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section==0) ? @"Guest List" : @"Waitlist";
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self queryForGuests];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.menu.isOpen) {
       [self.menu close];
    }
    [super viewWillDisappear:animated];
}

- (void)onAddButton
{
    if (self.menu.isOpen) {
        [self.menu close];
    }
    [self.menu showFromNavigationController:self.navigationController];
}

- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    // Create a guest from Address Book
    PFObject *newGuest = [PFObject objectWithClassName:@"Guest"];
    
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
//    self.firstNameLabel.text = firstName;
    if (firstName) {
        newGuest[@"firstName"]   = firstName;
    }
    
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
//    self.lastNameLabel.text = lastName;
    if (lastName) {
        newGuest[@"lastName"]   = lastName;
    }
    
    ABMultiValueRef emailMultiValue = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSArray *emailAddresses = (__bridge_transfer NSArray*)ABMultiValueCopyArrayOfAllValues(emailMultiValue);
//    self.emailAddressLabel.text = emailAddresses[0];
    if (emailAddresses[0]) {
        newGuest[@"email"] = emailAddresses[0];
    }
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
//    self.phoneNumberLabel.text = phone;
    if (phone) {
        newGuest[@"phoneNumber"] = phone;
    }
    CFRelease(phoneNumbers);
    
    // Add ownedBy Relation
    PFRelation *relation = [newGuest relationforKey:@"eventId"];
    
    // Find event owned by current user
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"ownedBy" equalTo: [PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error && objects && objects.count > 0){
            // Add Event to relation
            [relation addObject:objects[0]];
            
            // Save to Parse
            [newGuest  saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Saved Guest: %@ %@ to Parse", firstName, lastName);
            }];
            
        } else if (error)  {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Can't find event properly. It's probably your fault");
        }
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuestViewController *guestViewController = [[GuestViewController alloc] init];
    Guest *currentGuest = [[Guest alloc] init];
    if(indexPath.section==0) {
        currentGuest = self.guestList[indexPath.row];
    }
    else{
        currentGuest = self.waitList[indexPath.row];
    }
    //[currentGuest initWithObject:self.objects[indexPath.row]];
    guestViewController.currentGuest = currentGuest;
    [self.navigationController pushViewController:guestViewController animated:YES];
    
}

//shows the GuestViewController to create a new guest
-(void) showCreateNewGuestPage {
    GuestViewController *guestViewController = [[GuestViewController alloc] init];
    Guest *currentGuest = [[Guest alloc] init];
    PFObject *tempGuestPFObject = [PFObject objectWithClassName:@"Guest"];
    
    // Add ownedBy Relation
    PFRelation *relation = [tempGuestPFObject relationforKey:@"eventId"];
    [relation addObject:self.eventObject];
    [currentGuest initWithObject:tempGuestPFObject];
    guestViewController.currentGuest = currentGuest;
    [self.navigationController pushViewController:guestViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
