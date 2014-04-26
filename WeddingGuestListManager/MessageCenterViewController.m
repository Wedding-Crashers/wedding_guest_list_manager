//
//  MessageCenterViewController.m
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/14/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "ComposeMessageViewController.h"

@interface MessageCenterViewController ()
- (IBAction)onRequestInfoButton:(id)sender;
- (IBAction)onSaveTheDateButton:(id)sender;
- (IBAction)onSendInviteButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *requestInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *saveTheDateButton;
@property (weak, nonatomic) IBOutlet UIButton *sendInviteButton;
@property (weak, nonatomic) IBOutlet UIView *requestInfoButtonContainer;
@property (weak, nonatomic) IBOutlet UIView *saveTheDateButtonContainer;
@property (weak, nonatomic) IBOutlet UIView *sendInviteButtonContainer;
@property (weak, nonatomic) IBOutlet UIView *sendPhysicalInviteButtonContainer;

@end

@implementation MessageCenterViewController

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
    self.title = @"Message Center";
    
    self.requestInfoButtonContainer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
    self.saveTheDateButtonContainer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
    self.sendInviteButtonContainer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
    self.sendPhysicalInviteButtonContainer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRequestInfoButton:(id)sender {
    ComposeMessageViewController *requesInfoVc = [[ComposeMessageViewController alloc] initWithType:[NSNumber numberWithInteger:0]];
    [self.navigationController pushViewController:requesInfoVc animated:YES];
}

- (IBAction)onSaveTheDateButton:(id)sender {
    ComposeMessageViewController *invMsgVc= [[ComposeMessageViewController alloc] initWithType:[NSNumber numberWithInteger:1]];
    [self.navigationController pushViewController:invMsgVc animated:YES];

}

- (IBAction)onSendInviteButton:(id)sender {
    ComposeMessageViewController *invMsgVc= [[ComposeMessageViewController alloc] initWithType:[NSNumber numberWithInteger:2]];
    [self.navigationController pushViewController:invMsgVc animated:YES];
}
@end
