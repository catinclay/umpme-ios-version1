//
//  UMPFriendLocationViewController.h
//  [version1.1]umpme
//
//  Created by catinclay on 3/31/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UMPBhvManager.h"
#import "UMPCacheManager.h"

@interface UMPFriendLocationViewController : UIViewController <NSStreamDelegate,MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;
@property (weak, nonatomic) MKUserLocation *myLocation;
@property (nonatomic) NSString *friendID;


- (IBAction)sendLocation:(id)sender;
- (void) setAnnotationlatitude: (double)latitude longitude:(double)longitude subtitle:(NSString *) subtitle;
@end

NSInputStream *inputStream;
NSOutputStream *outputStream;
