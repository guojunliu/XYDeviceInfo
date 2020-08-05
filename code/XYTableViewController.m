//
//  XYTableViewController.m
//  XYDeviceInfo
//
//  Created by steve on 2020/7/23.
//

#import "XYTableViewController.h"
#import "XYDeviceInfoModel.h"
#import "XYLocalized.h"
#import "XYSystemUtil.h"
//#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
//    #import <AppTrackingTransparency/AppTrackingTransparency.h>
//#endif
#import "XYATTrackingManager.h"
#import <AdSupport/AdSupport.h>

@interface XYTableViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataSourceArr;
    
    UIBarButtonItem *_shareItem;
    UIBarButtonItem *_copyItem;
    UIBarButtonItem *_doneItem;
    
    BOOL _showCheck;
    
    BOOL _willCopy;
    BOOL _willShare;
}
@end

@implementation XYTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = XYLocalizedString(@"设备信息");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:18/255.0 green:150/255.0 blue:219/255.0 alpha:1]}];//#1296DB
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshBtn.frame = CGRectMake(0, 0, 20, 20);
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [v addSubview:refreshBtn];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:refreshItem, nil]];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareBtn.frame = CGRectMake(0, 0, 20, 20);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [v1 addSubview:shareBtn];
    _shareItem = [[UIBarButtonItem alloc] initWithCustomView:v1];
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    copyBtn.frame = CGRectMake(0, 0, 20, 20);
    [copyBtn setBackgroundImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [v2 addSubview:copyBtn];
    _copyItem = [[UIBarButtonItem alloc] initWithCustomView:v2];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneBtn.frame = CGRectMake(0, 0, 20, 20);
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [v3 addSubview:doneBtn];
    _doneItem = [[UIBarButtonItem alloc] initWithCustomView:v3];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:_shareItem, _copyItem, nil]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 转屏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    [self createData];
    [self requestIdfa];
}

- (void)createData {
    _dataSourceArr = [[NSMutableArray alloc] init];
    
    NSDictionary *dic1 = @{XYLocalizedString(@"系统信息"):[XYDeviceInfoModel getSystemInfoArray]};
    NSDictionary *dic2 = @{XYLocalizedString(@"屏幕信息"):[XYDeviceInfoModel getScreenInfoArray]};
    NSDictionary *dic3 = @{XYLocalizedString(@"CPU信息"):[XYDeviceInfoModel getCPUInfoArray]};
    NSDictionary *dic4 = @{XYLocalizedString(@"内存信息"):[XYDeviceInfoModel getMemoryInfoArray]};
    NSDictionary *dic5 = @{XYLocalizedString(@"硬盘信息"):[XYDeviceInfoModel getDiskInfoArray]};
    NSDictionary *dic6 = @{XYLocalizedString(@"电池信息"):[XYDeviceInfoModel getBatteryInfoArray]};
    NSDictionary *dic7 = @{XYLocalizedString(@"网络信息"):[XYDeviceInfoModel getNetworkInfoArray]};
    NSDictionary *dic8 = @{XYLocalizedString(@"广告信息"):[XYDeviceInfoModel getAdInfoArray]};
    
    [_dataSourceArr addObject:dic8];
    [_dataSourceArr addObject:dic1];
    [_dataSourceArr addObject:dic2];
    [_dataSourceArr addObject:dic3];
    [_dataSourceArr addObject:dic4];
    [_dataSourceArr addObject:dic5];
    [_dataSourceArr addObject:dic6];
    [_dataSourceArr addObject:dic7];
    
    [_tableView reloadData];
}

#pragma mark - request idfa

- (void)requestIdfa {
    
    // iOS 14请求idfa权限
    if (@available(iOS 14.0, *)) {
        ATTrackingManagerAuthorizationStatus states = [XYATTrackingManager trackingAuthorizationStatus];
        if (states == ATTrackingManagerAuthorizationStatusNotDetermined) {
            // 未提示用户

            [XYATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 获取到权限后，依然使用老方法获取idfa
                    if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                        [self createData];
                    }
                    else {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:XYLocalizedString(@"请在设置-隐私-Tracking中允许App请求跟踪") preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action2 = [UIAlertAction actionWithTitle:XYLocalizedString(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                        [alert addAction:action2];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                });
            }];
        }
        else if (states == ATTrackingManagerAuthorizationStatusRestricted) {
            // 限制使用
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:XYLocalizedString(@"请在设置-隐私-Tracking中允许App请求跟踪") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:XYLocalizedString(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (states == ATTrackingManagerAuthorizationStatusDenied) {
            // 拒绝
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:XYLocalizedString(@"请在设置-隐私-Tracking中允许App请求跟踪") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:XYLocalizedString(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (states == ATTrackingManagerAuthorizationStatusAuthorized) {
        }
        
//        BOOL b = [XYSystemUtil canUseIDFA];
//        if (!b) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:XYLocalizedString(@"请在设置-隐私-Tracking中允许App请求跟踪") preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action2 = [UIAlertAction actionWithTitle:XYLocalizedString(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
//            [alert addAction:action2];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
    }
    else {
        BOOL b = [XYSystemUtil canUseIDFA];
        if (!b) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:XYLocalizedString(@"请在设置-隐私-广告中允许App请求跟踪") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:XYLocalizedString(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - UIApplicationDidChangeStatusBarFrameNotification

- (void)didChangeRotate:(NSNotification*)notice {
    _tableView.frame = self.view.frame;
}



#pragma mark - click

- (void)refreshClick {
    [self createData];
}

- (void)copyBtnClick {
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:_doneItem, nil]];
    _showCheck = YES;
    [_tableView reloadData];
    
    _willCopy = YES;
}

- (void)shareBtnClick {
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:_doneItem, nil]];
    _showCheck = YES;
    [_tableView reloadData];
    
    _willShare = YES;
}

- (void)doneBtnClick {
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:_shareItem, _copyItem, nil]];
    _showCheck = NO;
    [_tableView reloadData];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i = 0; i < _dataSourceArr.count; i++) {
        NSDictionary *dic = [_dataSourceArr objectAtIndex:i];
        NSArray *arr = [dic objectForKey:[[dic allKeys] objectAtIndex:0]];
        for (int j = 0; j<arr.count; j++) {
            XYDeviceInfoModel *model = [arr objectAtIndex:j];
            if (model.check) {
                NSString *s = [NSString stringWithFormat:@"%@:%@",model.title,model.message];
                [str appendString:s];
                [str appendString:@"\n"];
            }
        }
    }
    
    if (str == nil || str.length <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:XYLocalizedString(@"未选择任何信息") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:XYLocalizedString(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (_willCopy) {
        [self copyToPasteboard:str];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:XYLocalizedString(@"已复制到剪贴板") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:XYLocalizedString(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (_willShare) {
        [self shareWithStr:str];
    }
    
    _willCopy = NO;
    _willShare = NO;
    
    NSLog(@"%@",str);
}

#pragma mark - copy

- (void)copyToPasteboard:(NSString *)str {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = str;
}

#pragma mark - share

/**
 *  分享
 *  多图分享，items里面直接放图片
 *  分享链接
 *  NSString *textToShare = @"mq分享";
 *  UIImage *imageToShare = [UIImage imageNamed:@"imageName"];
 *  NSURL *urlToShare = [NSURL URLWithString:@"https:www.baidu.com"];
 *  NSArray *items = @[urlToShare,textToShare,imageToShare];
 */
- (void)shareWithStr:(NSString *)str{
    
    NSArray *items = @[str];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if (@available(iOS 11.0, *)) {
        //UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks, UIActivityTypeMarkupAsPDF];
    }else if (@available(iOS 9.0, *)){
        //UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks];
    }else{
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail];
    }
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            
        }else{
            
        }
    };
    //这儿一定要做iPhone与iPad的判断，因为这儿只有iPhone可以present，iPad需pop，所以这儿actVC.popoverPresentationController.sourceView = self.view;在iPad下必须有，不然iPad会crash，self.view你可以换成任何view，你可以理解为弹出的窗需要找个依托。
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = vc.view;
        activityVC.popoverPresentationController.sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height, 0, 0);
        [vc presentViewController:activityVC animated:YES completion:nil];
    }else{
        [vc presentViewController:activityVC animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  _dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = [_dataSourceArr objectAtIndex:section];
    NSArray *arr = [dic objectForKey:[[dic allKeys] objectAtIndex:0]];
    return arr.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = [_dataSourceArr objectAtIndex:section];
    NSString *key = [[dic allKeys] objectAtIndex:0];
    return key;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XYTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;       
    }
    cell.textLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    NSDictionary *dic = [_dataSourceArr objectAtIndex:indexPath.section];
    NSArray *arr = [dic objectForKey:[[dic allKeys] objectAtIndex:0]];
    XYDeviceInfoModel *model = [arr objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.message;
    [cell setCheck:model.check];
    [cell setCheckShow:_showCheck];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [_dataSourceArr objectAtIndex:indexPath.section];
    NSArray *arr = [dic objectForKey:[[dic allKeys] objectAtIndex:0]];
    XYDeviceInfoModel *model = [arr objectAtIndex:indexPath.row];
    model.check = !model.check;
    
    XYTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setCheck:model.check];
}

@end

@interface XYTableViewCell () {
    UIImageView *_checkView;
    BOOL _check;
    UIView *aa;
}
@end

@implementation XYTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _checkView = [[UIImageView alloc] init];
        _checkView.image = [UIImage imageNamed:@"uncheck"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _checkView.frame = CGRectMake(self.frame.size.width - 35, self.frame.size.height/2 - 24/2, 24, 24);
}

- (void)setCheckShow:(BOOL)b {
    _checkView.hidden = !b;
    self.accessoryView = b?_checkView:nil;
}

- (void)setCheck:(BOOL)b {
    if (b) {
        _checkView.image = [UIImage imageNamed:@"check"];
    }
    else {
        _checkView.image = [UIImage imageNamed:@"uncheck"];
    }
    _check = b;
}

@end
