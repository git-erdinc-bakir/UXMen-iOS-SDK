//
// Created by E_BAKIR on 2019-04-25.
// Copyright (c) 2019 E_BAKIR. All rights reserved.
//

#import "UXMenAPI.h"
#import "UXMenResponseHandshake.h"
#import "UXMenRequestWireFrame.h"
#import "UXMenRequestHandshake.h"
#import "UXMenGestureTrack.h"
#import "UXMenDeviceManager.h"
#import "UXMenRequestElementData.h"
#import "UXMenRequestStory.h"

NSString *API_BASE_URL;

NSString *API_HANDSHAKE = @"handshake";
NSString *API_STORY = @"story";

@implementation UXMenAPI {
    id <UIApplicationDelegate> delegate;
    NSTimer *trackerTimer;

    long apiSessionId;

    NSDictionary *headers;

    UXMenResponseHandshake *handshakeResponse;
    UXMenResponseStatus *statusResponse;

    NSString *pageName;
    NSString *lastCachedPageName;
    NSMutableArray *currentViewComponents;
}

#pragma mark CONFIGURATION

- (void)configure {
    delegate = [UIApplication sharedApplication].delegate;

    apiSessionId = -1;
    pageName = @"";
    lastCachedPageName = @"-";

    API_BASE_URL = @"http://134.209.93.110:3000";
    // API_BASE_URL = @"http://192.168.1.10:3000";

    headers = @{@"Content-Type": @"application/json",
            @"cache-control": @"no-cache"};

    UXMenRequestHandshake *requestDeviceData = [UXMenRequestHandshake new];

    NSString *uuid = [[NSUUID UUID] UUIDString];
    requestDeviceData.uid = uuid;

    UXMenDeviceManager *deviceManager = [UXMenDeviceManager new];
    NSString *platformString = [deviceManager deviceName];
    requestDeviceData.device_name = platformString;

    requestDeviceData.resolutionW = [UIScreen mainScreen].bounds.size.width;
    requestDeviceData.resolutionH = [UIScreen mainScreen].bounds.size.height;

    requestDeviceData.frameW = [UIScreen mainScreen].nativeBounds.size.width;
    requestDeviceData.frameH = [UIScreen mainScreen].nativeBounds.size.height;

    requestDeviceData.ratio = [UIScreen mainScreen].scale;

    [self handshake:requestDeviceData];

    trackerTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(timerCalled)
                                                  userInfo:nil
                                                   repeats:YES];

}

#pragma mark HANDSHAKE OPERATIONS

- (void)handshake:(UXMenRequestHandshake *)requestDeviceData {

    NSDictionary *parameters = @{@"uid": requestDeviceData.uid,
            @"device_name": requestDeviceData.device_name,
            @"ratio": @(requestDeviceData.ratio),
            @"resolutionH": @(requestDeviceData.resolutionH),
            @"resolutionW": @(requestDeviceData.resolutionW),
            @"frameW": @(requestDeviceData.frameW),
            @"frameH": @(requestDeviceData.frameH)};

    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];

    NSString *urlString = [NSString stringWithFormat:@"%@/%@", API_BASE_URL, API_HANDSHAKE];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);

                                                        NSLog(@"returnWithUXMenApiError");
                                                        // [self.delegate returnWithUXMenApiError:API_HANDSHAKE];

                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);

                                                        // Parse the JSON response
                                                        NSError *jsonError;
                                                        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                     options:nil
                                                                                                                       error:&jsonError];
                                                        if (jsonError) {
//                                                            [NSException raise:@"Exception on parsing JSON data"
//                                                                        format:@"%@", jsonError.localizedDescription];

                                                            NSLog(@"returnWithUXMenApiError");
                                                            // [self.delegate returnWithUXMenApiError:API_HANDSHAKE];
                                                            return;
                                                        }

                                                        self->handshakeResponse = [UXMenResponseHandshake new];
                                                        self->handshakeResponse.status = [jsonResponse[@"status"] intValue];
                                                        self->handshakeResponse.session = [jsonResponse[@"session"] longLongValue];

                                                        self->apiSessionId = self->handshakeResponse.session;

                                                        [self initScreen];

                                                        // [self.delegate returnWithUXMenHandshake:handshakeResponse];

                                                    }
                                                }];
    [dataTask resume];

}

- (void)initScreen {

    [self sendNewStoryWithNewScreen:YES];
    
}

#pragma mark WIREFRAME OPERATIONS

- (NSMutableArray *)getViewComponents {
//    NSLog(@"getViewComponents");

    UIViewController *topViewController = [UIViewController new];
    topViewController.view = [UIView new];

    if ([self->delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        //        NSLog(@"getViewComponents UINavigationController class");
        UINavigationController *controller = (UINavigationController *) self->delegate.window.rootViewController;
        topViewController = [[controller viewControllers] lastObject];

    } else if ([self->delegate.window.rootViewController isKindOfClass:[UIViewController class]]) {
        //        NSLog(@"getViewComponents UIViewController class");
        topViewController = self->delegate.window.rootViewController;

    } else {
        NSLog(@"getViewComponents class");
        NSLog(@"%@", [NSString stringWithFormat:@"%@", [self->delegate.window.rootViewController class] ]);
        
        return [NSMutableArray new];
    }

    pageName = NSStringFromClass([topViewController class]);
    
    UIView *currentView = topViewController.view;

//    NSLog(@"CONTAINER VIEW X      : %f", currentView.frame.origin.x);
//    NSLog(@"CONTAINER VIEW Y      : %f", currentView.frame.origin.y);
//    NSLog(@"CONTAINER VIEW WIDTH  : %f", currentView.frame.size.width);
//    NSLog(@"CONTAINER VIEW HEIGHT : %f", currentView.frame.size.height);

    self->currentViewComponents = [NSMutableArray new];

    [self parseView:currentView];

    return self->currentViewComponents;

}

- (void)parseView:(UIView *)view {

    for (UIView *subview in view.subviews) {
        UXMenRequestElementData *elementData = [UXMenRequestElementData new];

        if ([subview class] == [UIButton class]) {
            NSLog(@"VIEW'DE BULUNAN OBJE    : UIButton");

            elementData.type = @"UIButton";

            UIButton *parseButton = (UIButton *) subview;
            for (id target in parseButton.allTargets) {
                NSArray *actions = [parseButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
                for (NSString *action in actions) {
                    NSLog(@"TIKLANAN BUTON ACTION      : %@", action);
                }
            }

        } else if ([subview class] == [UIImageView class]) {
            NSLog(@"VIEW'DE BULUNAN OBJE    : UIImageView");

            elementData.type = @"UIImageView";

        } else if ([subview class] == [UILabel class]) {
            NSLog(@"VIEW'DE BULUNAN OBJE    : UILabel");

            elementData.type = @"UILabel";

        } else if ([subview class] == [UITextView class]) {
            NSLog(@"VIEW'DE BULUNAN OBJE    : UITextView");

            elementData.type = @"UITextView";

        } else if ([subview class] == [UITextField class]) {
            NSLog(@"VIEW'DE BULUNAN OBJE    : UITextField");

            elementData.type = @"UITextField";

        } else if ([subview class] == [UIView class]) {
            NSLog(@"VIEW'DE BULUNAN OBJE    : UIView");

            elementData.type = @"UIView";

            [self parseView:subview];

        } else if ([subview class] == [UILayoutGuide class]) {
            NSLog(@"VIEW'DE BULUNAN OBJE    : UILayoutGuide");
            
            elementData.type = @"UILayoutGuide";
            
            [self parseView:subview];
            
        } else {
            elementData.type = @"OtherComponent";

        }

//        NSLog(@"COMPONENT X      : %f", subview.frame.origin.x);
//        NSLog(@"COMPONENT Y      : %f", subview.frame.origin.y);
//        NSLog(@"COMPONENT WIDTH  : %f", subview.frame.size.width);
//        NSLog(@"COMPONENT HEIGHT : %f", subview.frame.size.height);

//        NSLog(@"-");

        elementData.posX = subview.frame.origin.x;
        elementData.posY = subview.frame.origin.y;

        elementData.objWidth = subview.frame.size.width;
        elementData.objHeight = subview.frame.size.height;

        [currentViewComponents addObject:elementData];

    }

}

#pragma mark TOUCH OPERATIONS

- (NSMutableArray *)getTouchLocations {
    NSMutableArray *arrayPoints = [delegate.window getTouchLocations];
    return arrayPoints;
}

- (NSMutableArray *)getTouchWeights {
    NSMutableArray *arrayWeigths = [delegate.window getTouchWeights];
    return arrayWeigths;
}

- (void)resetTouchRecords {

    [delegate.window resetTouchRecords];

}

- (void)timerCalled {

    [self sendNewStoryWithNewScreen:NO];
    
}

- (void)sendNewStoryWithNewScreen:(BOOL) isInitialScreen {

    NSMutableArray *arrayPoints = [self getTouchLocations];
    // NSMutableArray *arrayWeigths = [self getTouchWeights];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UXMenRequestStory *requestStory = [UXMenRequestStory new];
        requestStory.session_id = @(self->apiSessionId);

        NSDate *currentDate = [NSDate date];
        double timestamp = [currentDate timeIntervalSince1970];
        requestStory.timestamp = timestamp;

        ///////////////////////////
        // GATHER WIREFRAME DATA
        ///////////////////////////
        
        NSMutableDictionary *dictWireframe = [NSMutableDictionary new];
        dictWireframe[@"timeStamp"] = @(timestamp);
        
        NSMutableArray *arrayElements = [NSMutableArray new];
        NSMutableArray *arrayViewComponents = [self getViewComponents];
        
        for (NSUInteger i = 0; i < arrayViewComponents.count; i++) {
            UXMenRequestElementData *screenData = arrayViewComponents[i];
            
            NSMutableDictionary *dictElement = [NSMutableDictionary new];
            dictElement[@"posX"] = @(screenData.posX);
            dictElement[@"posY"] = @(screenData.posY);
            
            dictElement[@"objWidth"] = @(screenData.objWidth);
            dictElement[@"objHeight"] = @(screenData.objHeight);
            
            dictElement[@"type"] = screenData.type;
            
            [arrayElements addObject:dictElement];
            
        }
        
        dictWireframe[@"elements"] = arrayElements;
        
        NSMutableArray *arrayWireframes = [NSMutableArray new];
        [arrayWireframes addObject:dictWireframe];
        
        requestStory.wireframes = arrayWireframes;

        ////////////////////////
        // GATHER ACTION DATA
        ////////////////////////
        
        BOOL hasAnyAction = NO;
        NSMutableArray *arrayActions = [NSMutableArray new];
        if ([arrayPoints isKindOfClass:[NSMutableArray class]]) {
            if (arrayPoints.count > 0) {
                hasAnyAction = YES;
                
                for (NSValue *pointValue in arrayPoints) {
                    CGPoint point = [pointValue CGPointValue];
                    
                    NSMutableDictionary *dictAction = [NSMutableDictionary new];
                    dictAction[@"posX"] = @(point.x);
                    dictAction[@"posY"] = @(point.y);
                    
                    dictAction[@"timestamp"] = @(timestamp);
                    
                    [arrayActions addObject:dictAction];
                    
                }
                
                [self resetTouchRecords];
                
            }
            
        }
        requestStory.actions = arrayActions;

        ///////////////////////////
        // SEND DATA TO SERVER
        ///////////////////////////
        requestStory.page = self->pageName;
        
        if ([self->lastCachedPageName isEqualToString:@"-"]) {
            self->lastCachedPageName = self->pageName;
            
            [self sendStory:requestStory];
        
        } else if ([self->pageName isEqualToString:self->lastCachedPageName] == NO) {
            [self sendStory:requestStory];
            
        } else if (hasAnyAction){
            [self resetTouchRecords];
            
            [self sendStory:requestStory];
            
        }
        
    });

}

- (void)sendStory:(UXMenRequestStory *)requestStory {

    ////////////////////////
    // GATHER STORY DATA
    ////////////////////////

    NSDictionary *parameters = @{@"session_id": requestStory.session_id,
            @"page": requestStory.page,
            @"timeStamp": @(requestStory.timestamp),
            @"wireframes": requestStory.wireframes,
            @"actions": requestStory.actions};

    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];

    NSString *urlString = [NSString stringWithFormat:@"%@/%@", API_BASE_URL, API_STORY];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        self->lastCachedPageName = @"-";
                                                        
                                                        NSLog(@"%@", error);

                                                        NSLog(@"returnWithUXMenApiError");
                                                        // [self.delegate returnWithUXMenApiError:API_WIREFRAME];

                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);

                                                        // Parse the JSON response
                                                        NSError *jsonError;
                                                        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                     options:nil
                                                                                                                       error:&jsonError];
                                                        if (jsonError) {
                                                            self->lastCachedPageName = @"-";
                                                            
                                                            // [NSException raise:@"Exception on parsing JSON data" format:@"%@", jsonError.localizedDescription];

                                                            NSLog(@"returnWithUXMenApiError");
                                                            //[self.delegate returnWithUXMenApiError:API_HANDSHAKE];

                                                            return;
                                                        }
                                                        
                                                        self->statusResponse = [UXMenResponseStatus new];
                                                        self->statusResponse.status = [jsonResponse[@"status"] intValue];

                                                        // [self.delegate returnWithUXMenWireframe:statusResponse.status];

                                                    }
                                                }];
    [dataTask resume];

}

@end
