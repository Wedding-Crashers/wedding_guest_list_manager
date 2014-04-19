//
//  GuestlistTableViewController.m
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/13/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "GuestlistTableViewController.h"
#import "GuestlistTableViewCell.h"

@interface GuestlistTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GuestlistTableViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    UINib *guestTableViewCellNib = [UINib nibWithNibName:@"GuestlistTableViewCell" bundle:nil];
    [self.tableView registerNib:guestTableViewCellNib forCellReuseIdentifier:@"GuestlistTableViewCell"];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Guest";
        
        // The key of the PFObject to display in the label of the default cell style
//        self.textKey = @"firstName";
        
        // The title for this table in the Navigation Controller.
        self.title = @"Guests";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 20;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(onAddButton)];
    
    return self;
}

- (PFQuery *)queryForTable {
    
    PFQuery *guestQuery = [PFQuery queryWithClassName:self.parseClassName];
    
    if(self.eventObject) {
        [guestQuery whereKey:@"eventId" equalTo:self.eventObject];
    }
    else {
        NSLog(@"ERROR: GuestlistTableViewController:  please set an eventID so that we can retrieve the guest list");
    }
    
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        guestQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [guestQuery orderByDescending:@"firstName"];
    
    return guestQuery;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    GuestlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestlistTableViewCell" forIndexPath:indexPath];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
//        
//        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@: %@", [object objectForKey:@"firstName"], [object objectForKey:@"lastName"], [object objectForKey:@"email"]];
//        cell.detailTextLabel.text = [object objectForKey:@"phoneNumber"];
//    }
    
    // Configure the cell
    cell.firstNameLabel.text = [object objectForKey:@"firstName"];
    cell.lastNameLabel.text = [object objectForKey:@"lastName"];
//    cell.rsvpStatusLabel.text = [object objectForKey:@"rsvpStatus"];
    cell.contactStatusLabel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"addressOne"]];
    
    
    return cell;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

// Used to move table view down
//    CGRect frame = self.tableView.frame;
//    frame.origin.y += 100.0;
//    frame.size.height -= 100.0;
//    self.tableView.frame = frame;
    
}


- (void)onAddButton
{
    NSLog(@"Adding Guest");
    ABPeoplePickerNavigationController *pickerNavigationController = [[ABPeoplePickerNavigationController alloc] init];
    pickerNavigationController.peoplePickerDelegate = self;
    
    [self presentViewController:pickerNavigationController animated:YES completion:NULL];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
