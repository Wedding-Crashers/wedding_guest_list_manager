//
//  GuestlistTableViewController.h
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/13/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import <Parse/Parse.h>
#import <AddressBookUI/AddressBookUI.h>
#import "FilterViewController.h"

@interface GuestlistTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, FilterViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, ABPeoplePickerNavigationControllerDelegate>

@end
