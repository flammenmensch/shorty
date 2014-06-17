//
//  ViewController.h
//  Shorty
//
//  Created by Алексей Протасов on 17.06.14.
//  Copyright (c) 2014 Alexey Protasov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *shortenButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shortLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clipboardButton;

- (IBAction)shortenURL:(id)sender;
- (IBAction)clipboardURL:(id)sender;

@end
