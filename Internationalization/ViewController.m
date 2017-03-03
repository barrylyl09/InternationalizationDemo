//
//  ViewController.m
//  Internationalization
//
//  Created by lyl on 2017/2/22.
//  Copyright © 2017年 lyl. All rights reserved.
//

#import "ViewController.h"
#import "Interface_language.h"
#import "SelectLanguageViewController.h"
#import "Masonry.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = NSLocalizedString(@back, nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@back, nil) style:UIBarButtonItemStyleDone target:nil action:nil];
    [self setUI];
}

- (void)injected{
    NSLog(@"I've been injected: %@", self);
    
    
}

#pragma mark ---setUI
- (void)setUI
{
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:NSLocalizedString(@selectLanguageBtn, nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor blackColor];
    NSString *str1 = [NSString stringWithFormat:@"%@: ",NSLocalizedString(@currentLanguage, nil)];
    NSString *str2 = NSLocalizedString(@language, nil);
    label.text = [str1 stringByAppendingString:str2];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 30));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(btn.mas_top).offset(-80);
        
    }];
    
}

- (void)pushVC
{
    SelectLanguageViewController *VC = [[SelectLanguageViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
