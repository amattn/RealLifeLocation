/******************************************************************************
 * - Created 7/17/12 by Matt Nunogawa
 * - Copyright __MyCompanyName__ 2012. All rights reserved.
 * - License: <#LICENSE#>
 *
 * <#SUMMARY INFORMATION#>
 *
 * Created from templates: https://github.com/amattn/RealLifeXcode4Templates
 */

#import "RLLocationManager.h"

@interface RLLocationManager ()

@property (nonatomic, strong) CLLocationManager *coreLocationManager;
@property (nonatomic, strong) NSMutableSet *handlers;
@property (nonatomic, assign) CLLocationAccuracy lastKnownAccuracy;
@end

@implementation RLLocationManager

#pragma mark ** Synthesis **

@synthesize lastKnownLocation = _lastKnownLocation;

@synthesize coreLocationManager = _coreLocationManager;
@synthesize handlers = _handlers;
@synthesize lastKnownAccuracy = _lastKnownAccuracy;

#pragma mark ** Static Variables **

static RLLocationManager *__sharedRLLocationManager = nil;

#pragma mark ** Singleton **

+ (RLLocationManager *)singleton;
{
    static dispatch_once_t singletonCreationToken;
    dispatch_once(&singletonCreationToken, ^
    {
        __sharedRLLocationManager = [[RLLocationManager alloc] init];
    });
    return __sharedRLLocationManager;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Lifecyle Methods **

- (id)init;
{
    self = [super init];
    if (self)
    {
        self.lastKnownAccuracy = __builtin_huge_val();
    }
    return self;
}

- (void)dealloc;
{
    SHOULD_NEVER_GET_HERE;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** NotificationHandlers **

//*****************************************************************************
#pragma mark -
#pragma mark ** Utilities **

//*****************************************************************************
#pragma mark -
#pragma mark ** Actions **

- (void)startAcquiringLocation;
{
    [self.coreLocationManager startUpdatingLocation];
}

- (void)addLocationUpdateHandler:(RLLocationManagerUpdateHandlerBlockType)handler;
{
    [self.handlers addObject:handler];
}

- (void)removeHandler:(RLLocationManagerUpdateHandlerBlockType)handler;
{
    [self.handlers removeObject:handler];
}

//*****************************************************************************
#pragma mark -
#pragma mark ** CLLocationManagerDelegate **

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;
{
    self.lastKnownLocation = newLocation;
    
    [self.handlers enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        RLLocationManagerUpdateHandlerBlockType handler = obj;
        handler(newLocation);
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RL_LOCATION_MANAGER_UPDATE_NOTIFICATION
                                                        object:self];
    
    if (newLocation.horizontalAccuracy < self.lastKnownAccuracy) {
        // keep going
//        NSLog(@"newLocation.horizontalAccuracy %f", newLocation.horizontalAccuracy);
    } else {
        // stop
        [self.coreLocationManager stopUpdatingLocation];
    }
    
    self.lastKnownAccuracy = newLocation.horizontalAccuracy;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.coreLocationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_2);
{
    
}


//*****************************************************************************
#pragma mark -
#pragma mark ** Accesssors **

+ (BOOL)locationServicesEnabled;
{
    return [CLLocationManager locationServicesEnabled];
}

- (NSMutableSet *)handlers;
{
	if (_handlers == nil) {
        _handlers = [[NSMutableSet alloc] init];
	}
	return _handlers;
}

- (CLLocationManager *)coreLocationManager;
{
	if (_coreLocationManager == nil) {
        _coreLocationManager = [[CLLocationManager alloc] init];
        _coreLocationManager.delegate = self;
        _coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _coreLocationManager.distanceFilter = 100;
	}
	return _coreLocationManager;
}

@end
