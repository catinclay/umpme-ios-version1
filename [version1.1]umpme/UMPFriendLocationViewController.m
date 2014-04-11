//
//  UMPFriendLocationViewController.m
//  [version1.1]umpme
//
//  Created by catinclay on 3/31/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPFriendLocationViewController.h"

@interface UMPFriendLocationViewController ()

@end

@implementation UMPFriendLocationViewController

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
    [self initNetworkCommunication];

    self.mapView.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [self.mapView setShowsUserLocation:YES];
    
    
}

- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    CLLocationCoordinate2D userCoordinate = userLocation.location.coordinate;
//    CLLocationCoordinate2D newCoord = {userLocation.coordinate.latitude+5, userLocation.coordinate.longitude+5};
//    UMPMapPoint *mp = [[UMPMapPoint alloc] initWithCoordinate:newCoord];
//    [mv addAnnotation:mp];
     _myLocation = userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.myLocation.coordinate ,250,250);
    [self.mapView setRegion:region animated:YES];
 
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
                            [self locationReceived:output];
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
- (void) locationReceived:(NSString *)message {
    NSError *jsonError = nil;
    NSDictionary *jsonDic = [NSJSONSerialization
                             JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding]
                             options:NSJSONReadingAllowFragments error:&jsonError];
    
    if (jsonError == nil) {
        
        //        [messages insertObject:[NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"message"]] atIndex:0];
        NSString *operation = [jsonDic objectForKey:@"operation"];
        if([operation isEqualToString:[NSString stringWithFormat:@"location_to"]]){
            NSString *latitude = [jsonDic objectForKey:@"latitude"];
            NSString *longitude = [jsonDic objectForKey:@"longitude"];
            NSString *friendID = [jsonDic objectForKey:@"to_friend_id"];
            [self setAnnotationlatitude:latitude.doubleValue longitude:longitude.doubleValue subtitle:friendID];
        }
        //        NSLog(@"get!!!: %@", [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"message"]]);
    }
    
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
//    MKAnnotationView *annotationView = [views objectAtIndex:0];
//    id<MKAnnotation> mp = [annotationView annotation];
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate] ,250,250);
//    [mv setRegion:region animated:YES];
}

- (IBAction)sendLocation:(id)sender {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
    
    NSString *uid = umpCacheManager.umpCurrUser.currUid;
    
    
    NSMutableDictionary *insertDataMutableDic = [[NSMutableDictionary alloc] init];
    [insertDataMutableDic setObject:uid forKey:@"uid"];
//    [insertDataMutableDic setObject:uid forKey:@"to_friend_id"];
    [insertDataMutableDic setObject:self.friendID forKey:@"to_friend_id"];
    [insertDataMutableDic setObject:@"location_to" forKey:@"operation"];
    [insertDataMutableDic setObject:[NSString stringWithFormat:@"%f",self.myLocation.coordinate.latitude]  forKey:@"latitude"];
    [insertDataMutableDic setObject:[NSString stringWithFormat:@"%f",self.myLocation.coordinate.longitude]  forKey:@"longitude"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:insertDataMutableDic
                                                       options:1 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    [outputStream write:[jsonData bytes] maxLength:[jsonData length]];
}

- (void)setAnnotationlatitude:(double)latitude longitude:(double)longitude subtitle:(NSString *)subtitle{
    CLLocationCoordinate2D newCoord = {latitude,longitude};
    MKPointAnnotation *mp = [[MKPointAnnotation alloc] init];
    mp.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    mp.title = @"Friend!";
    mp.subtitle = subtitle;
    [self.mapView addAnnotation:mp];
    MKCoordinateSpan span = {1,1};
//    MKCoordinateRegion region = {newCoord, span};
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newCoord ,250,250);

    [self.mapView setRegion:region];
}


-(void) viewWillDisappear:(BOOL)animated {
    NSMutableDictionary *insertDataMutableDic = [[NSMutableDictionary alloc] init];
    [insertDataMutableDic setObject:@"logout_chat" forKey:@"operation"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:insertDataMutableDic
                                                       options:1 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    [outputStream write:[jsonData bytes] maxLength:[jsonData length]];
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
    
}
@end
