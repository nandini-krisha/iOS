//
//  ViewController.h
//  CurrencyConverter
//
//  Created by Nandini  Sundara Raman on 11/26/13.
//  Copyright (c) 2013 Nandini Sundara Raman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyPickerViewController.h"
#import "UIVoicedLabel.h"

@interface ViewController : UIViewController<CurrencyConverterDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIVoicedLabel *applicationSummary;
@property (strong, nonatomic) IBOutlet UIButton *fromButton;
@property (strong, nonatomic) IBOutlet UIButton *toButton;
@property (strong, nonatomic) IBOutlet UITextField *amountValue;
@property (strong, nonatomic) IBOutlet UIButton *updateButton;
@property (strong,nonatomic) NSDictionary *listOfCurrencyRates;
- (IBAction)convertAmount:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *swapButton;
@property (strong, nonatomic) IBOutlet UIButton *convertButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIVoicedLabel *resultLabel;
@property (strong, nonatomic) IBOutlet UIVoicedLabel *amountCurrency;
@property (strong, nonatomic) IBOutlet UIVoicedLabel *resultCurrency;
@property (strong, nonatomic) IBOutlet UITextField *year;
@property (strong, nonatomic) IBOutlet UITextField *month;
@property (strong, nonatomic) IBOutlet UITextField *date;
@property (strong, nonatomic) NSString *alertDateString;
@property (strong, nonatomic) NSString *alertString;
- (IBAction)updateDate:(id)sender;
- (IBAction)swapCurrencies:(id)sender;
- (IBAction)clearValues:(id)sender;
-(void)validateDate;
@end
