//
//  SignUpViewController.m
//  ObjcSegmentUserApp
//
//  Created by FUJITSU CLOUD TECHNOLOGIES on 2016/10/26.
//  Copyright 2020 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

#import "SignUpViewController.h"
#import "NCMB/NCMB.h"

@interface SignUpViewController ()

// UserName
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
// Password
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField_second;
// errorLabel
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation SignUpViewController

// 画面表示時に実行される
- (void)viewDidLoad {
    [super viewDidLoad];
    // Passwordをセキュリティ入力に設定する
    self.passwordTextField.secureTextEntry = true;
    self.passwordTextField_second.secureTextEntry = true;
    
}

// SignUpボタン押下時の処理
- (IBAction)signUpBtn:(UIButton *)sender {
    // キーボードを閉じる
    [self closeKeyboad];
    
    // 入力確認
    if (self.userNameTextField.text.length == 0 || self.passwordTextField.text.length == 0 || self.passwordTextField_second.text.length == 0) {
        self.errorLabel.text = @"未入力の項目があります";
        // TextFieldを空に
        [self cleanTextField];
        
        return;
    } else if (![self.passwordTextField.text isEqualToString:self.passwordTextField_second.text]) {
        self.errorLabel.text = @"passwordが一致しません";
        // TextFieldを空に
        [self cleanTextField];
        
        return;
        
    }
    
    //NCMBUserのインスタンスを作成
    NCMBUser *user = [NCMBUser user];
    //ユーザー名を設定
    user.userName = self.userNameTextField.text;
    //パスワードを設定
    user.password = self.passwordTextField.text;
    
    //会員の登録を行う
    [user signUpInBackgroundWithBlock:^(NSError *error) {
        // TextFieldを空に
        [self cleanTextField];
        
        if (error) {
            // 新規登録失敗時の処理
            self.errorLabel.text = [NSString stringWithFormat: @"ログインに失敗しました:%ld", (long)error.code];
            NSLog(@"ログインに失敗しました:%ld", (long)error.code);
            
        } else {
            // 新規登録成功時の処理
            [self performSegueWithIdentifier:@"signUp" sender:self];
            NSLog(@"ログインに成功しました:%@", user.objectId);
            
        }
        
    }];
    
}

// 背景をタップするとキーボードを隠す
- (IBAction)tapScreen:(UITapGestureRecognizer *)sender {
    [self.view endEditing: YES];
    
}

// TextFieldを空にする
- (void)cleanTextField {
    self.userNameTextField.text = @"";
    self.passwordTextField.text = @"";
    self.passwordTextField_second.text = @"";
    
}

// errorLabelを空にする
- (void)cleanErrorLabel {
    self.errorLabel.text = @"";
    
}

// キーボードを閉じる
- (void)closeKeyboad {
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.passwordTextField_second resignFirstResponder];
    
}

@end
