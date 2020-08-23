//
//  ViewController.m
//  XYDeviceInfo
//
//  Created by steve on 2020/7/22.
//

#import "ViewController.h"
#import "XYTableViewController.h"
#import <StoreKit/StoreKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor orangeColor];
    button.frame = CGRectMake(self.view.frame.size.width/2 - 250/2, 100, 250, 40);
    [button setTitle:@"TEST" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - click

- (void)testClick {
    XYTableViewController *vc = [[XYTableViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

@end
