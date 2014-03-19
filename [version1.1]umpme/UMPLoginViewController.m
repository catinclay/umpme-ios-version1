//
//  UMPLoginViewController.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLoginViewController.h"

@interface UMPLoginViewController ()

@end

@implementation UMPLoginViewController

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
    // Do any additional setup after loading the view.
    if ([self.initialEmailText length] > 0 && [self.initialPasswdText length] > 0) {
        self.uemailTextField.text = self.initialEmailText;
        self.upasswdTextField.text = self.initialPasswdText;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



// Shut down screen auto rotate.
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}





// Temp Action:
- (IBAction)loginAction:(id)sender {
    [self performSegueWithIdentifier:@"segue_loginvc_to_maintbc" sender:self];
}

- (IBAction)loginvcToSignupvcAction:(id)sender {
    [self performSegueWithIdentifier:@"segue_loginvc_to_signupvc" sender:self];
}

- (IBAction)hideKeyBoard:(id)sender {
    [self.uemailTextField resignFirstResponder];
    [self.upasswdTextField resignFirstResponder];
}




@end
