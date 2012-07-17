/******************************************************************************
 * - Created 7/17/12 by Matt Nunogawa
 * - Copyright __MyCompanyName__ 2012. All rights reserved.
 * - License: <#LICENSE#>
 *
 * <#SUMMARY INFORMATION#>
 *
 * Created from templates: https://github.com/amattn/RealLifeXcode4Templates
 */

#import <CoreLocation/CoreLocation.h>

#pragma mark ** Constant Defines **

#define RL_LOCATION_MANAGER_UPDATE_NOTIFICATION @"RL_LOCATION_MANAGER_UPDATE_NOTIFICATION"

#pragma mark ** Protocols & Declarations **

typedef void (^RLLocationManagerUpdateHandlerBlockType)(CLLocation *);

@interface RLLocationManager : NSObject <CLLocationManagerDelegate>
{

}

#pragma mark ** Singleton Accessors **

+ (RLLocationManager *)singleton;
+ (BOOL)locationServicesEnabled; // shortcut

#pragma mark ** Properties **

@property (nonatomic, strong) CLLocation *lastKnownLocation;

#pragma mark ** Methods **

// start acquiring location 
- (void)startAcquiringLocation;

// If you add a handler, make sure to remove the handler during your dealloc or similar
- (void)addLocationUpdateHandler:(RLLocationManagerUpdateHandlerBlockType)handler;
- (void)removeHandler:(RLLocationManagerUpdateHandlerBlockType)handler;

@end
