//
//  UMPFriendDetailViewController.m
//  [version1.1]umpme
//
//  Created by catinclay on 3/25/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPFriendDetailViewController.h"
#import "UMPInstantMessageViewController.h"



@interface UMPFriendDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation UMPFriendDetailViewController


- (void) setDetailItem:(id)newNameItem
{
    if (_detailItem != newNameItem) {
        _detailItem = newNameItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}
- (void)configureView
{
    if (self.detailItem) {
        self.friendID = _detailItem;
        UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
        UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];

        __block UIImage *tempImage;
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            tempImage =[umpApiManager.umpImage
                        downloadSingleImageForUid:self.friendID
                        withService : umpCsntManager.umpCsntNetworkManager.umpServiceDownloadSmallProfileImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.friendImageView setImage:tempImage];
            });
        });

//        NSLog(@"DAVID: %@", friendID);
//        self.friendImageView.image =[umpApiManager.umpImage
//                                     downloadSingleImageForUid:[NSString stringWithFormat:@"%@",friendID]
//                                     withService : umpCsntManager.umpCsntNetworkManager.umpServiceDownloadBigProfileImage];
    }
}


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([[segue identifier] isEqualToString:@"segue_frienddetailvc_to_instantmessagevc"]) {
        
        
        UMPInstantMessageViewController *destinationVC = [segue destinationViewController];
        destinationVC.friendID = self.friendID;
        //        [[segue destinationViewController] setDetailItem:object];
        
        //        NSObject *object = (personObject *)self.objects[indexPath.row];
        //        [[segue destinationViewController] setDetailItem:object];
    }
    
    if ([[segue identifier] isEqualToString:@"segue_frienddetailvc_to_friendlocationvc"]) {
        
        
        UMPInstantMessageViewController *destinationVC = [segue destinationViewController];
        destinationVC.friendID = self.friendID;
        //        [[segue destinationViewController] setDetailItem:object];
        
        //        NSObject *object = (personObject *)self.objects[indexPath.row];
        //        [[segue destinationViewController] setDetailItem:object];
    }}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
