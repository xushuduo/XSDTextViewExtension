## XSDTextViewExtension
### UITextField、UITextView属性扩展

* 增加DisEmoji属性限制是否能输入表情
* 增加MaxLength属性限制字段长度

```
UITextField *textField = [UITextField setupTextFieldWithTextColor:[UIColor darkTextColor] textSize:18 placeholderColor:[UIColor cyanColor] maxLength:100 returnKeyType:UIReturnKeyDone keyboardType:UIKeyboardTypeDefault clearButtonMode:UITextFieldViewModeWhileEditing addView:self.view];
textField.disEmoji = YES;   // 限制输入Emoji表情
textField.maxLength = 50;   // 限制输入50个字
```


## License

[MIT license](https://github.com/xushuduo/XSDTextViewExtension/blob/master/LICENSE)

## About

作者：XSDCoder

博客：[https://www.xsd.me/](https://www.xsd.me/)
