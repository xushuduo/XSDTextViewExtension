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
    if ([textField respondsToSelector:@selector(disEmoji)]) {
        if (textField.disEmoji) {
            textField.text = [XSDTextViewExtension converStrEmoji:textField.text];
        }
        if (textField.maxLength) {
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
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSString *)converStrEmoji:(NSString *)emojiStr {
    NSString *tempStr = [[NSString alloc] init];
    NSMutableString *kksstr = [[NSMutableString alloc] init];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    NSMutableString *strMu = [[NSMutableString alloc] init];
    for(int i =0; i < [emojiStr length]; i++) {
        tempStr = [emojiStr substringWithRange:NSMakeRange(i, 1)];
        [strMu appendString:tempStr];
        if ([self stringContainsEmoji:strMu]) {
            strMu = [[strMu substringToIndex:([strMu length] - strMu.length > 1 ? 2 : strMu.length)] mutableCopy];
            [array removeLastObject];
            continue;
        }else
            [array addObject:tempStr];
    }
    for (NSString *strs in array) {
        [kksstr appendString:strs];
    }
    return kksstr;
}

// 判断字符串是否为表情
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
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
