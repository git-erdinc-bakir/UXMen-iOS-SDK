//
// Created by E_BAKIR on 2019-04-25.
// Copyright (c) 2019 E_BAKIR. All rights reserved.
//


#import "UXMenAPI.h"
#import "UXMenRequestHandshake.h"
#import "UXMenDeviceManager.h"
#import "UXMenRequestElementData.h"
#import "UXMenRequestStory.h"

NSString *API_BASE_URL;

NSString *API_LOGIN = @"login";
NSString *API_HANDSHAKE = @"handshake";
NSString *API_STORY = @"story";

@implementation UXMenAPI {
    id <UIApplicationDelegate> delegate;
    
    bool isTrackingActive;
    
    NSString *appId;
    NSString *secret;
    
    bool isScreenChanged;
    NSString *currentPageName;
    
    NSString *apiSessionId;
    NSDictionary *headers;
    
    NSTimer *trackerTimer;
    
    NSMutableArray *currentViewComponents;
    
}

static UXMenAPI *uxmenShared = nil;

- (id)init {
    if (uxmenShared) return uxmenShared;
    if ((self = [super init])) {
        uxmenShared = self;
    }
    return uxmenShared;
}

+ (UXMenAPI *)shared {
    if (!uxmenShared) {
        uxmenShared = [UXMenAPI new];
    }
    return uxmenShared;
}

#pragma mark CONFIGURATION

- (void)startTracking:(UIWindow *)window {
    
    // [window setUxmenTouchDelegate:self];
    [window startTracking];
        
}

- (void)configure:(NSString *)uxmenAppId andSecretKey:(NSString *)uxmenSecretKey {
    delegate = [UIApplication sharedApplication].delegate;
    
    isTrackingActive = YES;
    
    isScreenChanged = NO;
    apiSessionId = @"-1";
    currentPageName = @"";
    
    appId = uxmenAppId;
    secret = uxmenSecretKey;
    
    API_BASE_URL = @"http://134.209.93.110:3000";
    
    headers = @{@"Content-Type": @"application/json",
                @"cache-control": @"no-cache"};
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleDidEnterBackground:)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleWillEnterForeground:)
                                                 name: UIApplicationWillEnterForegroundNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTouchUpdate:)
                                                 name:@"UXMenTouchNotification"
                                               object:nil];
    
    // START TOKENIZATION
    [self tokenization];
    
}

- (void)handleDidEnterBackground:(NSNotification *)note {
    NSLog(@"handleDidEnterBackground: %@", note);

    [self sendAppStatusNotification:@"handleDidEnterBackground"];
    
}

- (void)handleWillEnterForeground:(NSNotification *)note {
    NSLog(@"handleWillEnterForeground: %@", note);
    
    [self sendAppStatusNotification:@"handleWillEnterForeground"];
    
}

- (void)sendAppStatusNotification:(NSString *)appStatus {
    
    if (isTrackingActive == NO) {
        return;
    }
    
    if ([apiSessionId isEqualToString:@"-1"]) {
        return;
    }
    
    ////////////////////////
    // GATHER STORY DATA
    ////////////////////////

    NSDate *currentDate = [NSDate date];
    double timestamp = [currentDate timeIntervalSince1970];
    
    NSDictionary *parameters = @{@"session_id": apiSessionId,
                                 @"appStatusNotification": appStatus,
                                 @"timeStamp": @(timestamp)};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", API_BASE_URL, API_STORY];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
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
                NSLog(@"returnWithUXMenApiError");
                return;
            } else {
                int status = [jsonResponse[@"status"] intValue];
                if (status == 200) {
                    NSLog(@"%@", jsonResponse[@"result"]);
                    
                }
            }
        }
    }];
    [dataTask resume];
    
}

#pragma mark TOKENIZATION OPERATION

- (void)tokenization {
    
    NSDictionary *parameters = @{@"appId": appId,
                                 @"secret": secret};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", API_BASE_URL, API_LOGIN];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                //[NSException raise:@"Exception on parsing JSON data"
                //             format:@"%@", jsonError.localizedDescription];
                
                NSLog(@"returnWithUXMenApiError");
                // [self.delegate returnWithUXMenApiError:API_HANDSHAKE];
                return;
            }
            
            int status = [jsonResponse[@"status"] intValue];
            if (status == 200) {
                NSString *uxmenToken = jsonResponse[@"result"];
                
                [self handShakeWithToken:uxmenToken];
                   
            }
        }
    }];
    [dataTask resume];
    
}

#pragma mark HANDSHAKE OPERATION

- (void)handShakeWithToken:(NSString *)token {

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
    
    //Configure your session with common header fields like authorization etc
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{@"Authorization": token};
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                //[NSException raise:@"Exception on parsing JSON data"
                //             format:@"%@", jsonError.localizedDescription];
                
                NSLog(@"returnWithUXMenApiError");
                // [self.delegate returnWithUXMenApiError:API_HANDSHAKE];
                return;
            }
            
            int status = [jsonResponse[@"status"] intValue];
            if (status == 200) {
                self->apiSessionId = jsonResponse[@"result"];
                
                [self initScreen];
                
            } else if (status == 403){
                self->isTrackingActive = NO;
                
            }            
        }
    }];
    [dataTask resume];
    
}

- (void)initScreen {
    
    NSDate *currentDate = [NSDate date];
    double timestamp = [currentDate timeIntervalSince1970];
    
    NSMutableDictionary *dictWireframe = [NSMutableDictionary new];
    dictWireframe[@"timeStamp"] = @(timestamp);
    
    NSMutableArray *listWireframes = [NSMutableArray new];
    
    NSMutableArray *arrayPageElements = [NSMutableArray new];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *arrayViewComponents = [self getViewComponents];
        for (NSUInteger i = 0; i < arrayViewComponents.count; i++) {
            UXMenRequestElementData *screenData = arrayViewComponents[i];
            
            NSMutableDictionary *dictElement = [NSMutableDictionary new];
            dictElement[@"zIndex"] = @(screenData.zIndex);
            
            dictElement[@"posX"] = @(screenData.posX);
            dictElement[@"posY"] = @(screenData.posY);
            
            dictElement[@"objWidth"] = @(screenData.objWidth);
            dictElement[@"objHeight"] = @(screenData.objHeight);
            
            dictElement[@"contentOffsetY"] = @(screenData.contentOffsetY);
            
            dictElement[@"parent"] = screenData.parent;
            dictElement[@"viewIdentifier"] = screenData.viewIdentifier;
            
            dictElement[@"type"] = screenData.type;
            dictElement[@"text"] = screenData.text;
            dictElement[@"btnAction"] = screenData.btnAction;
            
            dictElement[@"backgroundColor"] = screenData.backgroundColor;
            
            [arrayPageElements addObject:dictElement];
            
        }
        
        dictWireframe[@"elements"] = arrayPageElements;
        
        [listWireframes addObject:dictWireframe];
        
        [self sendNewStoryWithNewScreen:YES withWireframes:listWireframes withActions:[NSMutableArray new]];
        
        self->trackerTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(checkScreenChanges)
                                                            userInfo:nil
                                                             repeats:YES];
        
    });
}

- (void)checkScreenChanges {
    //    NSLog(@"checkScreenChanges");
    
    if (isScreenChanged) {
        isScreenChanged = NO;
        
        [self initScreen];
        
    }
    
}

#pragma mark WIREFRAME OPERATIONS

- (NSMutableArray *)getViewComponents {
    //    NSLog(@"getViewComponents");
    
    UIViewController *topViewController = [UIViewController new];
    topViewController.view = [UIView new];
    
    if ([self->delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *controller = (UINavigationController *) self->delegate.window.rootViewController;
        topViewController = [[controller viewControllers] lastObject];
        
        if (topViewController.presentedViewController != nil){
            if ([topViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigationController = (UINavigationController *)topViewController.presentedViewController;
                topViewController = [[navigationController viewControllers] lastObject];
            } else {
                topViewController = (UIViewController *)topViewController.presentedViewController;
                
            }
        }
    } else if ([self->delegate.window.rootViewController isKindOfClass:[UIViewController class]]) {
        topViewController = self->delegate.window.rootViewController;
        
        if (topViewController.presentedViewController != nil){
            if ([topViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigationController = (UINavigationController *)topViewController.presentedViewController;
                topViewController = [[navigationController viewControllers] lastObject];
            } else {
                topViewController = (UIViewController *)topViewController.presentedViewController;
                
            }
        }
    } else {
        NSLog(@"getViewComponents class");
        NSLog(@"%@", [NSString stringWithFormat:@"%@", [self->delegate.window.rootViewController class]]);
        
        return [NSMutableArray new];
    }
    
    NSString *screenName = NSStringFromClass([topViewController class]);
    if ([currentPageName isEqualToString:@""] == NO
        && [screenName isEqualToString:currentPageName] == NO) {
        isScreenChanged = YES;
    }
    currentPageName = screenName;
    
    UIView *currentView = topViewController.view;
    
    //    NSLog(@"CONTAINER VIEW X      : %f", currentView.frame.origin.x);
    //    NSLog(@"CONTAINER VIEW Y      : %f", currentView.frame.origin.y);
    //    NSLog(@"CONTAINER VIEW WIDTH  : %f", currentView.frame.size.width);
    //    NSLog(@"CONTAINER VIEW HEIGHT : %f", currentView.frame.size.height);
    
    self->currentViewComponents = [NSMutableArray new];
    
    NSString *parentId = [UXMenAPI generateRandomString:20];
    [self parseView:currentView viewParent:parentId];
    
    return self->currentViewComponents;
    
}

+ (NSString *)generateRandomString:(int)num {
    NSMutableString *string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++) {
        [string appendFormat:@"%C", (unichar) ('a' + arc4random_uniform(26))];
    }
    return string;
}

- (void)parseView:(UIView *)view viewParent:(NSString *)parent {
    
    int zIndex = 0;
    for (UIView *subview in view.subviews) {
        zIndex++;
        UXMenRequestElementData *elementData = [UXMenRequestElementData new];
        elementData.parent = parent;
        
        NSString *viewIdentifier = [UXMenAPI generateRandomString:20];
        elementData.viewIdentifier = viewIdentifier;
        
        elementData.zIndex = zIndex;
        
        elementData.text = @"";
        elementData.btnAction = @"";
        
        elementData.backgroundColor = [self colorToString:subview.backgroundColor];
                
        if ([subview class] == [UIButton class]
            || [[subview class] isSubclassOfClass:[UIButton class]]) {
            // NSLog(@"VIEW'DE BULUNAN OBJE    : UIButton");
            
            elementData.type = @"Button";
            
            UIButton *parseButton = (UIButton *) subview;
            elementData.text = parseButton.titleLabel.text;
            
            for (id target in parseButton.allTargets) {
                NSArray *actions = [parseButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
                for (NSString *action in actions) {
                    NSLog(@"TIKLANAN BUTON ACTION      : %@", action);
                    elementData.btnAction = action;
                }
            }
            
        } else if ([subview class] == [UIImageView class]
                   || [[subview class] isSubclassOfClass:[UIImageView class]]) {
            elementData.type = @"ImageView";
            
        } else if ([subview class] == [UILabel class]
                   || [[subview class] isSubclassOfClass:[UILabel class]]) {
            elementData.type = @"Label";
            
            UILabel *parseLabel = (UILabel *) subview;
            elementData.text = parseLabel.text;
            
        } else if ([subview class] == [UITextView class]
                   || [[subview class] isSubclassOfClass:[UITextView class]]) {
            elementData.type = @"TextView";
            
            UITextView *parseText = (UITextView *) subview;
            elementData.text = parseText.text;
            
        } else if ([subview class] == [UITextField class]
                   || [[subview class] isSubclassOfClass:[UITextField class]]) {
            elementData.type = @"TextField";
            
            UITextField *parseText = (UITextField *) subview;
            elementData.text = parseText.text;
            
        } else if ([subview class] == [UITableView class]
                   || [[subview class] isSubclassOfClass:[UITableView class]]) {
            elementData.type = @"TableView";
            elementData.text = @"";
            
            UITableView *parseTableView = (UITableView *) subview;
            elementData.contentOffsetY = parseTableView.contentOffset.y;
            
            [self parseView:subview viewParent:elementData.viewIdentifier];
            
        } else if ([subview class] == [UITableViewCell class]
                   || [[subview class] isSubclassOfClass:[UITableViewCell class]]) {
            elementData.type = @"TableViewCell";
            elementData.text = @"";
            
        } else if ([subview class] == [UIScrollView class]
                   || [[subview class] isSubclassOfClass:[UIScrollView class]]) {
            elementData.type = @"ScrollView";
            elementData.text = @"";
            
            UIScrollView *parseScrollView = (UIScrollView *) subview;
            elementData.contentOffsetY = parseScrollView.contentOffset.y;
            
            [self parseView:subview viewParent:elementData.viewIdentifier];
            
        } else if ([subview class] == [UIView class]) {
            elementData.type = @"View";
            
            [self parseView:subview viewParent:elementData.viewIdentifier];
            
        } else {
            elementData.type = @"UnknownComponent";
            
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

- (NSString *) colorToString:(UIColor *) color {
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return [NSString stringWithFormat:@"%02x%02x%02x", (int)(red * 255), (int)(green * 255) , (int)(blue * 255)];
}

#pragma mark TOUCH OPERATIONS

// Prints a message whenever a MyNotification is received
- (void)handleTouchUpdate:(NSNotification *)note {
    NSLog(@"handleTouchUpdate: %@", note);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // GET SNAPSHOT OF SCREEN WHEN TOUCH DETECTED
        
        NSDate *currentDate = [NSDate date];
        double timestamp = [currentDate timeIntervalSince1970];
        
        NSMutableDictionary *dictWireframe = [NSMutableDictionary new];
        dictWireframe[@"timeStamp"] = @(timestamp);
        
        NSMutableArray *arrayPageElements = [NSMutableArray new];
        
        NSMutableArray *arrayViewComponents = [self getViewComponents];
        for (NSUInteger i = 0; i < arrayViewComponents.count; i++) {
            UXMenRequestElementData *screenData = arrayViewComponents[i];
            
            NSMutableDictionary *dictElement = [NSMutableDictionary new];
            dictElement[@"zIndex"] = @(screenData.zIndex);
            
            dictElement[@"posX"] = @(screenData.posX);
            dictElement[@"posY"] = @(screenData.posY);
            
            dictElement[@"objWidth"] = @(screenData.objWidth);
            dictElement[@"objHeight"] = @(screenData.objHeight);
            
            dictElement[@"contentOffsetY"] = @(screenData.contentOffsetY);
            
            dictElement[@"parent"] = screenData.parent;
            dictElement[@"viewIdentifier"] = screenData.viewIdentifier;
            
            dictElement[@"type"] = screenData.type;
            dictElement[@"text"] = screenData.text;
            dictElement[@"btnAction"] = screenData.btnAction;
            
            dictElement[@"backgroundColor"] = screenData.backgroundColor;
            
            [arrayPageElements addObject:dictElement];
            
        }
        
        dictWireframe[@"elements"] = arrayPageElements;
        
        NSMutableArray *arrayWireframes = [NSMutableArray new];
        [arrayWireframes addObject:dictWireframe];
        
        NSMutableArray *arrayTouches = [self getTouchLocations];
        if ([arrayTouches isKindOfClass:[NSMutableArray class]]) {
            if (arrayTouches.count > 0) {
                [self sendNewStoryWithNewScreen:NO withWireframes:arrayWireframes withActions:arrayTouches];
                
            }
        }
    });
}

#pragma mark GESTURE TRACKER OPERATIONS

- (NSMutableArray *)getTouchLocations {
    NSMutableArray *arrayTouches = [delegate.window getTouchLocations];
    return arrayTouches;
}

- (void)removeFirstTouchRecord {
    [delegate.window removeFirstTouchRecord];
}

- (void)resetTouchRecords {
    [delegate.window resetTouchRecords];
}

#pragma mark WEBSERVICE

- (void)sendNewStoryWithNewScreen:(BOOL)isInitialScreen
                   withWireframes:(NSMutableArray *)listWireframes
                      withActions:(NSMutableArray *)listActions{
    
    if (isTrackingActive == NO) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UXMenRequestStory *requestStory = [UXMenRequestStory new];
        requestStory.session_id = self->apiSessionId;
        
        NSDate *currentDate = [NSDate date];
        double timestamp = [currentDate timeIntervalSince1970];
        requestStory.timestamp = timestamp;
        
        ///////////////////////////
        // GATHER WIREFRAME DATA
        ///////////////////////////
        
        requestStory.wireframes = listWireframes;
        
        ////////////////////////
        // GATHER ACTION DATA
        ////////////////////////
        
        NSString *pageName = @"";
        NSMutableArray *dictActions = [NSMutableArray new];
        
        if (listActions.count > 0) {
            for (UXMenTouchUpdateModel *modelTouch in listActions) {
                pageName = modelTouch.pageName;
                
                CGPoint point = [modelTouch.touchLocation CGPointValue];
                
                NSMutableDictionary *dictAction = [NSMutableDictionary new];
                dictAction[@"posX"] = @(point.x);
                dictAction[@"posY"] = @(point.y);
                
                dictAction[@"timestamp"] = @(modelTouch.timestamp);
                
                [dictActions addObject:dictAction];
                
            }
            
            [self removeFirstTouchRecord];
            
        }
        
        requestStory.actions = dictActions;
        requestStory.page = pageName;
        if ([pageName isEqualToString:@""]) {
            requestStory.page = self->currentPageName;
        }
        
        ///////////////////////////
        // SEND DATA TO SERVER
        ///////////////////////////
        [self sendStory:requestStory];
        
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
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
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
                NSLog(@"returnWithUXMenApiError");
                return;
            } else {
                int status = [jsonResponse[@"status"] intValue];
                if (status == 200) {
                    NSLog(@"%@", jsonResponse[@"result"]);
                    
                }
            }            
        }
    }];
    [dataTask resume];
    
}

@end
