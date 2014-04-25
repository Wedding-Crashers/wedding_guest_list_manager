//
//  AppDelegate.m
//  WeddingGuestListManager
//
//  Created by David Ladowitz on 4/1/14.
//  Copyright (c) 2014 Team1. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "WeddingInfoViewController.h"
#import "Event.h"

@interface AppDelegate ()

@property (nonatomic, strong) CustomParseLoginViewController *loginViewController;
@property (nonatomic, strong) CustomParseSignupViewController *signupViewController;
@property (nonatomic, strong) WeddingInfoViewController *weddingViewController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UIViewController *currentViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [Parse setApplicationId:@"A9immhDAgoCW3hcURp1sRO3iL3cEZOM7mb7bsRP6"
                  clientKey:@"aMUgPLCmGnDw2vCu8lA7eEjDjzT0GT3TGK5jLsmq"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootViewController) name:UserDidLogoutNotification object:nil];
    
    // Customize the title text for *all* UINavigationBars
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:self.currentViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)updateRootViewController {
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ [self.window setRootViewController:self.currentViewController]; }
                    completion:nil];;
}

- (UIViewController *)currentViewController {
    if (![PFUser currentUser]) {
        if (!self.loginViewController) {
            self.loginViewController = [[CustomParseLoginViewController alloc] init];
        }
        if (!self.signupViewController) {
            self.signupViewController = [[CustomParseSignupViewController alloc] init];
        }
        [self.loginViewController setDelegate:(id<PFLogInViewControllerDelegate>)self];
        [self.signupViewController setDelegate:(id<PFSignUpViewControllerDelegate>)self];
        [self.loginViewController setSignUpController:self.signupViewController];
        
        return self.loginViewController;
    }
    else {        
        if (!self.weddingViewController) {
            self.weddingViewController = [[WeddingInfoViewController alloc] init];
        }
        if (!self.navigationController) {
            self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.weddingViewController];
            self.navigationController.navigationBar.tintColor = [UIColor grayColor];
            self.navigationController.navigationBar.translucent = YES;
        }
        return self.navigationController;
    }
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self clearFields];
    [self updateRootViewController];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self clearFields];
    [self updateRootViewController];
}

- (void)clearFields {
    self.loginViewController.logInView.usernameField.text = @"";
    self.signupViewController.signUpView.usernameField.text = @"";
    self.loginViewController.logInView.passwordField.text = @"";
    self.signupViewController.signUpView.passwordField.text = @"";
}

@end
