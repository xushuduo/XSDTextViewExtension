//
//  XSDTextViewExtension.h
//  TextViewExtension
//
//  Created by 许树铎 on 2017/11/13.
//  Copyright © 2017年 xushuduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSDTextViewExtension : NSObject

/**
 过滤Emoji表情

 @param emojiStr 字符串
 @return 过滤后字符串
 */
+ (NSString *)converStrEmoji:(NSString *)emojiStr;

@end

@interface UITextField (XSDExtension)

/**
 禁用Emoji表情（默认NO）
 */
@property (nonatomic, assign) BOOL disEmoji;

/**
 限制长度（默认0为不限制）
 */
@property (nonatomic, assign) NSUInteger maxLength;

+ (instancetype)setupTextFieldWithTextColor:(UIColor *)textColor textSize:(CGFloat)textSize placeholderColor:(UIColor *)placeholderColor maxLength:(NSUInteger)maxLength returnKeyType:(UIReturnKeyType)returnKeyType keyboardType:(UIKeyboardType)keyboardType clearButtonMode:(UITextFieldViewMode)clearButtonMode addView:(UIView *)subview;

@end

@interface UITextView (XSDExtension)

/**
 禁用Emoji表情（默认NO）
 */
@property (nonatomic, assign) BOOL disEmoji;

/**
 限制长度（默认0为不限制）
 */
@property (nonatomic, assign) NSUInteger maxLength;

+ (instancetype)setupTextViewWithTextColor:(UIColor *)textColor texgtSize:(CGFloat)textSize maxLength:(NSUInteger)maxLength  returnKeyType:(UIReturnKeyType)returnKeyType keyboardType:(UIKeyboardType)keyboardType addView:(UIView *)subview;

@end
