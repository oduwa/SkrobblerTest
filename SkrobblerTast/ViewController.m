//
//  ViewController.m
//  SkrobblerTast
//
//  Created by Odie Edo-Osagie on 02/09/2016.
//  Copyright © 2016 Odie Edo-Osagie. All rights reserved.
//

#import "ViewController.h"
#import <SKMaps/SKMaps.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKMapView *mapView = [[SKMapView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f,  CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) )];
    [self.view addSubview:mapView];
    
    mapView.settings.rotationEnabled = false;
    mapView.settings.followUserPosition = false;
    mapView.settings.headingMode = SKHeadingModeRotatingMap;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.settings.showCompass = false;
    mapView.settings.showCurrentPosition = true;
    mapView.mapScaleView.hidden = false;
    mapView.translatesAutoresizingMaskIntoConstraints = false;
    
    [SKRoutingService sharedInstance].routingDelegate = self; // set for receiving routing callbacks
    [SKRoutingService sharedInstance].navigationDelegate = self;// set for receiving navigation callbacks
    [SKRoutingService sharedInstance].mapView = mapView; // use the map view for route rendering
    
    SKRouteSettings* route = [[SKRouteSettings alloc]init];
    route.startCoordinate=CLLocationCoordinate2DMake(37.447692, -122.166016);
    route.destinationCoordinate=CLLocationCoordinate2DMake(37.437964, -122.141147);
    
    [[SKRoutingService sharedInstance] calculateRoute:route];
}

//- (void)routingService:(SKRoutingService *)routingService didFinishRouteCalculationWithInfo:(SKRouteInformation*)routeInformation{
//    NSLog(@"Route is calculated.");
//    [routingService zoomToRouteWithInsets:UIEdgeInsetsZero duration:1]; // zoom to current route
//}
//- (void)routingServiceDidFailRouteCalculation:(SKRoutingService *)routingService{
//    NSLog(@"Route calculation failed.");
//}

- (void)routingService:(SKRoutingService *)routingService didFinishRouteCalculationWithInfo:(SKRouteInformation*)routeInformation{
    NSLog(@"Route is calculated.");
    [routingService zoomToRouteWithInsets:UIEdgeInsetsZero duration:1]; // zooming to currrent route
    
    SKNavigationSettings* navSettings = [SKNavigationSettings navigationSettings];
    navSettings.navigationType=SKNavigationTypeSimulation;
    navSettings.distanceFormat=SKDistanceFormatMilesFeet;
    navSettings.showStreetNamePopUpsOnRoute=YES;
    [SKRoutingService sharedInstance].mapView.settings.displayMode = SKMapDisplayMode3D;
    [[SKRoutingService sharedInstance]startNavigationWithSettings:navSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
