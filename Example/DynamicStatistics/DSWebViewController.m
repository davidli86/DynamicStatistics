//
//  DSWebViewController.m
//  DynamicStatistics
//
//  Created by David Li on 12/10/2017.
//  Copyright © 2017 492334421@qq.com. All rights reserved.
//

#import "DSWebViewController.h"

@interface DSWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Show tabs" style:UIBarButtonItemStylePlain target:self action:@selector(showTab)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)showTab
{
    [self performSegueWithIdentifier:@"showTab" sender:nil];
}


@end
