//
//  UMPPersonalPageViewController.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMPBhvManager.h"

@interface UMPPersonalPageViewController : UIViewController




// Temp image test:
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;

- (IBAction)clearImagesAction:(id)sender;

- (IBAction)uploadImageAction:(id)sender;
- (IBAction)downloadBothAction:(id)sender;
- (IBAction)downloadBigAction:(id)sender;
- (IBAction)downloadSmallAction:(id)sender;
- (IBAction)getFriendsIdsAction:(id)sender;






// Temp Action:
- (IBAction)signoutAction:(id)sender;



@end
