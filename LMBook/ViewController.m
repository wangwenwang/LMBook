//
//  ViewController.m
//  LMBook
//
//  Created by 凯东源 on 2017/8/17.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (assign, nonatomic) int LM;

@property (assign, nonatomic) BOOL requestOK;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://m.bqg5200.com/wapbook-3676_71/"]];
    
    [_webView loadRequest:request];
    
    _webView.delegate = self;
    
    //document.getElementsByClassName('pageinput')[0].style.display = 'none'
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        //////得到请求返回的内容
        NSString *html_content = [[NSString alloc] initWithData:data encoding:enc];
        
//        [_webView loadHTMLString:html_content baseURL:nil];
        
        ///////替换内容
        NSLog(@"");
    }];
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma MARK: - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.querySelector('[id^=\"__\"]').style.display = 'none'"];
    
    NSString * html = [webView stringByEvaluatingJavaScriptFromString: @"document.documentElement.innerHTML"];
    
    html = [html stringByReplacingOccurrencesOfString:@"gif" withString:@""];
    
//    html = [self htmlEntityDecode:html];
    
    _LM ++;
    
    if(_LM == 2 && _requestOK == NO) {
        
        [_webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://m.bqg5200.com/wapbook-3676_71/"]];
        _LM = 0;
        _requestOK = YES;
    }
}

- (NSString *)htmlEntityDecode:(NSString *)string
{
    //将特殊字符替换了
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    // 图片自适应
    string = [NSString stringWithFormat:@"<html> \n"
              "<head> \n"
              "<style type=\"text/css\"> \n"
              "</style> \n"
              "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\">"
              
              "</head> \n"
              "<body>"
              "<script type='text/javascript'>"
              "window.onload = function(){\n"
              "var $img = document.getElementsByTagName('img');\n"
              "for(var p in  $img){\n"
              " $img[p].style.width = '100%%';\n"
              "$img[p].style.height ='auto'\n"
              "}\n"
              "}"
              "</script>%@"
              "</body>"
              "</html>",string];
    return string;
}


@end
