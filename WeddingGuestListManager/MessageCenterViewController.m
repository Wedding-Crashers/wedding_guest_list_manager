//
//  MessageCenterViewController.m
//  WeddingGuestListManager
//
//  Created by Sai Kante on 4/14/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "InviteMessageViewController.h"
#import "RequestInfoViewController.h"

@interface MessageCenterViewController ()
- (IBAction)onRequestInfoButton:(id)sender;
- (IBAction)onSaveTheDateButton:(id)sender;
- (IBAction)onSendInviteButton:(id)sender;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRequestInfoButton:(id)sender {
    RequestInfoViewController *requesInfoVc = [[RequestInfoViewController alloc] init];
    [self.navigationController pushViewController:requesInfoVc animated:YES];
}

- (IBAction)onSaveTheDateButton:(id)sender {
    InviteMessageViewController *invMsgVc= [[InviteMessageViewController alloc] init];
    invMsgVc.isInvite = NO;
    [self.navigationController pushViewController:invMsgVc animated:YES];

}

- (IBAction)onSendInviteButton:(id)sender {
    InviteMessageViewController *invMsgVc= [[InviteMessageViewController alloc] init];
    [self.navigationController pushViewController:invMsgVc animated:YES];
}
@end
