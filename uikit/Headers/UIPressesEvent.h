#if (defined(USE_UIKIT_PUBLIC_HEADERS) && USE_UIKIT_PUBLIC_HEADERS) || !__has_include(<UIKitCore/UIPressesEvent.h>)
//
//  UIPressesEvent.h
//  UIKit
//
//  Copyright (c) 2005-2018 Apple Inc. All rights reserved.
//

#import "UIEvent.h"
#import "UIKitDefines.h"
#import "UIPress.h"
#import "UIGestureRecognizer.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN API_AVAILABLE(ios(9.0)) NS_SWIFT_UI_ACTOR
@interface UIPressesEvent : UIEvent

@property(nonatomic, readonly) NSSet <UIPress *> *allPresses;
- (NSSet <UIPress *> *)pressesForGestureRecognizer:(UIGestureRecognizer *)gesture;

@end

NS_ASSUME_NONNULL_END

#else
#import "UIKitCore/UIPressesEvent.h"
#endif
