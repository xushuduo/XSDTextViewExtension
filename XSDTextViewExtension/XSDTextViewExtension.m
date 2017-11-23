//
//  XSDTextViewExtension.m
//  TextViewExtension
//
//  Created by 许树铎 on 2017/11/13.
//  Copyright © 2017年 xushuduo. All rights reserved.
//

#import "XSDTextViewExtension.h"
#import <objc/runtime.h>

static const char XSDTextViewExtensionMaxLengthKey = '\0';

static const char XSDTextViewExtensionDisEmojiKey = '\0';

@implementation XSDTextViewExtension

+ (void)load {
    [super load];
    [self sharedManager];
}

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:@"YYTextViewTextDidChange" object:nil];
    }
    return self;
}

- (void)textDidChange:(NSNotification *)notification {
    UITextField *textField = notification.object;
    if ([textField respondsToSelector:@selector(disEmoji)] && textField.disEmoji) {
        textField.text = [XSDTextViewExtension converStrEmoji:textField.text];
    }
    if ([textField respondsToSelector:@selector(disEmoji)] && textField.maxLength) {
        NSString *toBeString = textField.text;
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position || !selectedRange) {
            if (toBeString.length > textField.maxLength) {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:textField.maxLength];
                if (rangeIndex.length == 1) {
                    textField.text = [toBeString substringToIndex:textField.maxLength];
                } else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, textField.maxLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSString *)converStrEmoji:(NSString *)emojiStr {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:emojiStr options:0 range:NSMakeRange(0, [emojiStr length]) withTemplate:@""];
    return modifiedString;
}

@end

@implementation UITextField (XSDExtension)

+ (instancetype)setupTextFieldWithTextColor:(UIColor *)textColor textSize:(CGFloat)textSize placeholderColor:(UIColor *)placeholderColor maxLength:(NSUInteger)maxLength returnKeyType:(UIReturnKeyType)returnKeyType keyboardType:(UIKeyboardType)keyboardType clearButtonMode:(UITextFieldViewMode)clearButtonMode addView:(UIView *)subview {
    UITextField *textField = [[self alloc] init];
    textField.textColor = textColor;
    textField.font = [UIFont systemFontOfSize:textSize];
    if (placeholderColor && [placeholderColor isKindOfClass:[UIColor class]]) {
        [textField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    textField.maxLength = maxLength;
    textField.returnKeyType = returnKeyType;
    textField.keyboardType = keyboardType;
    textField.clearButtonMode = clearButtonMode;
    [subview addSubview:textField];
    return textField;
}

- (void)setMaxLength:(NSUInteger)maxLength {
    objc_setAssociatedObject(self, &XSDTextViewExtensionMaxLengthKey, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
}

- (NSUInteger)maxLength {
    return ((NSNumber *)objc_getAssociatedObject(self, &XSDTextViewExtensionMaxLengthKey)).unsignedIntegerValue;
}

- (void)setDisEmoji:(BOOL)disEmoji {
    objc_setAssociatedObject(self, &XSDTextViewExtensionDisEmojiKey, @(disEmoji), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)disEmoji {
    return ((NSNumber *)objc_getAssociatedObject(self, &XSDTextViewExtensionDisEmojiKey)).boolValue;
}

@end

@implementation UITextView (XSDExtension)

+ (instancetype)setupTextViewWithTextColor:(UIColor *)textColor texgtSize:(CGFloat)textSize maxLength:(NSUInteger)maxLength  returnKeyType:(UIReturnKeyType)returnKeyType keyboardType:(UIKeyboardType)keyboardType addView:(UIView *)subview {
    UITextView *textView = [[self alloc] init];
    textView.textColor = textColor;
    textView.font = [UIFont systemFontOfSize:textSize];
    textView.maxLength = maxLength;
    textView.returnKeyType = returnKeyType;
    textView.keyboardType = keyboardType;
    [subview addSubview:textView];
    return textView;
}

- (void)setMaxLength:(NSUInteger)maxLength {
    objc_setAssociatedObject(self, &XSDTextViewExtensionMaxLengthKey, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
}

- (NSUInteger)maxLength {
    return ((NSNumber *)objc_getAssociatedObject(self, &XSDTextViewExtensionMaxLengthKey)).unsignedIntegerValue;
}

- (void)setDisEmoji:(BOOL)disEmoji {
    objc_setAssociatedObject(self, &XSDTextViewExtensionDisEmojiKey, @(disEmoji), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)disEmoji {
    return ((NSNumber *)objc_getAssociatedObject(self, &XSDTextViewExtensionDisEmojiKey)).boolValue;
}

@end
