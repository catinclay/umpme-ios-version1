//
//  UMPEditPersonalInfoViewController.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/23/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "UMPBhvManager.h"
#import "UMPCacheManager.h"
#import "UMPPersonalPageViewController.h"

@interface UMPEditPersonalInfoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *saveEditedPersonal;
@property (strong, nonatomic) IBOutlet UIImageView *myImage;
- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)choosePhoto:(UIButton *)sender;
- (IBAction)saveEditedPersonal:(id)sender;


@end
