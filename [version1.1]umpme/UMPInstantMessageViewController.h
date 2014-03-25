//
//  UMPInstantMessageViewController.h
//  [version1.1]umpme
//
//  Created by catinclay on 3/25/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMPBhvManager.h"
#import "UMPCacheManager.h"


@interface UMPInstantMessageViewController : UIViewController <NSStreamDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
- (IBAction)sendMessageAction:(id)sender;
@property (nonatomic) NSString *friendID;

@end
NSInputStream *inputStream;
NSOutputStream *outputStream;
