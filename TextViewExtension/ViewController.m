//
//  ViewController.m
//  TextViewExtension
//
//  Created by 许树铎 on 2017/11/13.
//  Copyright © 2017年 xushuduo. All rights reserved.
//

#import "ViewController.h"
#import "XSDTextViewExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextField *textField = [UITextField setupTextFieldWithTextColor:[UIColor darkTextColor] textSize:18 placeholderColor:[UIColor cyanColor] maxLength:100 returnKeyType:UIReturnKeyDone keyboardType:UIKeyboardTypeDefault clearButtonMode:UITextFieldViewModeWhileEditing addView:self.view];
    textField.disEmoji = YES;
    textField.frame = CGRectMake(30, 30, 300, 50);
    textField.backgroundColor = [UIColor yellowColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
