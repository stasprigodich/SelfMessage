//
//  SMChatLocationTableViewCell.m
//  self-message
//
//  Created by Stanislav Prigodich on 06/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMChatLocationTableViewCell.h"
#import <MapKit/MapKit.h>

@interface SMChatLocationTableViewCell()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SMChatLocationTableViewCell

- (void)configureWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(latitude, longitude), 5000, 5000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    [self.mapView setUserInteractionEnabled:NO];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    [annotation setTitle:NSLocalizedString(@"Моё местонахождение", nil)];
    [self.mapView addAnnotation:annotation];
}

@end
