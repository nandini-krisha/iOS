//
//  ViewController.m
//  CurrencyConverter
//
//  Created by Nandini  Sundara Raman on 11/26/13.
//  Copyright (c) 2013 Nandini Sundara Raman. All rights reserved.
//

#import "ViewController.h"
#import "CurrencyPickerViewController.h"
#import "AFNetworking.h"

#define kCurrencyRatesURL @"http://openexchangerates.org/api/latest.json?app_id=b89f919cd13e4ffba739e82d73b70040"

@interface ViewController ()

@end

@implementation ViewController
@synthesize alertDateString;
@synthesize alertString;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getCurrencyRatesWithBaseUSD:nil];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    numberToolbar.isAccessibilityElement = NO;
    
    self.year.isAccessibilityElement = YES;
    self.year.accessibilityLabel = @"Enter Year";
    
    self.month.isAccessibilityElement = YES;
    self.month.accessibilityLabel = @"Enter Month";
    
    self.date.isAccessibilityElement = YES;
    self.date.accessibilityLabel = @"Enter Date";

    
    self.updateButton.isAccessibilityElement = YES;
    self.updateButton.accessibilityLabel = @"Update Date";
    self.updateButton.accessibilityTraits = UIAccessibilityTraitButton;

    
    self.fromButton.isAccessibilityElement = YES;
    self.fromButton.accessibilityLabel = @"Choose FROM Currency";
    self.fromButton.accessibilityTraits = UIAccessibilityTraitButton;
    [self.view addSubview:self.fromButton];
    
    self.amountValue.isAccessibilityElement = YES;
    if([self.amountValue.text length] != 0)
    {
        NSString *resultString = [NSString stringWithFormat:@"You have entered amount : %@",self.amountValue.text];
        self.amountValue.accessibilityLabel = resultString;
    }
    else
        self.amountValue.accessibilityLabel = @"Enter Amount";
    self.amountValue.accessibilityTraits = UIAccessibilityTraitNone;
    
    self.toButton.isAccessibilityElement = YES;
    self.toButton.accessibilityLabel = @"Choose TO Currency";
    self.toButton.accessibilityTraits = UIAccessibilityTraitButton;
    
    self.swapButton.isAccessibilityElement = YES;
    self.swapButton.accessibilityLabel = @"Swap entered currencies";
    self.swapButton.accessibilityTraits = UIAccessibilityTraitButton;
    
    self.convertButton.isAccessibilityElement = YES;
    self.convertButton.accessibilityLabel = @"Perform conversion";
    self.convertButton.accessibilityTraits = UIAccessibilityTraitButton;
    
    self.clearButton.isAccessibilityElement = YES;
    self.clearButton.accessibilityLabel = @"Clear entered values";
    self.clearButton.accessibilityTraits = UIAccessibilityTraitButton;

    self.amountValue.inputAccessoryView = numberToolbar;
    self.year.inputAccessoryView = numberToolbar;
    self.month.inputAccessoryView = numberToolbar;
    self.date.inputAccessoryView = numberToolbar;
	// Do any additional setup after loading the view, typically from a nib.
}

-(BOOL)shouldGroupAccessibilityChildren {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.fromButton);
}

-(void)viewWillAppear:(BOOL)animated
{
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.fromButton);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    [segue.destinationViewController setDelegate:self];
    if([segue.identifier isEqualToString:@"fromValuePickerSegue"])
    {
        [[segue destinationViewController] setFromOrTo:@"from"];
    }
    else if([segue.identifier isEqualToString:@"toValuePickerSegue"])
    {
        [[segue destinationViewController] setFromOrTo:@"to"];
    }
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
}

-(void)sendCurrencyToConverter:(id)controller didFinishChoosingCurrency:(NSString *)currency name:(NSString *)currencyName type:(NSString *)fromOrTo
{
    NSLog(@"I am back here...");
    if([fromOrTo isEqualToString:@"from"])
    {
        NSLog(@"Here at from: %@",currency);
        [self.fromButton setTitle:currency forState:UIControlStateNormal];
        NSLog(@"From label %@",self.fromButton.titleLabel.text);
        [self.amountCurrency setText:currency];
        self.amountCurrency.accessibilityLabel = currencyName;
        self.fromButton.accessibilityLabel = [NSString stringWithFormat:@"Current From Currency : %@. Click to update",self.amountCurrency.accessibilityLabel];
    }
    if([fromOrTo isEqualToString:@"to"])
    {
        NSLog(@"Here at to:");
        [self.toButton setTitle:currency forState:UIControlStateNormal];
        NSLog(@"From label %@",self.toButton.titleLabel.text);
        [self.resultCurrency setText:currency];
        self.resultCurrency.accessibilityLabel = currencyName;
        self.toButton.accessibilityLabel = [NSString stringWithFormat:@"Current To Currency : %@. Click to update",self.resultCurrency.accessibilityLabel];
    }
}

-(void)getCurrencyRatesWithBaseUSD:(NSString *)date
{
    NSURL *urlCurrencyRates;
    if(date == nil)
    {
         urlCurrencyRates = [NSURL URLWithString:kCurrencyRatesURL];
    }
    else
    {
        NSString *url = [[NSString alloc] initWithFormat:@"http://openexchangerates.org/api/historical/%@.json?app_id=b89f919cd13e4ffba739e82d73b70040",date];
        urlCurrencyRates = [NSURL URLWithString:url];
    }
    NSURLRequest *requestCurrencyRates = [NSURLRequest requestWithURL:urlCurrencyRates];
    AFJSONRequestOperation *operationCurrencyRates = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestCurrencyRates
                                                                                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                                         
                                                                                                         self.listOfCurrencyRates = [JSON
                                                                                                                                     objectForKey:@"rates"];
                                                                                                         
                                                                                                         NSLog(@"%@",self.listOfCurrencyRates);
                                                                                                         
                                                                                                     }
                                                      
                                                                                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                                         NSLog(@"Request Failed : %@, %@",error,error.userInfo);
                                                                                                     }];
    [operationCurrencyRates start];
}

- (IBAction)convertAmount:(id)sender {
    [self convert];
}

-(void)convert {
    NSString *FROMvalue = [self.listOfCurrencyRates objectForKey:self.amountCurrency.text];
    NSLog(@"FROM %@, %@",self.amountCurrency.text,FROMvalue);
    NSString *TOvalue = [self.listOfCurrencyRates objectForKey:self.resultCurrency.text];
    NSLog(@"TO %@, %@",self.resultCurrency.text,TOvalue);
    double from = [FROMvalue doubleValue];
    double to = [TOvalue doubleValue];
    double amount = [self.amountValue.text doubleValue];
    self.alertString = @"";
    if(self.fromButton.titleLabel.text.length != 3 || from==0)
    {
        self.alertString = [self.alertString stringByAppendingString:@"Choose a valid from currency.\n"];
        NSLog(@"%@",self.alertString);
    }
    if(self.toButton.titleLabel.text.length != 3 || to==0)
    {
        self.alertString = [self.alertString stringByAppendingString:@"Choose a valid to currency.\n"];
        NSLog(@"Choose a valid to currency.");
    }
    if([self.amountValue.text length]==0)
    {
        self.alertString = [self.alertString stringByAppendingString:@"Enter a valid amount.\n"];
        NSLog(@"Enter a valid amount");
    }

    NSLog(@"ALERT : %@",self.alertString);
    if([self.alertString length] != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Values Error" message: self.alertString delegate: self
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        [alert show];
        self.alertString = @"";
    }


    double result = (amount * to)/from;
    NSLog(@"%f",result);
    if(!isnan(result))
    {
        self.resultLabel.text = [NSString stringWithFormat:@"%.2f",result];
        self.resultLabel.accessibilityLabel = [NSString stringWithFormat:@"Result amount : %.2f %@",[[NSString stringWithFormat:@"%.2f",result] floatValue],self.resultCurrency.accessibilityLabel];
   //     self.resultValue.text = [NSString stringWithFormat:@"%.2f",result];
   //     self.resultValue.accessibilityLabel = [NSString stringWithFormat:@"Result amount : %@ %@",[NSString stringWithFormat:@"%.2f",result],self.resultCurrency.accessibilityLabel];
    }
}
/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.amountValue resignFirstResponder];
    [self.year resignFirstResponder];
    [self.month resignFirstResponder];
    [self.date resignFirstResponder];
}*/

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
}

- (IBAction)updateDate:(id)sender {
    [self validateDate];
    if([self.alertDateString length] != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Date Error" message: self.alertDateString delegate: self
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        [alert show];
    }
    else
    {
        NSString *dateformat = [[NSString alloc] initWithFormat:@"%@-%@-%@",self.year.text,self.month.text,self.date.text];
        [self getCurrencyRatesWithBaseUSD:dateformat];
        self.alertDateString = @"";
    }
}

- (IBAction)swapCurrencies:(id)sender {
    NSString *temp = self.fromButton.titleLabel.text;
    NSLog(@"Swapped currency %@",temp);
    [self.fromButton setTitle:self.toButton.titleLabel.text forState:UIControlStateNormal];
    [self.toButton setTitle:temp forState:UIControlStateNormal];
    
    temp = self.amountCurrency.text;
    [self.amountCurrency setText:self.resultCurrency.text];
    [self.resultCurrency setText:temp];
    
    temp = self.amountCurrency.accessibilityLabel;
    self.amountCurrency.accessibilityLabel = self.resultCurrency.accessibilityLabel;
    self.resultCurrency.accessibilityLabel = temp;
    
    self.fromButton.accessibilityLabel = [NSString stringWithFormat:@"Current From Currency : %@. Click to update ",self.amountCurrency.accessibilityLabel];
    self.toButton.accessibilityLabel = [NSString stringWithFormat:@"Current To Currency : %@. Click to update",self.resultCurrency.accessibilityLabel];
    
    [self convert];
}

- (IBAction)clearValues:(id)sender {
    [self clear];
}

-(void)clear
{
    [self.fromButton setTitle:@"Click to update" forState:UIControlStateNormal];
    [self.toButton setTitle:@"Click to update" forState:UIControlStateNormal];
    self.fromButton.accessibilityLabel = @"Choose FROM Currency";
    self.toButton.accessibilityLabel = @"Choose TO Currency";
    [self.amountCurrency setText:@""];
    self.amountCurrency.accessibilityLabel = @"";
    [self.resultCurrency setText:@""];
    self.resultCurrency.accessibilityLabel = @"";
    [self.amountValue setText:@""];
    [self.resultLabel setText:@""];
    self.resultLabel.accessibilityLabel = @"";
    [self.year setText:@""];
    [self.month setText:@""];
    [self.date setText:@""];
    [self getCurrencyRatesWithBaseUSD:nil];
}

-(void)validateDate
{

    NSLog(@"%d",[self.year.text intValue]);
    NSLog(@"%d",[self.month.text intValue]);
    NSLog(@"%d",[self.date.text intValue]);
    self.alertDateString = @"";
    if([self.year.text intValue] < 1999 || [self.year.text intValue] > 2013)
    {
        self.alertDateString = [self.alertDateString stringByAppendingString:@"Enter a valid year.\n"];
        NSLog(@"Enter a valid year");
        [self.year setText:@""];
    }
    if([self.month.text intValue] < 1 || [self.month.text intValue] > 12)
    {
        self.alertDateString = [self.alertDateString stringByAppendingString:@"Enter a valid month.\n"];
        NSLog(@"Enter a valid month");
        [self.month setText:@""];
    }
    if([self.date.text intValue] < 1 || [self.date.text intValue] > 31)
    {
        self.alertDateString = [self.alertDateString stringByAppendingString:@"Enter a valid date - First pass.\n"];
        NSLog(@"Enter a valid date - First pass");
        [self.date setText:@""];
    }
    if([self.month.text intValue] == 1 || [self.month.text intValue] == 3 || [self.month.text intValue] == 5 || [self.month.text intValue] == 7 || [self.month.text intValue] == 8 || [self.month.text intValue] == 10 || [self.month.text intValue] == 12)
    {
        if([self.date.text intValue] < 1 || [self.month.text intValue] > 31)
        {
            self.alertDateString = [self.alertDateString stringByAppendingString:@"Enter a valid date - Second pass.\n"];
            NSLog(@"Enter a valid date - Second pass");
            [self.date setText:@""];
        }
    }
    if([self.month.text intValue] == 4 || [self.month.text intValue] == 6 || [self.month.text intValue] == 9 || [self.month.text intValue] == 11)
    {
        if([self.date.text intValue] < 1 || [self.date.text intValue] > 30)
        {
            self.alertDateString = [self.alertDateString stringByAppendingString:@"Enter a valid date - Second pass.\n"];
            NSLog(@"Enter a valid date - Second pass");
            [self.date setText:@""];
        }
    }
    if([self.month.text intValue]==2)
    {
        if(([self.year.text intValue]%4==0 && [self.year.text intValue]%100!=0)||[self.year.text intValue]%400==0)
        {
            if([self.date.text intValue] < 1 || [self.date.text intValue] > 29)
            {
                self.alertDateString = [self.alertDateString stringByAppendingString:@"Enter a valid date - Second pass.\n"];
                NSLog(@"Enter a valid date - Second pass");
                [self.date setText:@""];
            }

        }
        else
        {
            if([self.date.text intValue] < 1 || [self.month.text intValue] > 28)
            {
                self.alertDateString = [self.alertDateString stringByAppendingString:@"Enter a valid date - Second pass.\n"];
                NSLog(@"Enter a valid date");
                [self.month setText:@""];
            }
        }
    }
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)doneWithNumberPad{
    [self.amountValue resignFirstResponder];
    [self.year resignFirstResponder];
    [self.month resignFirstResponder];
    [self.date resignFirstResponder];
}

@end