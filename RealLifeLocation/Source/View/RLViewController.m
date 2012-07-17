/******************************************************************************
 * - Created 7/17/12 by Matt Nunogawa
 * - Copyright __MyCompanyName__ 2012. All rights reserved.
 * - License: <#LICENSE#>
 *
 * <#SUMMARY INFORMATION#>
 *
 * Created from templates: https://github.com/amattn/RealLifeXcode4Templates
 */

#import "RLViewController.h"

#import "RLLocationManager.h"

@interface RLViewController ()

@end

@implementation RLViewController

@synthesize latLongLabel = _latLongLabel;
@synthesize accuracyLabel = _accuracyLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)viewDidAppear:(BOOL)animated;
{
    RLLocationManager *locationManager = [RLLocationManager singleton];
    
    [locationManager addLocationUpdateHandler:^(CLLocation *newLocation) {
        self.latLongLabel.text = [NSString stringWithFormat:@"lat,long: %f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
        self.accuracyLabel.text = [NSString stringWithFormat:@"accuracy: %f", newLocation.horizontalAccuracy];
    }];
    [locationManager startAcquiringLocation];
}

@end
