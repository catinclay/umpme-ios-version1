//
//  UMPFriendDetailViewController.h
//  [version1.1]umpme
//
//  Created by catinclay on 3/25/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMPBhvManager.h"
#import "UMPCacheManager.h"
@class UMPInstantMessageViewController;

@interface UMPFriendDetailViewController : UIViewController  <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *friendImageView;
@property (strong, nonatomic) id detailItem;
@property NSString *friendID;


@end
