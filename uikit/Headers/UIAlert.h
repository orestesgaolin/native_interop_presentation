#if (defined(USE_UIKIT_PUBLIC_HEADERS) && USE_UIKIT_PUBLIC_HEADERS) || !__has_include(<UIKitCore/UIAlert.h>)
//
//  UIAlert.h
//  UIKit
//
//  Copyright (c) 2005-2018 Apple Inc. All rights reserved.
//

#import "UIActionSheet.h"
#import "UIAlertView.h"

#else
#import "UIKitCore/UIAlert.h"
#endif
