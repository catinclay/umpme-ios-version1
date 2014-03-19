//
//  UMPLoginViewController.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMPLoginViewController : UIViewController


// Temp Property:
@property (weak, nonatomic) IBOutlet UITextField *uemailTextField;
@property (weak, nonatomic) IBOutlet UITextField *upasswdTextField;
@property (weak, nonatomic) IBOutlet UILabel *autoLoginSwitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginErrorLabel;




// Temp Action:
- (IBAction)loginAction:(id)sender;
- (IBAction)loginvcToSignupvcAction:(id)sender;

- (IBAction)hideKeyBoard:(id)sender;





@end
