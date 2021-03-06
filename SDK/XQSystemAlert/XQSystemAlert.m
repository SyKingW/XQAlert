//
//  XQSystemAlert.m
//  AppolloVensi
//
//  Created by YJH on 2017/11/3.
//  Copyright © 2017年 shishuzhen. All rights reserved.
//

#import "XQSystemAlert.h"

/** 按钮样式
 UIAlertActionStyleDefault 蓝色, 默认
 UIAlertActionStyleDestructive 警告, 红色
 UIAlertActionStyleCancel 取消, 蓝色, 放在最后or最左, 而且这个样式在一个弹框中, 只能存在一个
 */

@implementation XQSystemAlert

#pragma mark -- 大致适配iPad
+ (UIAlertController *)alertWithTitle:(NSString *)title
               message:(NSString *)message
            contentArr:(NSArray *)contentArr
            cancelText:(NSString *)cancelText
                    vc:(UIViewController *)vc
       contentCallback:(XQSystemAlertBlock)contentCallback
        cancelCallback:(XQSystemAlertCancelBlock)cancelCallback {
    return [self alertWithStyle:UIAlertControllerStyleAlert title:title message:message contentArr:contentArr cancelText:cancelText vc:vc textFieldCount:0 textFieldBlock:nil contentCallback:contentCallback cancelCallback:cancelCallback];
}

+ (UIAlertController *)actionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                  contentArr:(NSArray *)contentArr
                  cancelText:(NSString *)cancelText
                          vc:(UIViewController *)vc
             contentCallback:(XQSystemAlertBlock)contentCallback
              cancelCallback:(XQSystemAlertCancelBlock)cancelCallback {
    return [self alertWithStyle:UIAlertControllerStyleActionSheet title:title message:message contentArr:contentArr cancelText:cancelText vc:vc textFieldCount:0 textFieldBlock:nil contentCallback:contentCallback cancelCallback:cancelCallback];
}

+ (UIAlertController *)alertWithTitle:(NSString *)title
               message:(NSString *)message
            contentArr:(NSArray *)contentArr
            cancelText:(NSString *)cancelText
                    vc:(UIViewController *)vc
        textFieldCount:(NSUInteger)textFieldCount
        textFieldBlock:(XQSystemAlertTextFieldBlock)textFieldBlock
       contentCallback:(XQSystemAlertBlock)contentCallback
        cancelCallback:(XQSystemAlertCancelBlock)cancelCallback {
    return [self alertWithStyle:UIAlertControllerStyleAlert title:title message:message contentArr:contentArr cancelText:cancelText vc:vc textFieldCount:textFieldCount textFieldBlock:textFieldBlock contentCallback:contentCallback cancelCallback:cancelCallback];
}

#pragma mark -- 具体适配iPad

/**
 底部弹框, 手动完美适配iPad

 @param sourceView 弹出在那个view上面
 */
+ (UIAlertController *_Nullable)actionSheetWithTitle:(NSString *_Nullable)title
                                             message:(NSString *_Nullable)message
                                          contentArr:(NSArray *_Nullable)contentArr
                                          cancelText:(NSString *_Nullable)cancelText
                                                  vc:(UIViewController *_Nullable)vc
                                          sourceView:(UIView *_Nullable)sourceView
                                     contentCallback:(XQSystemAlertBlock _Nullable)contentCallback
                                      cancelCallback:(XQSystemAlertCancelBlock _Nullable)cancelCallback {
    return [self alertWithStyle:UIAlertControllerStyleActionSheet title:title message:message contentArr:contentArr cancelText:cancelText vc:vc sourceView:sourceView sourceRect:sourceView.bounds textFieldCount:0 textFieldBlock:nil contentCallback:contentCallback cancelCallback:cancelCallback];
}

+ (UIAlertController *)actionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                  contentArr:(NSArray *)contentArr
                  cancelText:(NSString *)cancelText
                          vc:(UIViewController *)vc
                  sourceView:(UIView *)sourceView
                  sourceRect:(CGRect)sourceRect
             contentCallback:(XQSystemAlertBlock)contentCallback
              cancelCallback:(XQSystemAlertCancelBlock)cancelCallback {
    return [self alertWithStyle:UIAlertControllerStyleActionSheet title:title message:message contentArr:contentArr cancelText:cancelText vc:vc sourceView:sourceView sourceRect:sourceRect textFieldCount:0 textFieldBlock:nil contentCallback:contentCallback cancelCallback:cancelCallback];
}

+ (UIAlertController *)alertWithStyle:(UIAlertControllerStyle)style
                 title:(NSString *)title
               message:(NSString *)message
            contentArr:(NSArray *)contentArr
            cancelText:(NSString *)cancelText
                    vc:(UIViewController *)vc
        textFieldCount:(NSUInteger)textFieldCount
        textFieldBlock:(XQSystemAlertTextFieldBlock)textFieldBlock
       contentCallback:(XQSystemAlertBlock)contentCallback
        cancelCallback:(XQSystemAlertCancelBlock)cancelCallback {
    CGRect sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height, 0, 0);
    return [self alertWithStyle:style title:title message:message contentArr:contentArr cancelText:cancelText vc:vc sourceView:nil sourceRect:sourceRect textFieldCount:textFieldCount textFieldBlock:textFieldBlock contentCallback:contentCallback cancelCallback:cancelCallback];
    
}

+ (UIAlertController *)alertWithStyle:(UIAlertControllerStyle)style
                 title:(NSString *)title
               message:(NSString *)message
            contentArr:(NSArray *)contentArr
            cancelText:(NSString *)cancelText
                    vc:(UIViewController *)vc
            sourceView:(UIView *)sourceView
            sourceRect:(CGRect)sourceRect
        textFieldCount:(NSUInteger)textFieldCount
        textFieldBlock:(XQSystemAlertTextFieldBlock)textFieldBlock
       contentCallback:(XQSystemAlertBlock)contentCallback
        cancelCallback:(XQSystemAlertCancelBlock)cancelCallback {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
        // 适配ipad, 不然会直接崩溃
    if (style == UIAlertControllerStyleActionSheet) {
        if (sourceView) {
            alert.popoverPresentationController.sourceView = sourceView;
        }else {
            UIView *keyWindow = [self getWindow];
            alert.popoverPresentationController.sourceView = keyWindow;
        }
        
        //CGRect rect = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height, 0, 0);
        alert.popoverPresentationController.sourceRect = sourceRect;
    }
    
    __weak typeof(alert) weakSelf = alert;
        // 输入框
    for (int i = 0; i < textFieldCount; i++) {
        int a = i;
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            if (textFieldBlock) {
                textFieldBlock(a, textField);
            }
        }];
    }
    
        // 选择按钮
    for (int i = 0; i < contentArr.count; i++) {
        NSString *str = contentArr[i];
        int a = i;
        UIAlertAction *action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (contentCallback) {
                contentCallback(weakSelf, a);
            }
        }];
        [alert addAction:action];
    }
    
        // 取消按钮
    if (cancelText) {
            // 默认在左边, 或最底下
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelCallback) {
                cancelCallback(weakSelf);
            }
        }];
        [alert addAction:cancleAction];
    }
    
        // 没有点击按钮, 并是中间弹框情况下, 用户会返回不了, 所以不允许弹框
    if (alert.actions.count == 0 && alert.preferredStyle == UIAlertControllerStyleAlert) {
        return nil;
    }
    
        // 跳转
    if (vc) {
        [vc presentViewController:alert animated:YES completion:nil];
    }else {
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (rootVC) {
            [rootVC presentViewController:alert animated:YES completion:nil];
        }else {
            NSLog(@"vc不存在");
        }
    }
    
    return alert;
}

/// 获取window
+ (UIWindow *)getWindow {
    if (@available(iOS 13.0, *)) {
        if ([[UIApplication sharedApplication].connectedScenes.allObjects.firstObject isKindOfClass:[UIWindowScene class]]) {
            
            UIWindowScene *ws = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
            if (ws.windows.firstObject) {
                return ws.windows.firstObject;
            }
            
            return [UIApplication sharedApplication].keyWindow;
            
        }else {
            return [UIApplication sharedApplication].keyWindow;
        }
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

#pragma mark -- 额外的一些方法

/** 获取alert */
+ (UIAlertController *)alertCtr {
    return (UIAlertController *)[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
}

/**
 退出当前弹框
 */
+ (void)alertDismiss {
    if (![self isAlert]) {
        return;
    }
    
    [[self alertCtr] dismissViewControllerAnimated:YES completion:nil];
}

/**
 当前是否是弹框
 
 @return YES是弹框在最前面
 */
+ (BOOL)isAlert {
    return [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController isKindOfClass:[UIAlertController class]];
}

/**
 改变当前弹框的title
 */
+ (void)changeAlertTitle:(NSString *)title {
    if (![self isAlert]) {
        return;
    }
    
    UIAlertController *alert = [self alertCtr];
    alert.title = title;
}

/**
 改变当前弹框的message
 */
+ (void)changeAlertMessage:(NSString *)message {
    if (![self isAlert]) {
        return;
    }
    
    UIAlertController *alert = [self alertCtr];
    alert.message = message;
}

/**
 改变当前弹框的某个按钮是否可以点击
 
 @param enabled YES可以点击
 @param index 按钮的下标
 */
+ (void)changeEnabled:(BOOL)enabled index:(NSInteger)index {
    if (![self isAlert]) {
        return;
    }
    
    UIAlertController *alert = [self alertCtr];
    if (alert.actions.count > index) {
        alert.actions[index].enabled = enabled;
    }
}

/**
 在当前弹框上, 再添加一个按钮
 
 @param title 按钮标题
 @param callback 点击回调
 */
+ (void)addActionWithTitle:(NSString *)title callback:(XQSystemAlertActionBlock)callback {
    if (![self isAlert]) {
        return;
    }
    
    UIAlertController *alert = [self alertCtr];
    [alert addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (callback) {
            callback(alert);
        }
    }]];
}

/**
 在当前弹框上, 添加输入框
 
 @param callback 设置tf属性回调
 */
+ (void)addTextFieldWithCallback:(XQSystemAlertTextFieldBlock)callback {
    if (![self isAlert]) {
        return;
    }
    
    UIAlertController *alert = [self alertCtr];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        if (callback) {
            callback(0, textField);
        }
    }];
}

@end


















