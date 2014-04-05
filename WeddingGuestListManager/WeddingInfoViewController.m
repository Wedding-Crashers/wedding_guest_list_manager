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
- (IBAction)titleTextChanged:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *save_btn;
@property (weak,nonatomic) NSString *currentTitle;

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
    // Do any additional setup after loading the view from its nib.
    //[self.navigationItem.leftBarButtonItem initWithTitle:@"back" style:UIBarButtonItemStylePlain    target:self action:@selector(onBackButtonClicked:)];
    self.currentTitle= self.title_tf.text;
    self.title_tf.delegate = self;
    PFQuery *query= [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"ownedBy" equalTo: [PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error && objects && objects.count > 0) {
            self.title_tf.text = [objects[0] objectForKey:@"title"];
        }
    }];
    
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
