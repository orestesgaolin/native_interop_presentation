#if (defined(USE_UIKIT_PUBLIC_HEADERS) && USE_UIKIT_PUBLIC_HEADERS) || !__has_include(<UIKitCore/UITextPasteConfigurationSupporting.h>)
//
//  UITextPasteConfigurationSupporting.h
//  UIKit 
//
//  Copyright © 2017-2018 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIPasteConfigurationSupporting.h"
#import "UIKitDefines.h"
#import "UIPasteConfiguration.h"
#import "UITextPasteDelegate.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(watchos, tvos) NS_SWIFT_UI_ACTOR
@protocol UITextPasteConfigurationSupporting <UIPasteConfigurationSupporting>

@property (nonatomic, weak, nullable) id<UITextPasteDelegate> pasteDelegate;

@end

NS_ASSUME_NONNULL_END

#else
#import "UIKitCore/UITextPasteConfigurationSupporting.h"
#endif
