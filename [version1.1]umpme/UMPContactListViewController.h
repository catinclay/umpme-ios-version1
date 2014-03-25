//
//  UMPContactList.h
//  [version1.1]umpme
//
//  Created by catinclay on 3/23/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMPBhvManager.h"
#import "UMPCacheManager.h"
@class UMPFriendDetailViewController;

@interface UMPContactListViewController: UITableViewController
@property (strong, nonatomic) UMPFriendDetailViewController *UMPFriendDetailViewController;

@end
