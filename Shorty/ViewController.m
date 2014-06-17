//
//  ViewController.m
//  Shorty
//
//  Created by Алексей Протасов on 17.06.14.
//  Copyright (c) 2014 Alexey Protasov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSURLConnection *shortenURLConnection;
    NSMutableData *shortURLData;
}
@end

#define kGoDaddyAccountKey @"8f43a3be19894a7086094f83e39acc65"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) changeNeworkActivityVisibility:(BOOL)visible {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
}

- (IBAction)loadLocation:(id)sender {
    NSString *urlText = self.urlField.text;
    
    if (![urlText hasPrefix:@"http:"] && ![urlText hasPrefix:@"https:"]) {
        if (![urlText hasPrefix:@"//"]) {
            urlText = [@"//" stringByAppendingString:urlText];
        }
        urlText = [@"http:" stringByAppendingString:urlText];
    }
    
    NSURL *url = [NSURL URLWithString:urlText];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self changeNeworkActivityVisibility:YES];
}

- (IBAction)shortenURL:(id)sender {
    NSString *urlToShorten = self.webView.request.URL.absoluteString;
    NSString *urlString = [NSString stringWithFormat:@"http://api.x.co/Squeeze.svc/text/%@?url=%@", kGoDaddyAccountKey, [urlToShorten stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    shortURLData = [NSMutableData new];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    shortenURLConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    self.shortenButton.enabled = NO;
    
    [self changeNeworkActivityVisibility:YES];
}

- (IBAction)clipboardURL:(id)sender {
    NSString *shortURLString = self.shortLabel.title;
    NSURL *shortURL = [NSURL URLWithString:shortURLString];
    
    [[UIPasteboard generalPasteboard] setURL:shortURL];
}

// WebView delegate methods
- (void) webViewDidStartLoad:(UIWebView *)webView {
    self.shortenButton.enabled = NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    self.shortenButton.enabled = YES;
    self.urlField.text = webView.request.URL.absoluteString;
    
    [self changeNeworkActivityVisibility:NO];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSString *message = [NSString stringWithFormat:@"A problem occurred trying to load this page: %@", error.localizedDescription];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not load URL" message:message delegate:nil cancelButtonTitle:@"That's sad" otherButtonTitles:nil, nil];
    
    [alert show];
    
    [self changeNeworkActivityVisibility:NO];
}

// NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.shortLabel.title = @"failed";
    self.clipboardButton.enabled = NO;
    self.shortenButton.enabled = YES;
    
    [self changeNeworkActivityVisibility:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [shortURLData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *shortURLString = [[NSString alloc] initWithData:shortURLData encoding:NSUTF8StringEncoding];
    
    self.shortLabel.title = shortURLString;
    self.clipboardButton.enabled = YES;
    
    [self changeNeworkActivityVisibility:NO];
}

@end
