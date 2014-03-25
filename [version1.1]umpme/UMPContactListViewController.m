//
//  UMPContactList.m
//  [version1.1]umpme
//
//  Created by catinclay on 3/23/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPContactListViewController.h"
#import "UMPFriendDetailViewController.h"

@interface UMPContactListViewController ()

@end

@implementation UMPContactListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
    NSArray *friendsIdsArray = umpCacheManager.umpCurrUser.friendsIdsArray;
    
    return friendsIdsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
    NSArray *friendsIdsArray = umpCacheManager.umpCurrUser.friendsIdsArray;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [friendsIdsArray objectAtIndex: indexPath.row]];
    
    
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    
    
//    NSLog(@"ID is: %@", umpCacheManager.umpCurrUser.currUid);
    cell.imageView.image = [umpApiManager.umpImage
                            downloadSingleImageForUid:[NSString stringWithFormat:@"%@", [friendsIdsArray objectAtIndex: indexPath.row]]
                                 withService:umpCsntManager.umpCsntNetworkManager.umpServiceDownloadSmallProfileImage];
    __block UIImage *tempImage;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
//    dispatch_async(concurrentQueue, ^{
////        NSLog(@"ID is: %@", [NSString stringWithFormat:@"%@", [friendsIdsArray objectAtIndex: indexPath.row]]);
//        tempImage =[umpApiManager.umpImage
//                    downloadSingleImageForUid:[NSString stringWithFormat:@"%@", [friendsIdsArray objectAtIndex: indexPath.row]]
//                    withService : umpCsntManager.umpCsntNetworkManager.umpServiceDownloadSmallProfileImage];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            cell.imageView.image = tempImage;
//            [self.tableView reloadData];
//        });
//    });
    
    
    
    // Configure the cell...
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([[segue identifier] isEqualToString:@"segue_contactlistvc_to_frienddetailvc"]) {
        
        
        UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
        NSArray *friendsIdsArray = umpCacheManager.umpCurrUser.friendsIdsArray;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSObject *object = [NSString stringWithFormat:@"%@", [friendsIdsArray objectAtIndex: indexPath.row]];
        [[segue destinationViewController] setDetailItem:object];
        
//        NSObject *object = (personObject *)self.objects[indexPath.row];
//        [[segue destinationViewController] setDetailItem:object];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
