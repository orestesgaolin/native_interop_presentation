#include <stdint.h>
#import <Foundation/Foundation.h>
#import <objc/message.h>
#import "../Headers/UIKitDefines.h"
#import "../Headers/UICommand.h"
#import "../Headers/UIAlertController.h"
#import "../Headers/UIViewController.h"
#import "../Headers/UISpringLoadedInteractionSupporting.h"
#import "../Headers/UIApplication.h"
#import "../Headers/UIWindow.h"
#import "../Headers/UIMenu.h"

#if !__has_feature(objc_arc)
#error "This file must be compiled with ARC enabled"
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

typedef struct {
  int64_t version;
  void* (*newWaiter)(void);
  void (*awaitWaiter)(void*);
  void* (*currentIsolate)(void);
  void (*enterIsolate)(void*);
  void (*exitIsolate)(void);
  int64_t (*getMainPortId)(void);
  bool (*getCurrentThreadOwnsIsolate)(int64_t);
} DOBJC_Context;

id objc_retainBlock(id);

#define BLOCKING_BLOCK_IMPL(ctx, BLOCK_SIG, INVOKE_DIRECT, INVOKE_LISTENER)    \
  assert(ctx->version >= 1);                                                   \
  void* targetIsolate = ctx->currentIsolate();                                 \
  int64_t targetPort = ctx->getMainPortId == NULL ? 0 : ctx->getMainPortId();  \
  return BLOCK_SIG {                                                           \
    void* currentIsolate = ctx->currentIsolate();                              \
    bool mayEnterIsolate =                                                     \
        currentIsolate == NULL &&                                              \
        ctx->getCurrentThreadOwnsIsolate != NULL &&                            \
        ctx->getCurrentThreadOwnsIsolate(targetPort);                          \
    if (currentIsolate == targetIsolate || mayEnterIsolate) {                  \
      if (mayEnterIsolate) {                                                   \
        ctx->enterIsolate(targetIsolate);                                      \
      }                                                                        \
      INVOKE_DIRECT;                                                           \
      if (mayEnterIsolate) {                                                   \
        ctx->exitIsolate();                                                    \
      }                                                                        \
    } else {                                                                   \
      void* waiter = ctx->newWaiter();                                         \
      INVOKE_LISTENER;                                                         \
      ctx->awaitWaiter(waiter);                                                \
    }                                                                          \
  };


Protocol* _UIKit_NSExtensionRequestHandling(void) { return @protocol(NSExtensionRequestHandling); }

typedef id  (^ProtocolTrampoline)(void * sel, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
id  _UIKit_protocolTrampoline_xr62hr(id target, void * sel, id arg1) {
  return ((ProtocolTrampoline)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1);
}

typedef id  (^ProtocolTrampoline_1)(void * sel);
__attribute__((visibility("default"))) __attribute__((used))
id  _UIKit_protocolTrampoline_1mbt9g9(id target, void * sel) {
  return ((ProtocolTrampoline_1)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel);
}

typedef BOOL  (^ProtocolTrampoline_2)(void * sel);
__attribute__((visibility("default"))) __attribute__((used))
BOOL  _UIKit_protocolTrampoline_e3qsqz(id target, void * sel) {
  return ((ProtocolTrampoline_2)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel);
}

typedef void  (^ListenerTrampoline)(void * arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline _UIKit_wrapListenerBlock_18v1jvf(ListenerTrampoline block) NS_RETURNS_RETAINED {
  return ^void(void * arg0, id arg1) {
    objc_retainBlock(block);
    block(arg0, (__bridge id)(__bridge_retained void*)(arg1));
  };
}

typedef void  (^BlockingTrampoline)(void * waiter, void * arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline _UIKit_wrapBlockingBlock_18v1jvf(
    BlockingTrampoline block, BlockingTrampoline listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1));
  });
}

typedef void  (^ProtocolTrampoline_3)(void * sel, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
void  _UIKit_protocolTrampoline_18v1jvf(id target, void * sel, id arg1) {
  return ((ProtocolTrampoline_3)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1);
}

Protocol* _UIKit_UIUserActivityRestoring(void) { return @protocol(UIUserActivityRestoring); }

Protocol* _UIKit_UIResponderStandardEditActions(void) { return @protocol(UIResponderStandardEditActions); }

Protocol* _UIKit_UIAppearance(void) { return @protocol(UIAppearance); }

Protocol* _UIKit_UIAppearanceContainer(void) { return @protocol(UIAppearanceContainer); }

Protocol* _UIKit_UIDynamicItem(void) { return @protocol(UIDynamicItem); }

Protocol* _UIKit_UITraitEnvironment(void) { return @protocol(UITraitEnvironment); }

Protocol* _UIKit_UICoordinateSpace(void) { return @protocol(UICoordinateSpace); }

Protocol* _UIKit_UIFocusItem(void) { return @protocol(UIFocusItem); }

Protocol* _UIKit_UIFocusItemContainer(void) { return @protocol(UIFocusItemContainer); }

Protocol* _UIKit_CALayerDelegate(void) { return @protocol(CALayerDelegate); }

Protocol* _UIKit_UIContentContainer(void) { return @protocol(UIContentContainer); }

Protocol* _UIKit_UIFocusEnvironment(void) { return @protocol(UIFocusEnvironment); }

typedef void  (^ListenerTrampoline_1)();
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_1 _UIKit_wrapListenerBlock_1pl9qdv(ListenerTrampoline_1 block) NS_RETURNS_RETAINED {
  return ^void() {
    objc_retainBlock(block);
    block();
  };
}

typedef void  (^BlockingTrampoline_1)(void * waiter);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_1 _UIKit_wrapBlockingBlock_1pl9qdv(
    BlockingTrampoline_1 block, BlockingTrampoline_1 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(), {
    objc_retainBlock(block);
    block(nil);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter);
  });
}

typedef void  (^ListenerTrampoline_2)(BOOL arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_2 _UIKit_wrapListenerBlock_1s56lr9(ListenerTrampoline_2 block) NS_RETURNS_RETAINED {
  return ^void(BOOL arg0) {
    objc_retainBlock(block);
    block(arg0);
  };
}

typedef void  (^BlockingTrampoline_2)(void * waiter, BOOL arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_2 _UIKit_wrapBlockingBlock_1s56lr9(
    BlockingTrampoline_2 block, BlockingTrampoline_2 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(BOOL arg0), {
    objc_retainBlock(block);
    block(nil, arg0);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0);
  });
}

Protocol* _UIKit_UIStateRestoring(void) { return @protocol(UIStateRestoring); }

Protocol* _UIKit_UIViewControllerRestoration(void) { return @protocol(UIViewControllerRestoration); }

Protocol* _UIKit_UIObjectRestoration(void) { return @protocol(UIObjectRestoration); }

Protocol* _UIKit_UIViewControllerTransitioningDelegate(void) { return @protocol(UIViewControllerTransitioningDelegate); }

Protocol* _UIKit_UILayoutSupport(void) { return @protocol(UILayoutSupport); }

Protocol* _UIKit_UIViewControllerPreviewing(void) { return @protocol(UIViewControllerPreviewing); }

Protocol* _UIKit_UIViewControllerPreviewingDelegate(void) { return @protocol(UIViewControllerPreviewingDelegate); }

typedef struct CGSize  (^ProtocolTrampoline_4)(void * sel);
__attribute__((visibility("default"))) __attribute__((used))
struct CGSize  _UIKit_protocolTrampoline_1j20mp(id target, void * sel) {
  return ((ProtocolTrampoline_4)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel);
}

typedef struct CGSize  (^ProtocolTrampoline_5)(void * sel, id arg1, struct CGSize arg2);
__attribute__((visibility("default"))) __attribute__((used))
struct CGSize  _UIKit_protocolTrampoline_gnbb7x(id target, void * sel, id arg1, struct CGSize arg2) {
  return ((ProtocolTrampoline_5)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

Protocol* _UIKit_UIViewControllerTransitionCoordinator(void) { return @protocol(UIViewControllerTransitionCoordinator); }

typedef void  (^ListenerTrampoline_3)(void * arg0, struct CGSize arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_3 _UIKit_wrapListenerBlock_1rn6eap(ListenerTrampoline_3 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0, struct CGSize arg1, id arg2) {
    objc_retainBlock(block);
    block(arg0, arg1, (__bridge id)(__bridge_retained void*)(arg2));
  };
}

typedef void  (^BlockingTrampoline_3)(void * waiter, void * arg0, struct CGSize arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_3 _UIKit_wrapBlockingBlock_1rn6eap(
    BlockingTrampoline_3 block, BlockingTrampoline_3 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, struct CGSize arg1, id arg2), {
    objc_retainBlock(block);
    block(nil, arg0, arg1, (__bridge id)(__bridge_retained void*)(arg2));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, arg1, (__bridge id)(__bridge_retained void*)(arg2));
  });
}

typedef void  (^ProtocolTrampoline_6)(void * sel, struct CGSize arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
void  _UIKit_protocolTrampoline_1rn6eap(id target, void * sel, struct CGSize arg1, id arg2) {
  return ((ProtocolTrampoline_6)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

typedef void  (^ListenerTrampoline_4)(void * arg0, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_4 _UIKit_wrapListenerBlock_fjrv01(ListenerTrampoline_4 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0, id arg1, id arg2) {
    objc_retainBlock(block);
    block(arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2));
  };
}

typedef void  (^BlockingTrampoline_4)(void * waiter, void * arg0, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_4 _UIKit_wrapBlockingBlock_fjrv01(
    BlockingTrampoline_4 block, BlockingTrampoline_4 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1, id arg2), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1), (__bridge id)(__bridge_retained void*)(arg2));
  });
}

typedef void  (^ProtocolTrampoline_7)(void * sel, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
void  _UIKit_protocolTrampoline_fjrv01(id target, void * sel, id arg1, id arg2) {
  return ((ProtocolTrampoline_7)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

typedef void  (^ListenerTrampoline_5)(void * arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_5 _UIKit_wrapListenerBlock_ovsamd(ListenerTrampoline_5 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0) {
    objc_retainBlock(block);
    block(arg0);
  };
}

typedef void  (^BlockingTrampoline_5)(void * waiter, void * arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_5 _UIKit_wrapBlockingBlock_ovsamd(
    BlockingTrampoline_5 block, BlockingTrampoline_5 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0), {
    objc_retainBlock(block);
    block(nil, arg0);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0);
  });
}

typedef void  (^ProtocolTrampoline_8)(void * sel);
__attribute__((visibility("default"))) __attribute__((used))
void  _UIKit_protocolTrampoline_ovsamd(id target, void * sel) {
  return ((ProtocolTrampoline_8)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel);
}

typedef BOOL  (^ProtocolTrampoline_9)(void * sel, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
BOOL  _UIKit_protocolTrampoline_3su7tt(id target, void * sel, id arg1) {
  return ((ProtocolTrampoline_9)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1);
}

typedef id  (^ProtocolTrampoline_10)(void * sel, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
id  _UIKit_protocolTrampoline_zi5eed(id target, void * sel, id arg1, id arg2) {
  return ((ProtocolTrampoline_10)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

Protocol* _UIKit_UIInteraction(void) { return @protocol(UIInteraction); }

typedef struct CGPoint  (^ProtocolTrampoline_11)(void * sel);
__attribute__((visibility("default"))) __attribute__((used))
struct CGPoint  _UIKit_protocolTrampoline_7ohnx8(id target, void * sel) {
  return ((ProtocolTrampoline_11)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel);
}

typedef void  (^ListenerTrampoline_6)(void * arg0, struct CGPoint arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_6 _UIKit_wrapListenerBlock_1bktu2(ListenerTrampoline_6 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0, struct CGPoint arg1) {
    objc_retainBlock(block);
    block(arg0, arg1);
  };
}

typedef void  (^BlockingTrampoline_6)(void * waiter, void * arg0, struct CGPoint arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_6 _UIKit_wrapBlockingBlock_1bktu2(
    BlockingTrampoline_6 block, BlockingTrampoline_6 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, struct CGPoint arg1), {
    objc_retainBlock(block);
    block(nil, arg0, arg1);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, arg1);
  });
}

typedef void  (^ProtocolTrampoline_12)(void * sel, struct CGPoint arg1);
__attribute__((visibility("default"))) __attribute__((used))
void  _UIKit_protocolTrampoline_1bktu2(id target, void * sel, struct CGPoint arg1) {
  return ((ProtocolTrampoline_12)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1);
}

typedef struct CGRect  (^ProtocolTrampoline_13)(void * sel);
__attribute__((visibility("default"))) __attribute__((used))
struct CGRect  _UIKit_protocolTrampoline_1c3uc0w(id target, void * sel) {
  return ((ProtocolTrampoline_13)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel);
}

typedef struct CGAffineTransform  (^ProtocolTrampoline_14)(void * sel);
__attribute__((visibility("default"))) __attribute__((used))
struct CGAffineTransform  _UIKit_protocolTrampoline_8o6he9(id target, void * sel) {
  return ((ProtocolTrampoline_14)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel);
}

typedef void  (^ListenerTrampoline_7)(void * arg0, struct CGAffineTransform arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_7 _UIKit_wrapListenerBlock_1lznlw3(ListenerTrampoline_7 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0, struct CGAffineTransform arg1) {
    objc_retainBlock(block);
    block(arg0, arg1);
  };
}

typedef void  (^BlockingTrampoline_7)(void * waiter, void * arg0, struct CGAffineTransform arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_7 _UIKit_wrapBlockingBlock_1lznlw3(
    BlockingTrampoline_7 block, BlockingTrampoline_7 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, struct CGAffineTransform arg1), {
    objc_retainBlock(block);
    block(nil, arg0, arg1);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, arg1);
  });
}

typedef void  (^ProtocolTrampoline_15)(void * sel, struct CGAffineTransform arg1);
__attribute__((visibility("default"))) __attribute__((used))
void  _UIKit_protocolTrampoline_1lznlw3(id target, void * sel, struct CGAffineTransform arg1) {
  return ((ProtocolTrampoline_15)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1);
}

typedef UIDynamicItemCollisionBoundsType  (^ProtocolTrampoline_16)(void * sel);
__attribute__((visibility("default"))) __attribute__((used))
UIDynamicItemCollisionBoundsType  _UIKit_protocolTrampoline_ku69ws(id target, void * sel) {
  return ((ProtocolTrampoline_16)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel);
}

typedef struct CGPoint  (^ProtocolTrampoline_17)(void * sel, struct CGPoint arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
struct CGPoint  _UIKit_protocolTrampoline_17ipln5(id target, void * sel, struct CGPoint arg1, id arg2) {
  return ((ProtocolTrampoline_17)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

typedef struct CGRect  (^ProtocolTrampoline_18)(void * sel, struct CGRect arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
struct CGRect  _UIKit_protocolTrampoline_1sh7l9z(id target, void * sel, struct CGRect arg1, id arg2) {
  return ((ProtocolTrampoline_18)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

typedef id  (^ProtocolTrampoline_19)(void * sel, struct CGRect arg1);
__attribute__((visibility("default"))) __attribute__((used))
id  _UIKit_protocolTrampoline_12thpau(id target, void * sel, struct CGRect arg1) {
  return ((ProtocolTrampoline_19)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1);
}

typedef void  (^ListenerTrampoline_8)(void * arg0, id arg1, struct CGContext * arg2);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_8 _UIKit_wrapListenerBlock_qvcerx(ListenerTrampoline_8 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0, id arg1, struct CGContext * arg2) {
    objc_retainBlock(block);
    block(arg0, (__bridge id)(__bridge_retained void*)(arg1), arg2);
  };
}

typedef void  (^BlockingTrampoline_8)(void * waiter, void * arg0, id arg1, struct CGContext * arg2);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_8 _UIKit_wrapBlockingBlock_qvcerx(
    BlockingTrampoline_8 block, BlockingTrampoline_8 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1, struct CGContext * arg2), {
    objc_retainBlock(block);
    block(nil, arg0, (__bridge id)(__bridge_retained void*)(arg1), arg2);
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, (__bridge id)(__bridge_retained void*)(arg1), arg2);
  });
}

typedef void  (^ProtocolTrampoline_20)(void * sel, id arg1, struct CGContext * arg2);
__attribute__((visibility("default"))) __attribute__((used))
void  _UIKit_protocolTrampoline_qvcerx(id target, void * sel, id arg1, struct CGContext * arg2) {
  return ((ProtocolTrampoline_20)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}

Protocol* _UIKit_CAAction(void) { return @protocol(CAAction); }

Protocol* _UIKit_UIMenuBuilder(void) { return @protocol(UIMenuBuilder); }

typedef void  (^ListenerTrampoline_9)(id arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_9 _UIKit_wrapListenerBlock_f167m6(ListenerTrampoline_9 block) NS_RETURNS_RETAINED {
  return ^void(id arg0) {
    objc_retainBlock(block);
    block(objc_retainBlock(arg0));
  };
}

typedef void  (^BlockingTrampoline_9)(void * waiter, id arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_9 _UIKit_wrapBlockingBlock_f167m6(
    BlockingTrampoline_9 block, BlockingTrampoline_9 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(id arg0), {
    objc_retainBlock(block);
    block(nil, objc_retainBlock(arg0));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, objc_retainBlock(arg0));
  });
}

typedef void  (^ListenerTrampoline_10)(void * arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_10 _UIKit_wrapListenerBlock_1l4hxwm(ListenerTrampoline_10 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0, id arg1) {
    objc_retainBlock(block);
    block(arg0, objc_retainBlock(arg1));
  };
}

typedef void  (^BlockingTrampoline_10)(void * waiter, void * arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_10 _UIKit_wrapBlockingBlock_1l4hxwm(
    BlockingTrampoline_10 block, BlockingTrampoline_10 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(void * arg0, id arg1), {
    objc_retainBlock(block);
    block(nil, arg0, objc_retainBlock(arg1));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, arg0, objc_retainBlock(arg1));
  });
}

typedef void  (^ProtocolTrampoline_21)(void * sel, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
void  _UIKit_protocolTrampoline_1l4hxwm(id target, void * sel, id arg1) {
  return ((ProtocolTrampoline_21)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1);
}

Protocol* _UIKit_CAMediaTiming(void) { return @protocol(CAMediaTiming); }

Protocol* _UIKit_UITextInputTraits(void) { return @protocol(UITextInputTraits); }

Protocol* _UIKit_UIKeyInput(void) { return @protocol(UIKeyInput); }

Protocol* _UIKit_UITextInput(void) { return @protocol(UITextInput); }

Protocol* _UIKit_UIContentSizeCategoryAdjusting(void) { return @protocol(UIContentSizeCategoryAdjusting); }

typedef void  (^ListenerTrampoline_11)(id arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_11 _UIKit_wrapListenerBlock_xtuoz7(ListenerTrampoline_11 block) NS_RETURNS_RETAINED {
  return ^void(id arg0) {
    objc_retainBlock(block);
    block((__bridge id)(__bridge_retained void*)(arg0));
  };
}

typedef void  (^BlockingTrampoline_11)(void * waiter, id arg0);
__attribute__((visibility("default"))) __attribute__((used))
ListenerTrampoline_11 _UIKit_wrapBlockingBlock_xtuoz7(
    BlockingTrampoline_11 block, BlockingTrampoline_11 listenerBlock,
    DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, ^void(id arg0), {
    objc_retainBlock(block);
    block(nil, (__bridge id)(__bridge_retained void*)(arg0));
  }, {
    objc_retainBlock(listenerBlock);
    listenerBlock(waiter, (__bridge id)(__bridge_retained void*)(arg0));
  });
}

Protocol* _UIKit_UIApplicationDelegate(void) { return @protocol(UIApplicationDelegate); }
#undef BLOCKING_BLOCK_IMPL

#pragma clang diagnostic pop
