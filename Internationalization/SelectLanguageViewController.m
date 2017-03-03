//
//  SelectLanguageViewController.m
//  Internationalization
//
//  Created by lyl on 2017/2/22.
//  Copyright © 2017年 lyl. All rights reserved.
//

#import "SelectLanguageViewController.h"
#import "ViewController.h"
#import "NSBundle+Language.h"
#import "SelectLanguageTableViewCell.h"
#import "MBProgressHUD.h"
#import "Interface_language.h"

@interface SelectLanguageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@end

@implementation SelectLanguageViewController
{
    NSArray *arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@selectPageTitle, nil);
//    NSLog(@"title..%@\n",NSLocalizedString(@selectPageTitle, nil));
    arr = [[NSArray alloc] initWithObjects:NSLocalizedString(@Chinese, nil),NSLocalizedString(@English, nil), NSLocalizedString(@French, nil), nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 375, 603)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

#pragma mark --- TableView协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section    //表头内容高度
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section    //表尾内容高度
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   //每行内容高度
{
    UITableViewCell * cell  = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView    //tableview有几组内容
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section     //每组内容个数
{
    return arr.count;
}

#pragma mark --- 表头与表尾
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}   //自定义表头视图

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section     //表尾视图
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath       //每行内容
{
    
    static NSString * CellIdenfifier = @"SelectLanguageTableViewCell";
    
    SelectLanguageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdenfifier];
    
    
    if (!cell) {
        cell = [[SelectLanguageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdenfifier];
    }
    
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath      //某行选中的效果
{
    //设置系统语言
    if (indexPath.row == 0) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] hasPrefix:@"zh-Hans"]) {
            return;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"Language"];
        
        
        [NSBundle setLanguage:@"zh-Hans"];
        
    }else if (indexPath.row == 1){
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] hasPrefix:@"en"]) {
            return;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"Language"];
        [NSBundle setLanguage:@"en"];
    }else if (indexPath.row == 2) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] hasPrefix:@"fr"]) {
            return;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@"fr" forKey:@"Language"];
        [NSBundle setLanguage:@"fr"];
    }
    
    //强制存储
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_tableView reloadData];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //刷新整个视图
        ViewController *VC = [[ViewController alloc] init];
        UINavigationController * naviVC = [[UINavigationController alloc] initWithRootViewController:VC];
        [UIApplication sharedApplication].delegate.window.rootViewController  =   naviVC;
        
    });   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
