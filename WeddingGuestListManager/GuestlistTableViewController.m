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
#include "REMenu.h"
#include "Guest.h"
#include "Event.h"
#import "MBProgressHUD.h"
#import "MenuItemView.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


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
@property (strong, nonatomic) NSMutableArray *waitListBackUp;
@property (strong, nonatomic) NSMutableArray *guestListbackUp;

@property (assign, nonatomic) BOOL isInEditMode;
@property (strong, nonatomic) NSMutableArray *isAnimationDoneForIndexPath;
@property (strong, nonatomic) NSMutableArray *isWaitListAtRowSelected;
@property (strong, nonatomic) NSMutableArray *isGuestListAtRowSelected;
@property (assign,nonatomic) BOOL doCellAnim;
@property (nonatomic,strong) UISearchBar *searchBar;

// NSDictionary with keys as Guest object and value as boolean to check whether a guest is selected
@property (strong, nonatomic) NSMutableArray *selectedGuestsInEditMode;
- (void) fillEditItemOnREMenu:(REMenuItem *)item ;

-(void) showCreateNewGuestPage;

@end

@implementation GuestlistTableViewController{
    UIRefreshControl *refresh;
    MBProgressHUD *progressHUD;
    int numberOfUpdatesToBeCompleted; //used in editing guests. 
}


- (void) viewDidLoad {
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //set our nice background
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImage *bkgImage = [UIImage imageNamed:@"Background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bkgImage];
    
    //set the search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 35.0)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //self.searchBar.barTintColor = [UIColor colorWithRed:255/255.0f green:74/255.0f blue:68/255.0f alpha:1.0f];
    //[[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor blackColor]];
    
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 35.0)];
    searchBarView.autoresizingMask = 0;
    self.searchBar.delegate = self;
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;
    self.searchBar.barTintColor =[UIColor whiteColor];
    self.searchBar.barStyle = UISearchBarStyleProminent;
    self.searchBar.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.searchBar.layer.borderWidth=1.0;
    self.searchBar.layer.cornerRadius = 10.0f;
    
    
    UINib *guestTableViewCellNib = [UINib nibWithNibName:@"GuestlistTableViewCell" bundle:nil];
    [self.tableView registerNib:guestTableViewCellNib forCellReuseIdentifier:@"GuestlistTableViewCell"];
    [self setRightNavigationButtonAsSettings];
    
    self.totalList = [[NSMutableArray alloc] init];
    self.guestList = [[NSMutableArray alloc] init];
    self.waitList = [[NSMutableArray alloc] init];
    self.isGuestListAtRowSelected = [[NSMutableArray alloc] init];
    self.isWaitListAtRowSelected = [[NSMutableArray alloc] init];
    self.selectedGuestsInEditMode = [[NSMutableArray alloc] init];
    self.doCellAnim = NO;
    progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [progressHUD hide:YES];
    
    refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor grayColor];
    //refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;

    
    
    MenuItemView *importItemCustomView =[[[NSBundle mainBundle] loadNibNamed:@"CustomMenuItemView" owner:nil options:nil] firstObject];
   
    importItemCustomView.label.text=@"Import Guests";
    importItemCustomView.image.image = [UIImage imageNamed:@"SettingsButton"];
    
    MenuItemView *addItemCustomView =[[[NSBundle mainBundle] loadNibNamed:@"CustomMenuItemView" owner:nil options:nil] firstObject];
    
    addItemCustomView.label.text=@"Add New Guest";
    addItemCustomView.image.image = [UIImage imageNamed:@"SettingsButton"];
    
    MenuItemView *editItemCustomView =[[[NSBundle mainBundle] loadNibNamed:@"CustomMenuItemView" owner:nil options:nil] firstObject];
    
    editItemCustomView.label.text=@"Edit Guests";
    editItemCustomView.image.image = [UIImage imageNamed:@"SettingsButton"];
    
    MenuItemView *filterItemCustomView =[[[NSBundle mainBundle] loadNibNamed:@"CustomMenuItemView" owner:nil options:nil] firstObject];
    
    filterItemCustomView.label.text=@"Filter Guests";
    filterItemCustomView.image.image = [UIImage imageNamed:@"SettingsButton"];
    [filterItemCustomView.barView setHidden:YES];
    
    REMenuItem *importItem = [[REMenuItem alloc] initWithCustomView:importItemCustomView action:^(REMenuItem *item) {
                                        NSLog(@"Item: %@", item);
                                        NSLog(@"Adding Guest");
                                        ABPeoplePickerNavigationController *pickerNavigationController = [[ABPeoplePickerNavigationController alloc] init];
                                        pickerNavigationController.peoplePickerDelegate = self;
                                        [self presentViewController:pickerNavigationController animated:YES completion:NULL];
                            }];
    
    REMenuItem *addItem = [[REMenuItem alloc] initWithCustomView:addItemCustomView action:^(REMenuItem *item) {
                                                             [self showCreateNewGuestPage];
                                                         }];
    
    REMenuItem *editItem = [[REMenuItem alloc] initWithCustomView:editItemCustomView action:^(REMenuItem *item) {
                                                              [self fillEditItemOnREMenu:item];
                                                          }];
    
    REMenuItem *filterItem = [[REMenuItem alloc] initWithCustomView:filterItemCustomView action:^(REMenuItem *item) {
                                                             [self showFilterPage];
                                                         }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.isInEditMode = NO;

    [self queryForGuestsAndReloadData:YES];
    
    
    self.menu = [[REMenu alloc] initWithItems:@[addItem, importItem, editItem, filterItem]];
    
    //style the REMenu
    self.menu.backgroundColor = [UIColor whiteColor];
    self.menu.backgroundAlpha = 0.5f;
    self.menu.separatorHeight=0.0f;
    self.menu.borderWidth = 0.0f;
    self.menu.itemHeight = 42.0f;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Guests";
    }
    
    [self setRightNavigationButtonAsSettings];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStyleDone target:self action:@selector(onBackButton:)];
    
    return self;
}



- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self queryForGuestsAndReloadData:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.menu.isOpen) {
        [self.menu close];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark member functions


//queries the guests from the parse and saves them locally in this class
- (void)queryForGuestsAndReloadData:(BOOL)isReload {
    PFQuery *guestQuery = [PFQuery queryWithClassName: @"Guest"];
    
    if([Event currentEvent].eventPFObject) {
        [guestQuery whereKey:@"eventId" equalTo:[Event currentEvent].eventPFObject];
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
    if(isReload) {
        [progressHUD show:YES];
    }
    [guestQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            // There was an error, do something with it.
            [progressHUD hide:YES];
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
        if(isReload)
        {
            // Reload your tableView Data
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *settings = [[NSUserDefaults standardUserDefaults] objectForKey:@"filterSettings"];
                if (settings) {
                    [self processFilterSettingsData:settings];
                }
                [self.tableView reloadData];
            });
        }
        
        [progressHUD hide:YES];
    }];

}


//shows the GuestViewController to create a new guest
-(void) showCreateNewGuestPage {
    GuestViewController *guestViewController = [[GuestViewController alloc] init];
    Guest *currentGuest = [[Guest alloc] init];
    PFObject *tempGuestPFObject = [PFObject objectWithClassName:@"Guest"];
    
    // Add ownedBy Relation
    PFRelation *relation = [tempGuestPFObject relationforKey:@"eventId"];
    [relation addObject:[Event currentEvent].eventPFObject];
    [currentGuest initWithObject:tempGuestPFObject];
    guestViewController.currentGuest = currentGuest;
    [self.navigationController pushViewController:guestViewController animated:YES];
}

-(void) showFilterPage {
    [self queryForGuestsAndReloadData:NO];
    FilterViewController *filterViewController = [[FilterViewController alloc] init];
    filterViewController.delegate = self;
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:filterViewController];
    [self presentViewController:navigationViewController animated:YES completion:NULL];
}

//returns a image for selection and de-selection of table rows
- (UIImage*) getImageIsSelected:(BOOL)isSelected {
    if(isSelected)
        return [UIImage imageNamed:@"filled_blue_circle.png"];
    else
        return [UIImage imageNamed:@"unfilled_blue_circle.png"];
}

-(void) hideProgressHudIfNoneSelected {
    //well.. hide the progress hud if none are selected
    if(self.selectedGuestsInEditMode.count == 0) {
        [progressHUD hide:YES];
    }
}

-(void) setRightNavigationButtonAsSettings {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"...." style:UIBarButtonItemStyleDone target:self action:@selector(onAddButton)];
}

-(void) setRightNavigationButtonAsDone {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onDoneEditButton:)];
}

-(void) setRightNavigationButtonAsCancel {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(onCancelSearchButton:)];
}

#pragma mark button selectors

// show the contacts app to pick people
- (void)onAddButton
{
    if (self.menu.isOpen) {
        [self.menu close];
    }
    [self.menu showFromNavigationController:self.navigationController];
}

// when done button is clicked to come out of edit mode
-(IBAction) onBackButton:(id)sender {
   [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) onCancelSearchButton:(id)sender {
    [self.searchBar resignFirstResponder];
    //[self.searchBar setShowsCancelButton:NO animated:YES];
    [self setRightNavigationButtonAsSettings];
    [self setRightNavigationButtonAsSettings];
    self.waitList = self.waitListBackUp ;
    self.guestList = self.guestListbackUp;
    [self.tableView reloadData];
    
}

-(IBAction) onDoneEditButton:(id)sender {
    [self getOutOfEditMode];
    [self.tableView reloadData];
}

-(void) getOutOfEditMode {
    self.isInEditMode = NO;
    self.doCellAnim = NO;
    [self setRightNavigationButtonAsSettings];
    [[self navigationController] setToolbarHidden: YES animated:YES];
}

// move all the selected guests to wait list. if people are in the waitlist, they are still moved atm. (i.e., parse call is made for it)
-(IBAction)onMoveToWaitListButton:(id)sender {
    [progressHUD show:YES];
//    [self.selectedGuestsInEditMode removeAllObjects];
//    for(int i=0; i< self.isGuestListAtRowSelected.count; i++) {
//        if([self.isGuestListAtRowSelected[i] boolValue])
//            [self.selectedGuestsInEditMode addObject:self.guestList[i]];
//    }
//    
//    
//    for(int i=0; i< self.isWaitListAtRowSelected.count; i++) {
//        if([self.isWaitListAtRowSelected[i] boolValue])
//            [self.selectedGuestsInEditMode addObject:self.waitList[i]];
//    }
    numberOfUpdatesToBeCompleted =self.selectedGuestsInEditMode.count;
    for(Guest *guest in self.selectedGuestsInEditMode) {
        [guest moveToWaitListWithResultBlock:^(BOOL succeeded, NSError *error) {
            if(!error) {
                NSLog(@"saved to wait list successfully");
                [HelperMethods checkAndDeleteObject:guest inArray:self.guestList];
                [self.waitList addObject:guest];
            }
            else {
                NSLog(@"parse save to wait list failed with error %@",error);
            }
            numberOfUpdatesToBeCompleted--;
            if(numberOfUpdatesToBeCompleted<=0) {
                [self.selectedGuestsInEditMode removeAllObjects];
                [self queryForGuestsAndReloadData:NO];
                [self setAllGuestsAsNotSelected];
                [self.tableView reloadData];
            }
        }];    }
    [self hideProgressHudIfNoneSelected];
}

-(IBAction)onMoveToGuestListButton:(id)sender {
    [progressHUD show:YES];
//    [self.selectedGuestsInEditMode removeAllObjects];
//    for(int i=0; i< self.isGuestListAtRowSelected.count; i++) {
//        [self.selectedGuestsInEditMode addObject:self.guestList[i]];
//    }
//    
//    
//    for(int i=0; i< self.isWaitListAtRowSelected.count; i++) {
//        [self.selectedGuestsInEditMode addObject:self.waitList[i]];
//    }
//    
    for(Guest *guest in self.selectedGuestsInEditMode) {
        [guest moveToGuestListWithResultBlock:^(BOOL succeeded, NSError *error) {
            if(!error) {
                NSLog(@"saved to guest list successfully");
                [HelperMethods checkAndDeleteObject:guest inArray:self.waitList];
                [self.guestList addObject:guest];
            }
            else {
                NSLog(@"parse save to guest list failed with error %@",error);
            }
            numberOfUpdatesToBeCompleted--;
            if(numberOfUpdatesToBeCompleted<=0) {
                [self.selectedGuestsInEditMode removeAllObjects];
                [self queryForGuestsAndReloadData:NO];
                [self setAllGuestsAsNotSelected];
                [self.tableView reloadData];
            }
        }];
    }
    [self hideProgressHudIfNoneSelected];
}

-(IBAction)onDeleteGuestsButton:(id)sender {
    [progressHUD show:YES];
//    [self.selectedGuestsInEditMode removeAllObjects];
//    for(int i=0; i< self.isGuestListAtRowSelected.count; i++) {
//        [self.selectedGuestsInEditMode addObject:self.guestList[i]];
//    }
//    
//    
//    for(int i=0; i< self.isWaitListAtRowSelected.count; i++) {
//        [self.selectedGuestsInEditMode addObject:self.waitList[i]];
//    }
    
    for(Guest *guest in self.selectedGuestsInEditMode) {
        [guest deleteGuestWithResultBlock:^(BOOL succeeded, NSError *error) {
            if(!error) {
                NSLog(@"deleted successfully");
                [HelperMethods checkAndDeleteObject:guest inArray:self.guestList];
                [HelperMethods checkAndDeleteObject:guest inArray:self.waitList];
                [HelperMethods checkAndDeleteObject:guest inArray:self.totalList];
            }
            else {
                NSLog(@"parse delete failed with error %@",error);
                [progressHUD hide:YES];
            }
            numberOfUpdatesToBeCompleted--;
            if(numberOfUpdatesToBeCompleted<=0) {
                [self.selectedGuestsInEditMode removeAllObjects];
                [self queryForGuestsAndReloadData:NO];
                [self setAllGuestsAsNotSelected];
                [self.tableView reloadData];
            }
        }];
    }
    [self hideProgressHudIfNoneSelected];
    
}

-(void) fillEditItemOnREMenu:(REMenuItem *)item {
    NSLog(@"Item: %@", item);
    self.isInEditMode = YES;
    self.doCellAnim = YES;
    [self setAllGuestsAsNotSelected];
    [self setRightNavigationButtonAsDone];
    [[self navigationController] setToolbarHidden: NO animated:YES];
    UIBarButtonItem* moveToWaitListButton = [[UIBarButtonItem alloc] initWithTitle:@"Move To Waitlist" style:UIBarButtonItemStyleBordered target:self action:@selector(onMoveToWaitListButton:)];
    [HelperMethods SetFontSizeOfButton:moveToWaitListButton];
    UIBarButtonItem* moveToGuestListButton = [[UIBarButtonItem alloc] initWithTitle:@"Move To GuestList" style:UIBarButtonItemStyleBordered target:self action:@selector(onMoveToGuestListButton:)];
    [HelperMethods SetFontSizeOfButton:moveToGuestListButton];
    UIBarButtonItem* deleteGuestsButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(onDeleteGuestsButton:)];
    [HelperMethods SetFontSizeOfButton:deleteGuestsButton];
    [self setToolbarItems:[NSArray arrayWithObjects:moveToWaitListButton,moveToGuestListButton, deleteGuestsButton, nil]];
    
    [self.tableView reloadData];
}


-(void) setAllGuestsAsNotSelected {
    
    [self.isGuestListAtRowSelected removeAllObjects];
    [self.isWaitListAtRowSelected removeAllObjects];
    [self.selectedGuestsInEditMode removeAllObjects];
    for(int i=0; i<self.guestList.count; i++) {
        [self.isGuestListAtRowSelected addObject:[NSNumber numberWithBool:NO]];
    }
    for(int i=0; i<self.waitList.count; i++) {
        [self.isWaitListAtRowSelected addObject:[NSNumber numberWithBool:NO]];
    }
}

#pragma mark UITableViewDelegate and UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GuestlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestlistTableViewCell" forIndexPath:indexPath];
    Guest *currentGuest = [[Guest alloc] init];
    
    if(indexPath.section==0) {
        currentGuest = self.guestList[indexPath.row];
    }
    else{
        currentGuest = self.waitList[indexPath.row];
    }
    
    // Configure the cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.firstNameLabel.text = [[currentGuest firstName] capitalizedString];
    cell.firstNameLabel.text = [cell.firstNameLabel.text stringByAppendingString:@" "];
    cell.firstNameLabel.text = [cell.firstNameLabel.text stringByAppendingString:[[currentGuest lastName] capitalizedString]];
    //cell.lastNameLabel.text = [[currentGuest lastName] capitalizedString];
    cell.rsvpStatusLabel.text = [currentGuest rsvpStatus];
    //cell.contactStatusLabel.text = [currentGuest getMissingContactInfoText];
    cell.contactInfoView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundColor =[UIColor colorWithRed:100 green:100 blue:100 alpha:0.3];
    [cell.firstNameLabel sizeToFit];
    
    CGRect nextImageRect = CGRectMake(cell.firstNameLabel.frame.origin.x +cell.firstNameLabel.frame.size.width +20, cell.firstNameLabel.frame.origin.y, 15, 15);
    [cell.missingAddressImage setHidden:YES];
    [cell.missingPhoneImage setHidden:YES];
    if([currentGuest isMissingAddress]) {
        cell.missingAddressImage.image= [UIImage imageNamed:@"ContactAddress"];
        [cell.missingAddressImage setFrame:nextImageRect];
        [cell.missingAddressImage setHidden:NO];
        nextImageRect = CGRectMake(nextImageRect.origin.x+20, nextImageRect.origin.y, nextImageRect.size.width, nextImageRect.size.height);
    }
    if(currentGuest.isMissingPhone) {
        cell.missingPhoneImage.image = [UIImage imageNamed:@"ContactPhone"];
        [cell.missingPhoneImage setFrame:nextImageRect];
        [cell.missingPhoneImage setHidden:NO];
    }
    
    //cell.profileImage.image = [UIImage imageNamed:@"MissingProfile.png"];
    //[cell.profileImage setImageWithURL:[NSURL URLWithString:@"url"] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    //[cell.profileImage setRoundedCorners];
    
    if(self.isInEditMode) {
        int currentOriginX = cell.contactInfoView.frame.origin.x;
        if(self.doCellAnim) {
            CGRect newFrame = CGRectMake(43,cell.contactInfoView.frame.origin.y,cell.contactInfoView.frame.size.width,cell.contactInfoView.frame.size.height);
            [UIView animateWithDuration:0.3
                             animations:^{
                                 cell.contactInfoView.frame = newFrame;
                             } completion:^(BOOL finished) {
                                 self.doCellAnim = NO;
                                 cell.contactInfoView.frame = newFrame;
                             }];
        }
        else if(currentOriginX!=43){
            //if the cell is not animated yet. instantly move it.
            CGRect newFrame = CGRectMake(43,cell.contactInfoView.frame.origin.y,cell.contactInfoView.frame.size.width,cell.contactInfoView.frame.size.height);
            cell.contactInfoView.frame = newFrame;
            [cell.contactInfoView setNeedsDisplay];
            self.doCellAnim = NO;
        }
        
        [cell.selectionImage setHidden:NO];
//        if(indexPath.section==0) {
//            cell.selectionImage.image = [self getImageIsSelected:[ self.isGuestListAtRowSelected[indexPath.row] boolValue]];
//        }
//        else{
//            cell.selectionImage.image = [self getImageIsSelected:[ self.isWaitListAtRowSelected[indexPath.row] boolValue]];
//        }
        //if(indexPath.section==0) {
            cell.selectionImage.image = [self getImageIsSelected:[self.selectedGuestsInEditMode containsObject:currentGuest]];
        //}
        //else{
        //    cell.selectionImage.image = [self getImageIsSelected:[ self.isWaitListAtRowSelected[indexPath.row] boolValue]];
        //}

    }
    else {
        [cell.selectionImage setHidden:YES];
        int currentOriginX = cell.contactInfoView.frame.origin.x;
        if(currentOriginX!=0) {
            
            CGRect newFrame = CGRectMake(0,cell.contactInfoView.frame.origin.y,cell.contactInfoView.frame.size.width,cell.contactInfoView.frame.size.height);
            [UIView animateWithDuration:0.5
                             animations:^{
                                 cell.contactInfoView.frame = newFrame;
                             }];
        }
        
    }
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    UILabel  *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
    title.numberOfLines=0;
    title.lineBreakMode=NSLineBreakByCharWrapping;
    title.backgroundColor = [UIColor clearColor];
    //title.textAlignment = NSTextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    title.textColor=[UIColor whiteColor];
    title.text = (section==0) ? @"Guest List" : @"Waitlist";
    [customView addSubview:title];
    return customView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isInEditMode) {
//        if(indexPath.section==0) {
//            self.isGuestListAtRowSelected[indexPath.row] = [NSNumber numberWithBool:![self.isGuestListAtRowSelected[indexPath.row] boolValue]];
//            [self.selectedGuestsInEditMode addObject:self.guestList[indexPath.row]];
//            // [self.selectedGuestsInEditMode setObject:self.isGuestListAtRowSelected[indexPath.row] forKey:self.guestList[indexPath.row]];
//        }
//        else{
//            self.isWaitListAtRowSelected[indexPath.row] = [NSNumber numberWithBool:![self.isWaitListAtRowSelected[indexPath.row] boolValue]];
//            //            [self.selectedGuestsInEditMode setObject:self.isWaitListAtRowSelected[indexPath.row] forKey:self.waitList[indexPath.row]];
//            [self.selectedGuestsInEditMode addObject:self.waitList[indexPath.row]];
//        }
        if(indexPath.section==0) {
            if([self.selectedGuestsInEditMode containsObject:self.guestList[indexPath.row]]) {
                [self.selectedGuestsInEditMode removeObject:self.guestList[indexPath.row]];
            }
            else
                [self.selectedGuestsInEditMode addObject:self.guestList[indexPath.row]];
        }
        else{
            if([self.selectedGuestsInEditMode containsObject:self.waitList[indexPath.row]]) {
                [self.selectedGuestsInEditMode removeObject:self.waitList[indexPath.row]];
            }
            else
                [self.selectedGuestsInEditMode addObject:self.waitList[indexPath.row]];
        }
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else {
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
    
}

#pragma mark importing from contacts app


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


#pragma mark FilterViewDelegate


-(void)processFilterSettingsData:(NSDictionary *)data {
    NSMutableArray *newGuestlist = [[NSMutableArray alloc] init];
    
    if([data[@"invitelistSwitch"] intValue] == 1) {
        for (Guest *guest in self.guestList) {
            if([data[@"awaitingResponseSwitch"] intValue] == 1 && [guest encodedInvitedStatus] == 1 && [guest encodedRsvpStatus] == 0) {
                if([data[@"emailSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.email] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"emailSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.email] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"phoneSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.phoneNumber] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"phoneSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.phoneNumber] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"addressSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.addressLineOne] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"addressSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.addressLineOne] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
            }
            else if ([data[@"attendingSwitch"] intValue] == 1 && [guest encodedInvitedStatus] == 1 && [guest encodedRsvpStatus] == 1) {
                if([data[@"emailSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.email] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"emailSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.email] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"phoneSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.phoneNumber] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"phoneSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.phoneNumber] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"addressSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.addressLineOne] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"addressSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.addressLineOne] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
            }
            else if ([data[@"declinedSwitch"] intValue] == 1 && [guest encodedInvitedStatus] == 1 && [guest encodedRsvpStatus] == 2) {
                if([data[@"emailSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.email] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"emailSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.email] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"phoneSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.phoneNumber] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"phoneSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.phoneNumber] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"addressSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.addressLineOne] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"addressSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.addressLineOne] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
            }
            else if ([data[@"notInvitedSwitch"] intValue] == 1 && [guest encodedInvitedStatus] == 0) {
                if([data[@"emailSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.email] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"emailSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.email] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"phoneSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.phoneNumber] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"phoneSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.phoneNumber] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"addressSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.addressLineOne] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
                else if([data[@"addressSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.addressLineOne] isEqualToString:@""]) {
                    [newGuestlist addObject:guest];
                }
            }
        }
    }
    
    NSMutableArray *newWaitlist = [[NSMutableArray alloc] init];
    
    if([data[@"waitlistSwitch"] intValue] == 1) {
        for (Guest *guest in self.waitList) {
            if([data[@"notInvitedSwitch"] intValue] == 1 && [guest encodedInvitedStatus] == 0) {
                if([data[@"emailSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.email] isEqualToString:@""]) {
                    [newWaitlist addObject:guest];
                }
                else if([data[@"emailSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.email] isEqualToString:@""]) {
                    [newWaitlist addObject:guest];
                }
                else if([data[@"phoneSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.phoneNumber] isEqualToString:@""]) {
                    [newWaitlist addObject:guest];
                }
                else if([data[@"phoneSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.phoneNumber] isEqualToString:@""]) {
                    [newWaitlist addObject:guest];
                }
                else if([data[@"addressSwitch"] intValue] == 1 && ![[HelperMethods ModifyToBlankTextForObject:guest.addressLineOne] isEqualToString:@""]) {
                    [newWaitlist addObject:guest];
                }
                else if([data[@"addressSwitch"] intValue] == 0 && [[HelperMethods ModifyToBlankTextForObject:guest.addressLineOne] isEqualToString:@""]) {
                    [newWaitlist addObject:guest];
                }
            }
        }
    }
    self.guestList = newGuestlist;
    self.waitList = newWaitlist;
}


#pragma mark pull to refresh methods

-(void)refreshView:(UIRefreshControl *)refreshC {
    
    refreshC.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self queryForGuestsAndReloadData:YES];
    [refreshC endRefreshing];
    
}

#pragma mark search bar methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
    if(searchBar.text.length>0) {
        //[self searchYelpWithString:searchBar.text];
        NSLog(@"search with text: %@",searchBar.text);
        [self filterListsForSearchText:searchBar.text scope:nil];
    }
//    [self setRightNavigationButtonAsSettings];
//    [self.tableView reloadData];
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //[searchBar setShowsCancelButton:YES animated:YES];
    
    //stop the recurring searches
    if(searchBar.text.length == 0) {
        self.waitListBackUp = [[NSMutableArray alloc] init];
        self.guestListbackUp = [[NSMutableArray alloc] init];
        self.waitListBackUp = self.waitList;
        self.guestListbackUp = self.guestList;
    }
    [self setRightNavigationButtonAsCancel];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self setRightNavigationButtonAsSettings];
    self.waitList = self.waitListBackUp ;
    self.guestList = self.guestListbackUp;
    [self.tableView reloadData];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length != 0)
    {
        [self filterListsForSearchText:text scope:nil];
    }
}

#pragma mark Filtering
-(void)filterListsForSearchText:(NSString*)searchText scope:(NSString*)scope {
   
    NSMutableArray *tempGuestList =  [[NSMutableArray alloc] init];
    NSMutableArray *tempWaitList =  [[NSMutableArray alloc] init];
    tempGuestList = self.guestListbackUp;
    tempWaitList = self.waitListBackUp;
    
    // Filter the lists
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstName contains[c] %@ OR SELF.lastName contains[c] %@",searchText,searchText];
    self.guestList = [NSMutableArray arrayWithArray:[tempGuestList filteredArrayUsingPredicate:predicate]];
    self.waitList = [NSMutableArray arrayWithArray:[tempWaitList filteredArrayUsingPredicate:predicate]];
    NSLog(@" search results for guestList: %lu : ",(unsigned long)self.guestList.count);
//    for(Guest *guest in self.guestList) {
//        NSLog(@"%@ %@",guest.firstName,guest.lastName);
//    }
//    NSLog(@" search results for waitList: %d : ",self.waitList.count);
//    for(Guest *guest in self.waitList) {
//        NSLog(@"%@ %@",guest.firstName,guest.lastName);
//    }
    [self.tableView reloadData];
}

@end
