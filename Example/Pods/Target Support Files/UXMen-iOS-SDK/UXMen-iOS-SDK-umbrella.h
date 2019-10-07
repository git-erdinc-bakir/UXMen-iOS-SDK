#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UXMenAPI.h"
#import "UXMenRequestHandshake.h"
#import "UXMenResponseHandshake.h"
#import "UXMenResponseStatus.h"
#import "UXMenRequestActionData.h"
#import "UXMenRequestElementData.h"
#import "UXMenRequestStory.h"
#import "UXMenRequestWireFrame.h"
#import "UXMenDeviceManager.h"
#import "UXMenGestureTrack.h"
#import "UXMenTouchUpdateModel.h"
#import "UXMenTrackGesture.h"
#import "UXMenSDK.h"

FOUNDATION_EXPORT double UXMen_iOS_SDKVersionNumber;
FOUNDATION_EXPORT const unsigned char UXMen_iOS_SDKVersionString[];

