//
//  UMPInstantMessageViewController.m
//  [version1.1]umpme
//
//  Created by catinclay on 3/25/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPInstantMessageViewController.h"

@interface UMPInstantMessageViewController ()

@end
NSMutableArray * messages;


@implementation UMPInstantMessageViewController


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
//    self.messageTextField.text = self.friendID;
    
    [self initNetworkCommunication];
    
    messages = [[NSMutableArray alloc] init];

    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (IBAction)sendMessageAction:(id)sender {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
    
    NSString *uid = umpCacheManager.umpCurrUser.currUid;
    
    NSString *message  = [NSString stringWithFormat:@"%@", self.messageTextField.text];
    
    
    NSMutableDictionary *insertDataMutableDic = [[NSMutableDictionary alloc] init];
    [insertDataMutableDic setObject:uid forKey:@"uid"];
    [insertDataMutableDic setObject:self.friendID forKey:@"to_friend_id"];
    [insertDataMutableDic setObject:@"message_to" forKey:@"operation"];
    [insertDataMutableDic setObject:message forKey:@"message"];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:insertDataMutableDic
                                                       options:1 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    [outputStream write:[jsonData bytes] maxLength:[jsonData length]];
    self.messageTextField.text = @"";
    
//	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
//	[outputStream write:[data bytes] maxLength:[data length]];
    
}


- (void)initNetworkCommunication {
    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];

    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"184.173.121.49", 27692, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    
    NSString *uid = umpCacheManager.umpCurrUser.currUid;
    NSMutableDictionary *insertDataMutableDic = [[NSMutableDictionary alloc] init];
    [insertDataMutableDic setObject:uid forKey:@"uid"];

    [insertDataMutableDic setObject:@"login_chat" forKey:@"operation"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:insertDataMutableDic
                                                       options:1 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    [outputStream write:[jsonData bytes] maxLength:[jsonData length]];

//    if (! jsonData) {
//        NSLog(@"Got an error: %@", error);
//    } else {
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    }

    
//    [insertDataMutableDic setObject:@"login_chat" forKey:@"message"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];

    static NSString *CellIdentifier = @"ChatCellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    NSDictionary *jsonDic =[messages objectAtIndex:indexPath.row];
    NSString *messageString = [jsonDic objectForKey:@"message"];
    
//    NSLog(@"s = %@", s);
    cell.textLabel.text = messageString;
    if([[jsonDic objectForKey:@"uid"] isEqualToString: umpCacheManager.umpCurrUser.currUid]){
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.textLabel.textColor = umpCsntManager.umpCsntColorManager.umpGreenColor;
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
    }
    
//    cell.textLabel.text = [NSString stringWithFormat:@"%i", indexPath.row];
    
	return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return messages.count;
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
//	NSLog(@"stream event %i", streamEvent);
    switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            [self messageReceived:output];
                        }
                    }
                }
            }
			break;
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
            
		case NSStreamEventEndEncountered:
			break;
            
		default:
			NSLog(@"Unknown event");
	}
}


- (void) messageReceived:(NSString *)message {
    
//	[messages addObject:message];
    NSError *jsonError = nil;
    
//    NSDictionary *JSON =
//    [NSJSONSerialization JSONObjectWithData: [@"{\"2\":\"3\"}" dataUsingEncoding:NSUTF8StringEncoding]
//                                    options: NSJSONReadingMutableContainers
//                                      error: &e];
    NSDictionary *jsonDic = [NSJSONSerialization
                             JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding]
                             options:NSJSONReadingAllowFragments error:&jsonError];
    if (jsonError == nil) {
        
//        [messages insertObject:[NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"message"]] atIndex:0];
        [messages insertObject:jsonDic atIndex:0];

//        NSLog(@"get!!!: %@", [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"message"]]);
    }

	[self.messageTableView reloadData];
    
}

@end
